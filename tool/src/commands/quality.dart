// `arch format`, `arch analyze`, and `arch verify` — the PR gate.
library;

import 'dart:io';

import '../repo.dart';
import '../theme/theme.dart';
import 'codegen.dart';
import 'coverage.dart';
import 'process.dart';
import 'tests.dart';

/// Formats every Dart file, failing if anything was not already formatted.
///
/// `--set-exit-if-changed` rather than a plain format: in a gate, "I fixed it
/// for you" and "it was wrong" are the same event, and only the second one
/// can fail a build.
Future<int> runFormat() async {
  announce('Format');
  return dart(['format', '--set-exit-if-changed', '.']);
}

/// Static analysis over everything, `tool/` included.
///
/// One pass, not two: `lib/`, `test/` and `tool/` are all inside the same
/// package here, so the analyzer already sees them together. What keeps the
/// CLI from being analysed under the app's rules is `tool/analysis_options.
/// yaml`, which the analyzer prefers for the files beneath it — the two sets
/// of rules describe different code and neither would survive being applied
/// to the other.
Future<int> runAnalyze() async {
  announce('Analyze');
  // `--fatal-infos`, because every lint these two configs leave on was left
  // on to be obeyed. The ones that were not worth obeying are switched off,
  // and say so. Without it `flutter analyze` prints the finding and exits
  // zero, which is a gate that reports.
  return flutter(['analyze', '--fatal-infos']);
}

/// Everything the PR gate checks, in the order that fails cheapest first.
///
/// Formatting and analysis take seconds and catch the most common mistakes;
/// the codegen gate and the suite take minutes. Stopping at the first failure
/// is the point — a run that reports five failures caused by one of them
/// wastes the time it spent finding the other four.
///
/// This is also what CI runs, step for step. A workflow that inlined its own
/// version of these would be a second implementation of the gate, and the one
/// nobody can run locally.
Future<int> runVerify() async {
  final steps = <String, Future<int> Function()>{
    'format': runFormat,
    'analyze': runAnalyze,
    'codegen gate': runCodegenGate,
    'tests': runTests,
    'coverage gate': runCoverageGate,
  };

  for (final step in steps.entries) {
    final code = await step.value();
    if (code != 0) {
      stdout
        ..writeln()
        ..writeln(
          '${palette.detailIcon}${Status.fail}${Ansi.reset} '
          '${step.key} failed',
        );
      return code;
    }
  }

  stdout
    ..writeln()
    ..writeln(
      '${palette.rowEmphasized}${Status.ok} Everything CI runs is green'
      '${Ansi.reset}',
    );
  return 0;
}

/// Regenerates everything from scratch and fails if the result differs from
/// what is committed.
///
/// Generated files are committed rather than gitignored, so drift here means
/// what is checked in is not what the annotations actually produce — someone
/// hand-edited a generated file, changed a source and did not regenerate, or
/// added an ARB message and never ran `gen-l10n`.
///
/// Both generators are checked, because both write into the tree: the four
/// suffixes `build_runner` owns, and the localizations. They fail the same
/// way and for the same reason, so they are one gate.
Future<int> runCodegenGate() async {
  announce('Codegen gate');

  final code = await runCodegen(hard: true);
  if (code != 0) return code;

  final drift = await Process.run('git', [
    'status',
    '--porcelain',
    '--',
    for (final suffix in generatedSuffixes) '*$suffix',
    ..._l10nPaths,
  ], workingDirectory: repoRoot().path);

  final changes = (drift.stdout as String).trim();
  if (changes.isEmpty) {
    stdout.writeln('  Generated files match the committed source.');
    return 0;
  }

  stdout
    ..writeln(
      '  Generated files are out of date — commit the regenerated result:',
    )
    ..writeln(changes);
  return 1;
}

/// What `gen-l10n` reads and writes, as `git status` matches paths.
///
/// The ARB files are in the list as well as the generated Dart: an edit to a
/// message that nobody regenerated leaves both sides changed, and naming only
/// the output would report the symptom while hiding half of it.
const _l10nPaths = ['lib/core/l10n/*.arb', 'lib/core/l10n/generated/*.dart'];
