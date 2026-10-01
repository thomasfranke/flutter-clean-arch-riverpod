// Maps a set of changed files to the specific `_test.dart` files they should
// re-run, then hands that off to run_tests.dart to execute and render.
//
//   dart run tool/src/commands/run_changed_tests.dart [--coverage] [BASE]
//   dart run tool/src/commands/run_changed_tests.dart [--coverage] --last=10
//
// Two ways to name that set, one mapping. `--last=N` takes the N most
// recently edited files under `lib/` and `test/` by modification time;
// everything else takes a git diff against BASE. The mapping below is the
// part worth not duplicating, which is why both live here.
//
// BASE defaults to $BASE, then "main". Three diff sources are unioned, so a
// changed file counts whether it is committed on the branch, only staged or
// modified, or brand new and untracked:
//
//   git diff --name-only BASE...HEAD
//   git diff --name-only HEAD
//   git ls-files --others --exclude-standard
//
// A changed `lib/` file maps to its test by filename convention alone —
// `foo.dart` -> `foo_test.dart`, wherever under `test/` it lives — because
// that is the one thing every test file in this project actually guarantees.
// There is no import-graph analysis and no layer-wide fallback: touching
// `core` does not rerun every layer above it, only the tests whose own name
// says they cover the file that changed. A changed test file is run directly.
//
// No external packages — only dart:io — so it runs with nothing but the SDK
// already on the machine, from any directory.

import 'dart:async';
import 'dart:io';

import '../repo.dart';
import '../tty.dart';
import 'process.dart';

void main(List<String> args) async {
  final coverage = args.contains('--coverage');
  final last = _lastCount(args);
  final rest = args
      .where((a) => a != '--coverage' && !a.startsWith('--last'))
      .toList();
  final base = rest.isNotEmpty
      ? rest.first
      : Platform.environment['BASE'] ?? 'main';

  // Shown here rather than left to run_tests.dart, since this script's own
  // setup — the git diff, walking `test/` for a filename match — is the part
  // that can actually take a moment on a large diff.
  await _showCompiling();

  final root = repoRoot();
  final changed = last != null
      ? _recentFiles(root, last)
      : await _changedFiles(root, base);
  stdout.writeln(
    last != null
        ? '• Last $last file(s) edited'
        : '• Diffing against $base — ${changed.length} file(s) changed',
  );
  if (changed.isEmpty) exit(0);

  final paths = _testsFor(root, changed);
  if (paths.isEmpty) {
    stdout.writeln(
      last != null
          ? 'The last $last file(s) edited map to no test.'
          : 'Changed files against $base map to no test.',
    );
    exit(0);
  }

  final process = await Process.start(
    dartExecutable,
    [
      'tool/src/commands/run_tests.dart',
      '--no-banner',
      if (coverage) '--coverage',
      ...paths,
    ],
    workingDirectory: root.path,
    mode: ProcessStartMode.inheritStdio,
  );

  final code = await process.exitCode;

  // The `◔` the dashboard prints is the whole of `lib/`, measured by whatever
  // subset of the suite just ran — which is why a narrowed run reports 12%
  // where the full run reports 100%. The number worth having after a run like
  // this is the one for the files it was narrowed to, and that is what this
  // prints.
  if (coverage && code == 0) {
    _reportCoverageOf(_sourcesAmong(changed, root), root);
  }

  exit(code);
}

/// The test files [changed] maps to, as paths relative to [root].
///
/// Three cases, and they are not symmetric. A changed test file is itself
/// what runs. A changed `lib/` file runs the test named after it. Anything
/// that describes the repository rather than the product — the pubspec, the
/// analyzer config, the CLI — runs the suite that asserts about it, because
/// nothing else would notice.
List<String> _testsFor(Directory root, List<String> changed) {
  final paths = <String>{};

  for (final path in changed) {
    if (path.startsWith('tool/') ||
        path == '$integrityDirectory/cli_test.dart') {
      paths.add('$integrityDirectory/cli_test.dart');
      continue;
    }
    if (path == 'pubspec.yaml' ||
        path == 'analysis_options.yaml' ||
        path == '$integrityDirectory/architecture_test.dart') {
      paths.add('$integrityDirectory/architecture_test.dart');
      continue;
    }
    if (path.startsWith('test/') && path.endsWith('_test.dart')) {
      paths.add(path);
      continue;
    }
    if (!path.startsWith('lib/') || !path.endsWith('.dart')) continue;

    final name = path.split('/').last;
    final wanted =
        '${name.substring(0, name.length - '.dart'.length)}_test.dart';
    for (final file in _filesNamed(testDirectory, wanted)) {
      paths.add(_relative(root, file.path));
    }
  }

  // A mapped path can still be gone by the time we get here — a test file
  // that was itself deleted in the diff. Drop those rather than hand
  // run_tests.dart a path that does not exist, which `flutter test` treats as
  // a fatal error rather than as an empty run.
  return [
    for (final path in paths)
      if (File('${root.path}/$path').existsSync()) path,
  ]..sort();
}

