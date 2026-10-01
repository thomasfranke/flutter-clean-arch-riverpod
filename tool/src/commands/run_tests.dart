// A live test dashboard: one fixed row per group of tests, each with its own
// progress bar, driven by `flutter test --reporter=json`.
//
//   dart run tool/src/commands/run_tests.dart [--coverage] <path>...
//
// <path> is anything `flutter test` accepts — a folder such as `test/unit`,
// or a single `_test.dart` file. With none, the whole of `test/` runs.
// tool/src/commands/run_changed_tests.dart is what passes an explicit list.
//
// One invocation, many rows. This repository is a single Flutter package, so
// its suite compiles once and runs once; splitting it per row to get a row
// per run would pay that compile over and over for nothing. The rows are cut
// out of the paths instead — `test/unit/data` is the data layer, `test/widget`
// is the widget tests — which is the same grouping the folders already
// declare, read back rather than maintained twice.
//
// Why a JSON consumer rather than piping the default reporter through: that
// one tells you about one test at a time with no sense of how much is left.
// This reads the same event stream and redraws a fixed block in place, with
// every failure printed above it the instant it happens rather than scrolled
// past waiting for the run to end.
//
// No external packages — only dart:io and dart:convert — so it runs with
// nothing but the SDK already on the machine, from any directory.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../cli/dashboard.dart';
import '../repo.dart';
import '../theme/theme.dart';
import '../tty.dart';
import 'process.dart';

/// The row an architecture assertion belongs to.
const architectureRow = 'architecture';

/// The row this CLI's own tests belong to.
const cliRow = 'cli';

void main(List<String> rawArgs) async {
  final coverage = rawArgs.contains('--coverage');
  // Set by run_changed_tests.dart, which shows its own banner before doing
  // the (slower, on a big diff) work of mapping changed files to tests —
  // showing this one too would just repeat it after the fact.
  final noBanner = rawArgs.contains('--no-banner');
  final paths = rawArgs.where((a) => !a.startsWith('--')).toList();

  final root = repoRoot();
  final targets = paths.isEmpty ? const ['test'] : paths;

  final files = _testFilesUnder(root, targets);
  if (files.isEmpty) {
    stderr.writeln('No _test.dart files under ${targets.join(', ')}');
    exit(66); // EX_NOINPUT
  }

  // The rows, and which of them each file belongs to. Both come from the
  // filesystem before anything runs, so a bar has a denominator from its
  // first frame — package:test parses suites lazily, and a total taken from
  // the protocol arrives in instalments while the bar is already moving.
  final groups = <String, List<String>>{};
  for (final file in files) {
    groups.putIfAbsent(_groupOf(file), () => <String>[]).add(file);
  }
  final ordered = groups.keys.toList()..sort(_byRowOrder);
  final rows = [
    for (final name in ordered) _Row(name, fileTotal: groups[name]!.length),
  ];
  final rowOf = {for (final row in rows) row.label: row};

  if (!noBanner) await _showCompiling();

  final dashboard = _Dashboard(rows, DateTime.now());
  dashboard.render();
  // No ticker without a terminal: its only job is to advance a clock in
  // place, and in a log it would print the same frame four times a second.
  final ticker = isPlain
      ? null
      : Timer.periodic(
          const Duration(milliseconds: 250),
          (_) => dashboard.render(),
        );

  final failed = await _run(
    root,
    targets,
    rowOf,
    dashboard,
    coverage: coverage,
  );

  ticker?.cancel();
  for (final row in rows) {
    if (row.state == _RowState.running) row.settle();
  }
  dashboard.render();

  _printSummary(root, rows, dashboard, coverage: coverage);
  exit(failed ? 1 : 0);
}

