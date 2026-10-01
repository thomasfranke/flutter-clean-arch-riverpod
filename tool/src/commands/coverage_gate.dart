// Fails the build if line coverage on any layer that has code falls under the
// threshold.
//
//   dart run tool/src/commands/coverage_gate.dart [--threshold=95]
//
// Per layer rather than one number for the repository, because one number
// hides exactly the thing a gate is for: a presentation layer at 99% and a
// data layer at 40% average out to something that passes, and the average is
// not what anyone would have agreed to. A layer with no `.dart` under `lib/`
// yet, or with code that nothing measured, is skipped rather than counted as
// 0% — the gate is about tests falling behind code, not about punishing a
// folder for not existing.
//
// It reads the lcov the test run already wrote. `arch verify` runs the suite
// with coverage immediately before this, and a failing run there halts the
// chain before this executes — so a file found here is trustworthy, and
// reusing it saves running the whole suite a second time just to gate it.
// Invoked on its own with no such file present, it measures first.
//
// No external packages — only dart:io — so it runs with nothing but the SDK
// already on the machine, from any directory.

import 'dart:io';

import '../cli/dashboard.dart';
import '../repo.dart';
import '../theme/theme.dart';
import 'process.dart';

/// The default line-coverage threshold, in percent.
///
/// 95 rather than 100: the last few lines of any tree are a `toString` and a
/// branch no test can reach without contriving one, and a gate that demands
/// them is a gate people learn to bypass.
const defaultThreshold = 95.0;

void main(List<String> args) async {
  final threshold = _threshold(args);
  final root = repoRoot();

  final lcov = File('${root.path}/coverage/lcov.info');
  if (!lcov.existsSync()) {
    stdout.writeln('  No coverage measured yet — running the suite first.');
    final measured = await Process.run(dartExecutable, [
      'tool/src/commands/run_tests.dart',
      '--coverage',
      'test',
    ], workingDirectory: root.path);
    if (measured.exitCode != 0 || !lcov.existsSync()) {
      stdout
        ..writeln(measured.stdout)
        ..writeln(measured.stderr);
      exit(1);
    }
  }

  final measured = _byLayer(lcov, root);

  stdout
    ..writeln()
    ..writeln('• Coverage gate — threshold ${threshold.toStringAsFixed(1)}%:')
    ..writeln();

  // The same label column as the test dashboard, so two reports printed by
  // the same CLI line their labels up.
  final labels = [...layers, _rootLabel];
  final width = labels
      .map((layer) => layer.length)
      .reduce((a, b) => a > b ? a : b);

  var failed = false;
  var gated = 0;
  var passed = 0;
  var linesHit = 0;
  var linesFound = 0;

  for (final layer in labels) {
    final label = layer.padRight(width);

    if (!_hasCode(root, layer)) {
      stdout.writeln(
        '${statusMark(Status.skipped, palette.skipped)}$label  '
        'no code yet, not gated',
      );
      continue;
    }

    final result = measured[layer];
    if (result == null) {
      stdout.writeln(
        '${statusMark(Status.skipped, palette.skipped)}$label  '
        'nothing measured, not gated',
      );
      continue;
    }

    gated++;
    linesHit += result.hit;
    linesFound += result.found;

    final percentage = result.hit / result.found * 100;
    final ok = percentage >= threshold;
    if (ok) {
      passed++;
    } else {
      failed = true;
    }
    final mark = ok
        ? statusMark(Status.ok, palette.ok)
        : statusMark(Status.fail, palette.fail);
    stdout.writeln(
      '$mark$label  ${percentage.toStringAsFixed(1)}% '
      '(${result.hit}/${result.found} lines)',
    );
  }

  stdout
    ..writeln()
    ..writeln('  • Summary:')
    ..writeln('    • $passed/$gated gated');
  if (linesFound > 0) {
    stdout.writeln('    • ◔ ${(linesHit / linesFound * 100).round()}%');
  }
  final verdict = failed
      ? '${palette.fail}${Status.fail}${Ansi.reset} failed'
      : '${palette.ok}${Status.ok}${Ansi.reset} passed';
  stdout.writeln('    • $verdict');

  exit(failed ? 1 : 0);
}

/// What `lib/main.dart` and anything else outside a layer is counted under.
///
/// It is code, it is gated, and it belongs to no layer — the composition root
/// never does. Naming it rather than folding it into `core` keeps the report
/// honest about where the lines are.
const _rootLabel = 'main';

/// The lines found and hit per layer, read out of [lcov].
///
/// Generated files are left out. A freezed `copyWith` or a Riverpod provider
/// shell is never called by name from a test — the tests hit the hand-written
/// factories — so counting them would move every layer's number by however
/// much code a generator happened to emit into it, which is a measurement of
/// the generator rather than of the tests.
Map<String, ({int found, int hit})> _byLayer(File lcov, Directory root) {
  final totals = <String, ({int found, int hit})>{};

  String? current;
  for (final line in lcov.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = _relative(root, line.substring(3).trim());
      current = generatedSuffixes.any(path.endsWith) ? null : _layerOf(path);
      continue;
    }
    if (current == null || !line.startsWith('DA:')) continue;

    final hits = int.tryParse(line.substring(3).split(',').last);
    if (hits == null) continue;
    final entry = totals[current] ?? (found: 0, hit: 0);
    totals[current] = (
      found: entry.found + 1,
      hit: hits > 0 ? entry.hit + 1 : entry.hit,
    );
  }
  return totals;
}

/// Which layer a source file belongs to — `lib/<layer>/...` — or [_rootLabel]
/// for the files directly under `lib/`.
String _layerOf(String path) {
  final parts = path.split('/');
  if (parts.length < 3 || parts.first != 'lib') return _rootLabel;
  return layers.contains(parts[1]) ? parts[1] : _rootLabel;
}

/// Whether [layer] has any hand-written code to gate.
///
/// Generated files do not count: a layer holding nothing but a provider
/// someone generated has not been written yet, and reporting it as untested
/// would be true and useless.
bool _hasCode(Directory root, String layer) {
  if (layer == _rootLabel) {
    return File('${root.path}/lib/main.dart').existsSync();
  }
  final directory = Directory('${root.path}/lib/$layer');
  if (!directory.existsSync()) return false;
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .any(
        (file) =>
            file.path.endsWith('.dart') &&
            !generatedSuffixes.any(file.path.endsWith),
      );
}

double _threshold(List<String> args) {
  for (final arg in args) {
    if (!arg.startsWith('--threshold=')) continue;
    final value = double.tryParse(arg.split('=').last);
    if (value != null) return value;
  }
  return defaultThreshold;
}

/// [path] relative to [root], with forward slashes on every platform.
///
/// `flutter test --coverage` already writes `SF:lib/main.dart`, but an
/// absolute path is what every other coverage tool writes, and a gate that
/// silently counted nothing because the spelling changed would be worse than
/// one that failed.
String _relative(Directory root, String path) {
  final normalized = path.replaceAll(r'\', '/');
  final prefix = '${root.path.replaceAll(r'\', '/')}/';
  return normalized.startsWith(prefix)
      ? normalized.substring(prefix.length)
      : normalized;
}