/// Every file under [directory] whose name is exactly [name].
Iterable<File> _filesNamed(Directory directory, String name) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.uri.pathSegments.last == name) yield entity;
  }
}

/// The production files a coverage number is about, given what changed.
///
/// Both directions of the same convention. A changed `lib/foo.dart` is itself
/// what was measured. A changed `foo_test.dart` is not — it is why something
/// ran — so what it stands for is `lib/foo.dart`, found the same way the run
/// found the test in the first place: by name.
///
/// That second direction is what makes this useful right after writing a
/// test, which is when the question "what does it actually cover" is asked.
List<String> _sourcesAmong(List<String> changed, Directory root) {
  final sources = <String>{};

  for (final path in changed) {
    if (path.startsWith('lib/') && path.endsWith('.dart')) {
      sources.add(path);
      continue;
    }
    if (!path.startsWith('test/') || !path.endsWith('_test.dart')) continue;

    final name = path.split('/').last;
    final wanted =
        '${name.substring(0, name.length - '_test.dart'.length)}.dart';
    for (final file in _filesNamed(libDirectory, wanted)) {
      sources.add(_relative(root, file.path));
    }
  }

  return sources.toList()..sort();
}

/// Prints the line coverage of [sources], file by file, worst first.
///
/// Read out of the lcov the run just wrote rather than measured again: the
/// run that finished a moment ago is the measurement, and the only thing left
/// to do is to stop averaging it over code nobody touched.
void _reportCoverageOf(List<String> sources, Directory root) {
  if (sources.isEmpty) return;

  final measured = _lcovRecords(sources, root);
  final found = measured.values.fold(0, (sum, e) => sum + e.$1);
  final hit = measured.values.fold(0, (sum, e) => sum + e.$2);

  stdout.writeln();
  if (found == 0) {
    stdout.writeln(
      '• No coverage data for the ${sources.length} file(s) that ran — '
      'nothing executable in them, or no test loads them.',
    );
    return;
  }

  // Least covered first: the file that needs a test is the one worth putting
  // where the eye lands, and on a long list the top is the only place read.
  final rows = measured.entries.toList()
    ..sort((a, b) {
      final rate = (a.value.$2 / a.value.$1).compareTo(b.value.$2 / b.value.$1);
      return rate != 0 ? rate : a.key.compareTo(b.key);
    });

  stdout.writeln('• Coverage of what you touched, least covered first:');
  for (final row in rows) {
    final (fileFound, fileHit) = row.value;
    final percent = (fileHit / fileFound * 100).toStringAsFixed(1).padLeft(5);
    stdout.writeln(
      '  $percent%  ${'$fileHit/$fileFound'.padLeft(9)}  ${row.key}',
    );
  }

  // Apart, with the reason, rather than as 0% or as nothing at all: a barrel
  // of exports and a bare enum declare no executable line, so counting them
  // as zero would understate and dropping them would overstate.
  final silent = sources.where((s) => !measured.containsKey(s)).toList()
    ..sort();
  if (silent.isNotEmpty) {
    stdout
      ..writeln()
      ..writeln(
        '  Nothing to measure in ${silent.length} more — no executable line, '
        'or no test loads them:',
      );
    for (final path in silent) {
      stdout.writeln('    $path');
    }
  }

  final percent = (hit / found * 100).toStringAsFixed(1);
  stdout
    ..writeln()
    ..writeln(
      '  $percent% of the lines you touched ($hit of $found), '
      'across ${measured.length} of ${sources.length} file(s)',
    );
}

/// The `found`/`hit` line counts each of [sources] has in `coverage/lcov.info`,
/// for the sources that appear in it at all.
///
/// `flutter test --coverage` writes paths relative to the package root —
/// `SF:lib/main.dart` — which is the same spelling the diff gave us, so the
/// two sides match without rewriting either.
Map<String, (int found, int hit)> _lcovRecords(
  List<String> sources,
  Directory root,
) {
  final lcov = File('${root.path}/coverage/lcov.info');
  if (!lcov.existsSync()) return const {};

  final wanted = sources.toSet();
  final records = <String, (int, int)>{};

  String? current;
  for (final line in lcov.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = _relative(root, line.substring(3).trim());
      current = wanted.contains(path) ? path : null;
      if (current != null) records[current] ??= (0, 0);
      continue;
    }
    if (current == null || !line.startsWith('DA:')) continue;

    final hits = int.tryParse(line.substring(3).split(',').last);
    if (hits == null) continue;
    final (found, hit) = records[current]!;
    records[current] = (found + 1, hits > 0 ? hit + 1 : hit);
  }
  return records;
}