/// Runs the suite once and feeds every event into the rows it belongs to.
///
/// Returns whether anything failed. The exit code is the runner's own: a
/// suite that fails to compile never emits a `testDone`, so counting failed
/// tests alone would report a green run over a tree that does not build.
Future<bool> _run(
  Directory root,
  List<String> targets,
  Map<String, _Row> rowOf,
  _Dashboard dashboard, {
  required bool coverage,
}) async {
  final passthrough = Platform.environment['TEST_ARGS'];
  final process = await Process.start('flutter', [
    'test',
    '--reporter=json',
    if (coverage) '--coverage',
    ...targets,
    if (passthrough != null && passthrough.isNotEmpty)
      ...passthrough.split(' '),
  ], workingDirectory: root.path);

  final stderrBuffer = StringBuffer();
  process.stderr.transform(utf8.decoder).listen(stderrBuffer.write);

  // Everything the protocol only says once, kept by the id it says it under.
  final suiteRow = <int, _Row>{};
  final suitePath = <int, String>{};
  final suiteTests = <int, int>{};
  final suiteFinished = <int, int>{};
  final suiteComplete = <int>{};
  final testSuite = <int, int>{};
  final testName = <int, String>{};
  final testError = <int, String>{};

  await process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) {
        if (line.trim().isEmpty) return;

        // A line that is not an event is skipped rather than fatal: the
        // runner occasionally prints something that is not JSON, and a
        // dashboard that died over it would lose a passing suite. Typed
        // rather than a bare catch, because there are exactly two ways this
        // fails — the text is not JSON, or the JSON is not an object — and a
        // bare catch would also swallow a bug in the handling below.
        final Object? decoded;
        try {
          decoded = jsonDecode(line);
        } on FormatException {
          return;
        }
        if (decoded is! Map<String, dynamic>) return;
        final event = decoded;

        switch (event['type']) {
          case 'suite':
            final suite = event['suite'] as Map<String, dynamic>;
            final id = suite['id'] as int;
            final path = _relative(root, suite['path'] as String? ?? '');
            suitePath[id] = path;
            final row = rowOf[_groupOf(path)];
            if (row != null) {
              suiteRow[id] = row;
              row.start();
            }
          case 'group':
            // The root group of a file — the one with no parent — counts
            // every test in it. Nested groups count their own share of the
            // same tests, so reading those too would multiply the total.
            final group = event['group'] as Map<String, dynamic>;
            if (group['parentID'] == null) {
              suiteTests[group['suiteID'] as int] =
                  group['testCount'] as int? ?? 0;
            }
          case 'testStart':
            final test = event['test'] as Map<String, dynamic>;
            final id = test['id'] as int;
            testSuite[id] = test['suiteID'] as int;
            testName[id] = test['name'] as String? ?? 'test';
          case 'error':
            final id = event['testID'] as int?;
            if (id != null) {
              testError[id] = (event['error'] as String? ?? '')
                  .split('\n')
                  .first;
            }
          case 'testDone':
            final id = event['testID'] as int;
            final result = event['result'] as String;
            final hidden = event['hidden'] as bool? ?? false;
            final skipped = event['skipped'] as bool? ?? false;
            final suiteId = testSuite[id];
            final row = suiteId == null ? null : suiteRow[suiteId];

            // Hidden tests — the one the runner emits for loading a file —
            // are not in the root group's count, so counting them here would
            // finish a file one test early.
            if (suiteId != null && row != null && !hidden) {
              suiteFinished[suiteId] = (suiteFinished[suiteId] ?? 0) + 1;
              final total = suiteTests[suiteId];
              if (total != null &&
                  suiteFinished[suiteId]! >= total &&
                  suiteComplete.add(suiteId)) {
                row.filesDone++;
                if (row.filesDone >= row.fileTotal) row.settle();
              }
            }

            if (skipped || hidden || result == 'success') {
              if (!hidden) row?.passed++;
            } else {
              row?.failed++;
              dashboard.logFailure(
                suiteId == null ? '?' : suitePath[suiteId] ?? '?',
                testName[id] ?? 'test',
                testError[id],
              );
            }
        }
        dashboard.render();
      });

  final code = await process.exitCode;
  if (code != 0 && stderrBuffer.isNotEmpty) {
    dashboard.log(stderrBuffer.toString().trim());
  }
  return code != 0;
}

/// The totals, and the coverage the run measured.
///
/// One coverage number, not one per row: this is a single package, so every
/// row measured the same `lib/` and which folder exercised a line does not
/// change whether it was exercised. The breakdown that *is* per layer — and
/// the thresholds — belong to `arch coverage-gate`, which is a different
/// question from "did the suite pass".
void _printSummary(
  Directory root,
  List<_Row> rows,
  _Dashboard dashboard, {
  required bool coverage,
}) {
  final passed = rows.fold(0, (a, r) => a + r.passed);
  final total = passed + rows.fold(0, (a, r) => a + r.failed);
  final elapsed = formatDuration(DateTime.now().difference(dashboard.started));

  stdout
    ..writeln()
    ..writeln('  • Summary:')
    ..writeln('    • $passed/$total')
    ..writeln('    • ⏱ $elapsed');

  if (coverage) {
    final measured = _lcovTotals(File('${root.path}/coverage/lcov.info'));
    if (measured != null) {
      final percentage = measured.hit / measured.total * 100;
      stdout.writeln('    • ◔ ${percentage.round()}%');
    }
  }

  if (dashboard.failures.isEmpty) return;

  final counts = <String, int>{};
  for (final failure in dashboard.failures) {
    counts[failure] = (counts[failure] ?? 0) + 1;
  }
  final sorted = counts.entries.toList()
    ..sort((a, b) {
      final byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });

  stdout
    ..writeln()
    ..writeln('${palette.fail}${Status.fail}${Ansi.reset} Failed files:');
  for (final entry in sorted) {
    stdout.writeln('  ${entry.value}  ${entry.key}');
  }
}

