// `arch coverage` — the HTML report, and the threshold gate.
library;

import 'dart:io';

import '../repo.dart';
import '../theme/theme.dart';
import 'process.dart';
import 'tests.dart';

/// Where the measurement lands. `flutter test --coverage` writes here and
/// nothing configures it otherwise, so it is named once and read from both
/// the report and the gate.
const lcovPath = 'coverage/lcov.info';

/// Fails if any layer is under the line-coverage threshold.
///
/// A layer with no code yet, or with code that nothing measured, is skipped
/// rather than counted as 0% — the gate is about tests falling behind code,
/// not about a folder that does not exist yet.
///
/// No `announce` here, unlike every other command: the gate prints its own
/// heading with the threshold in it, and two lines saying "Coverage gate" is
/// one line of chrome stacked on one line of information.
Future<int> runCoverageGate({int? threshold}) => dart([
  'tool/src/commands/coverage_gate.dart',
  if (threshold != null) '--threshold=$threshold',
]);

/// Measures the suite, builds the HTML report, opens it.
///
/// [targets] narrows which tests run, not what is reported on: coverage is a
/// property of `lib/`, and which folder exercised a line does not change
/// whether it was exercised. Narrowing is how you ask "what does this layer's
/// own suite actually reach", which is a real question and a different one
/// from the total.
///
/// The measuring is [runTests]'s, not this command's. It already runs the
/// suite with coverage on and writes the lcov — that is where the `◔` in its
/// summary comes from — so measuring again here would be a second
/// implementation of one thing, and the one without a progress bar.
Future<int> runCoverageReport({List<String> targets = const []}) async {
  final measured = await runTests(targets: targets);
  if (measured != 0) return measured;

  final lcov = File('${repoRoot().path}/$lcovPath');
  if (!lcov.existsSync()) {
    stderr.writeln('arch: nothing was measured — no $lcovPath was written');
    return 66; // EX_NOINPUT
  }

  // Emptied first, because one directory holds the report for whatever was
  // last measured. Without this, a run over one layer leaves the other five's
  // pages sitting beside it, and a run that failed halfway leaves the half it
  // wrote — both of which read as part of the current report. The measurement
  // is elsewhere; this only ever holds a rendering of it.
  final html = Directory('${repoRoot().path}/coverage/html');
  if (html.existsSync()) html.deleteSync(recursive: true);

  announce('Coverage report');
  final generated = await exec('genhtml', [
    lcov.path,
    '--output-directory',
    html.path,
  ]);
  if (generated != 0) {
    stderr.writeln(
      'arch: genhtml failed or is not installed — it ships with lcov. '
      'The raw data is still in $lcovPath',
    );
    return generated;
  }

  return _open('${html.path}/index.html');
}

/// Measures only what was touched recently, and reports on those files alone.
///
/// The point of it is the suite it does not run. [runCoverageReport] measures
/// everything to answer for one file, which is minutes; the question after an
/// edit is about the file that was edited, and the tests it maps to are
/// seconds. [count] defaults to one, because "the file I just changed" is
/// what the command is for — pass more to widen it.
///
/// The report is the run's own, printed as it finishes: coverage per file,
/// least covered first. Nothing is rendered and no browser opens. A page
/// would say the same thing one context switch away, and the answer here is
/// three lines long.
Future<int> runLastCoverage({int? count}) => runLastTests(count: count ?? 1);

/// The same, over everything this branch changed rather than what was edited
/// last. Slower, and the one to run before opening a PR.
Future<int> runDiffCoverage({String? base}) =>
    runChangedTests(base: base ?? 'main');

/// Opens [path] in whatever the platform uses for that.
///
/// The Makefile hardcoded `open`, which is macOS only.
Future<int> _open(String path) async {
  final (executable, arguments) = switch (Platform.operatingSystem) {
    'macos' => ('open', [path]),
    'windows' => ('cmd', ['/c', 'start', '', path]),
    _ => ('xdg-open', [path]),
  };

  final code = await exec(executable, arguments);
  if (code != 0) {
    stdout.writeln('${palette.prompt}Report at $path${Ansi.reset}');
  }
  return 0;
}