/// A brief banner shown before setup, covering it with a live "compiling"
/// ticker instead of a silent terminal.
///
/// Duplicated from run_tests.dart rather than shared: each entry point shows
/// its own, and run_tests.dart skips it (`--no-banner`) when this one ran.
Future<void> _showCompiling() async {
  stdout.writeln('• Mapping what changed to the tests that cover it...');

  // The banner exists to fill a silence someone is watching. Nobody watches a
  // log, so in plain mode the line above is the whole banner.
  if (isPlain) return;

  stdout.writeln();
  final start = DateTime.now();
  void redraw() {
    final elapsed = DateTime.now().difference(start);
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    stdout.write('\r\x1B[K⏳ compiling…  $minutes:$seconds');
  }

  redraw();
  final ticker = Timer.periodic(const Duration(seconds: 1), (_) => redraw());
  await Future<void>.delayed(const Duration(milliseconds: 300));
  ticker.cancel();
  stdout.write('\r\x1B[K');
}

/// The `--last=N` an argument list carries, or `null` when it carries none.
///
/// A bare `--last` means the default: someone typing it is asking for "the
/// ones I just touched", not for a number they have in mind.
int? _lastCount(List<String> args) {
  final argument = args.where((a) => a.startsWith('--last')).firstOrNull;
  if (argument == null) return null;
  final equals = argument.indexOf('=');
  if (equals < 0) return _defaultLastCount;
  return int.tryParse(argument.substring(equals + 1)) ?? _defaultLastCount;
}

/// How many recently edited files `--last` takes when it is not given a
/// number. Ten is about a sitting's worth of work.
const _defaultLastCount = 10;

/// The [count] most recently edited files under `lib/` and `test/`, newest
/// first, as repository-relative paths.
///
/// Modification time rather than git, because the two answer different
/// questions: git says what differs from a commit, and this says what was
/// being worked on. A file edited and then edited back to what the commit
/// already holds is invisible to the first and is exactly what the second is
/// for.
///
/// Generated output is skipped for the mirror-image reason: one `arch codegen`
/// run stamps every `.g.dart` in the tree at once, and without this the list
/// would be ten files nobody touched.
List<String> _recentFiles(Directory root, int count) {
  final files = [
    for (final directory in [libDirectory, testDirectory])
      for (final file in _dartFilesUnder(directory))
        (modified: file.statSync().modified, path: file.path),
  ]..sort((a, b) => b.modified.compareTo(a.modified));

  return [for (final file in files.take(count)) _relative(root, file.path)];
}

/// Every `.dart` file under [directory] that someone could have written.
///
/// Walked by hand rather than with `listSync(recursive: true)` so the skipped
/// directories are never descended into at all.
Iterable<File> _dartFilesUnder(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(followLinks: false)) {
    if (entity is Directory) {
      final name = entity.path.split(Platform.pathSeparator).last;
      if (name.startsWith('.') || name == 'build' || name == 'generated') {
        continue;
      }
      yield* _dartFilesUnder(entity);
    } else if (entity is File &&
        entity.path.endsWith('.dart') &&
        !generatedSuffixes.any(entity.path.endsWith)) {
      yield entity;
    }
  }
}

/// [path] relative to [root], with forward slashes on every platform.
String _relative(Directory root, String path) {
  final normalized = path.replaceAll(r'\', '/');
  final prefix = '${root.path.replaceAll(r'\', '/')}/';
  return normalized.startsWith(prefix)
      ? normalized.substring(prefix.length)
      : normalized;
}

Future<List<String>> _changedFiles(Directory root, String base) async {
  final results = await Future.wait([
    Process.run('git', [
      'diff',
      '--name-only',
      '$base...HEAD',
    ], workingDirectory: root.path),
    Process.run('git', [
      'diff',
      '--name-only',
      'HEAD',
    ], workingDirectory: root.path),
    Process.run('git', [
      'ls-files',
      '--others',
      '--exclude-standard',
    ], workingDirectory: root.path),
  ]);

  final files = <String>{};
  for (final result in results) {
    if (result.exitCode != 0) continue;
    files.addAll(
      (result.stdout as String)
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty),
    );
  }
  return files.toList()..sort();
}