/// Every `_test.dart` under [targets], as paths relative to [root].
///
/// A target may be a file as easily as a folder — that is how a narrowed run
/// is expressed — so both are handled rather than only the common one.
List<String> _testFilesUnder(Directory root, List<String> targets) {
  final files = <String>{};
  for (final target in targets) {
    final path = '${root.path}/$target';
    if (File(path).existsSync()) {
      if (target.endsWith('_test.dart')) files.add(_normalize(target));
      continue;
    }
    final directory = Directory(path);
    if (!directory.existsSync()) continue;
    for (final entity in directory.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('_test.dart')) continue;
      files.add(_relative(root, entity.path));
    }
  }
  return files.toList()..sort();
}

/// Which row a test file belongs to.
///
/// Read out of the path, because the path is where this repository already
/// says it: `test/unit/<layer>` is that layer's unit tests, `test/widget` is
/// the widget tests, `test/integrity` holds the two suites that are about the
/// repository rather than the product. A file that fits none of it lands in
/// `test`, which is visible rather than silently dropped.
String _groupOf(String relativePath) {
  final parts = _normalize(relativePath).split('/');
  if (parts.first == e2eDirectory) return e2eKind;
  if (parts.length < 2 || parts.first != 'test') return 'test';

  final kind = parts[1];
  if (kind == 'integrity') {
    return switch (parts.last) {
      'architecture_test.dart' => architectureRow,
      'cli_test.dart' => cliRow,
      _ => 'integrity',
    };
  }
  if (kind == 'unit' && parts.length > 3 && layers.contains(parts[2])) {
    return parts[2];
  }
  return testKinds.contains(kind) ? kind : 'test';
}

/// Rows in the order the repository is read in: what is asserted about the
/// tree first, then the layers bottom-up, then the kinds that cross them.
///
/// Alphabetical would put `application` above `core` and `widget` above
/// `unit`, which is a list ordered for no reader. This one matches the
/// dependency order in [layers] and the cost order of the kinds.
int _byRowOrder(String a, String b) => _rank(a).compareTo(_rank(b));

int _rank(String row) => switch (row) {
  architectureRow => 0,
  cliRow => 1,
  _ when layers.contains(row) => 2 + layers.indexOf(row),
  'unit' => 20,
  'widget' => 21,
  'integration' => 22,
  e2eKind => 23,
  _ => 24,
};

/// [path] relative to [root], with forward slashes on every platform.
String _relative(Directory root, String path) {
  final normalized = _normalize(path);
  final prefix = '${_normalize(root.path)}/';
  return normalized.startsWith(prefix)
      ? normalized.substring(prefix.length)
      : normalized;
}

String _normalize(String path) => path.replaceAll(r'\', '/');

/// The lines found and hit in an lcov file, or `null` when there is none.
({int hit, int total})? _lcovTotals(File lcov) {
  if (!lcov.existsSync()) return null;
  var hit = 0;
  var total = 0;
  for (final line in lcov.readAsLinesSync()) {
    if (!line.startsWith('DA:')) continue;
    total++;
    if ((int.tryParse(line.substring(3).split(',').last) ?? 0) > 0) hit++;
  }
  return total > 0 ? (hit: hit, total: total) : null;
}

/// A brief banner shown before the dashboard takes over, covering the part
/// with nothing to report: `flutter test` compiles the whole package before
/// it emits its first event, and that is tens of seconds of silence.
Future<void> _showCompiling() async {
  stdout.writeln('• Compiling the test bundle...');

  // The banner exists to fill a silence someone is watching. Nobody watches a
  // log, so in plain mode the line above is the whole banner — no clock.
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

enum _RowState { queued, running, done }

/// One line of the fixed dashboard, mutated in place as its files report.
class _Row {
  _Row(this.label, {required this.fileTotal});

  final String label;

  /// How many test files this row will run, counted from disk before the
  /// first one loads.
  final int fileTotal;

  _RowState state = _RowState.queued;
  DateTime? startedAt;
  Duration? elapsed;

  /// Test files finished — every test in them accounted for.
  int filesDone = 0;

  int passed = 0;
  int failed = 0;

  /// Marks the row as running, once, from whichever of its suites loads
  /// first. The suites of one row do not start together: the runner loads
  /// them concurrently and in its own order.
  void start() {
    if (state != _RowState.queued) return;
    state = _RowState.running;
    startedAt = DateTime.now();
  }

  /// Stops the clock. Called when the last file reports, and again for
  /// anything still running when the process ends — a suite that failed to
  /// compile reports nothing at all, and a row left spinning after the run is
  /// over reads as a hang rather than as the failure it is.
  void settle() {
    if (state == _RowState.done) return;
    state = _RowState.done;
    elapsed = startedAt == null
        ? Duration.zero
        : DateTime.now().difference(startedAt!);
  }
}

/// Redraws a fixed block — a header plus one row per group — in place, making
/// room above it for failures printed live via [logFailure] and [log].
class _Dashboard extends Dashboard<_Row> {
  _Dashboard(super.rows, super.started);

  /// Every failed test's file, in the order they failed, so the summary can
  /// count them per file without holding the failures themselves.
  final List<String> failures = [];

  @override
  String labelOf(_Row row) => row.label;

  @override
  bool isSettled(_Row row) => row.state == _RowState.done;

  String _fileCounts(_Row row) => '${row.filesDone}/${row.fileTotal}';

  String _testCounts(_Row row) => '${row.passed}/${row.passed + row.failed}';

  /// How wide the files column will ever need to be.
  ///
  /// Known before anything runs, because both halves are: a row's widest
  /// spelling is the one where every file is done. That matters in a log,
  /// where each row is printed once as it settles and never repainted — a
  /// width measured only over the rows finished so far leaves the first ones
  /// narrow and the column ragged for good.
  late final int _filesWidth = rows
      .map((row) => '${row.fileTotal}/${row.fileTotal}'.length)
      .fold(0, (a, b) => a > b ? a : b);

  /// How wide the tests column has to be for the rows that have settled.
  ///
  /// Measured as they arrive, unlike the files column, because nothing says
  /// up front how many tests a file holds.
  int get _testsWidth => rows
      .where((row) => row.state == _RowState.done)
      .map((row) => _testCounts(row).length)
      .fold(0, (a, b) => a > b ? a : b);

  void logFailure(String path, String name, String? error) {
    failures.add(path);
    final buffer = StringBuffer()
      ..writeln('  ${palette.fail}${Status.fail}${Ansi.reset}  $path')
      ..writeln('     $name');
    if (error != null && error.isNotEmpty) buffer.writeln('     $error');
    log(buffer.toString().trimRight());
  }

  // Stays "Running tests" even once everything is done — "Summary" is the one
  // below, with the totals; switching this one too would print it twice.
  @override
  String header() {
    final done = rows.where(isSettled).length;
    final files = rows.fold(0, (a, r) => a + r.filesDone);
    final fileTotal = rows.fold(0, (a, r) => a + r.fileTotal);
    return '• Running tests — $done/${rows.length} groups, '
        '$files/$fileTotal files:';
  }

  @override
  String renderRow(_Row row) {
    final label = row.label.padRight(labelWidth);
    switch (row.state) {
      case _RowState.queued:
        return '${statusMark(Status.queued, palette.queued)}$label  '
            '${progressBar(0, 0)} ${row.fileTotal} files';
      case _RowState.running:
        final elapsed = formatDuration(
          DateTime.now().difference(row.startedAt!),
        );
        return '${statusMark(Status.running, palette.running)}$label  '
            '${progressBar(row.filesDone, row.fileTotal)} '
            '${_fileCounts(row)} files  •  +${row.passed} ✗${row.failed}  '
            '•  ⏱ $elapsed';
      case _RowState.done:
        final elapsed = formatDuration(row.elapsed ?? Duration.zero);
        // Both counts, in the same order and the same unit as while it ran:
        // the files the bar measured, then the tests inside them. One turning
        // into the other at the finish line reads as the number changing its
        // mind — and a file short of its total is how a suite that failed to
        // load shows up at all.
        final files = _fileCounts(row).padRight(_filesWidth);
        final tests = _testCounts(row).padRight(_testsWidth);
        final mark = row.failed == 0 && row.filesDone == row.fileTotal
            ? statusMark(Status.ok, palette.ok)
            : statusMark(Status.fail, palette.fail);
        return '$mark$label  ${progressBar(row.filesDone, row.fileTotal)} '
            '$files files  •  $tests tests  ⏱ $elapsed';
    }
  }
}
