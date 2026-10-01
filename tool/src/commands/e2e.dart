// `arch e2e` — the real app on a device, one recorded scenario at a time.
library;

import 'dart:io';

import '../repo.dart';
import '../theme/theme.dart';
import 'e2e_catalogue.dart';
import 'e2e_run.dart';
import 'process.dart';

/// Runs a scenario slowly enough to watch it happen: `arch e2e <name> --watch`.
///
/// Declared here because both faces take it — the menu and the command line —
/// and a flag spelled twice is one eventually forgotten.
const watchFlag = '--watch';

/// Names the device to run on: `arch e2e <name> --device=emulator-5554`.
///
/// A flag rather than a bare word, because a scenario is named in prose: with
/// both positional, `arch e2e Loads the quotes` and a device id would be the
/// same shape of argument.
const deviceFlag = '--device=';

/// Lists the scenarios, with what happened the last time each one ran.
Future<int> runE2eList() async {
  final scenarios = discoverScenarios();
  announce('End-to-end — scenarios');
  stdout.writeln();

  if (scenarios.isEmpty) {
    stdout.writeln('  None declared under $e2eDirectory yet.');
    return 0;
  }

  final results = readResults();
  final groups = <String, List<Scenario>>{
    // Seeded in the declared order, so the list reads as a walk through the
    // app. Empty groups are dropped; a group nothing declares lands at the end.
    for (final heading in scenarioGroups) heading: <Scenario>[],
  };
  for (final scenario in scenarios) {
    groups.putIfAbsent(scenario.group, () => <Scenario>[]).add(scenario);
  }
  groups.removeWhere((_, scenarios) => scenarios.isEmpty);

  final width = scenarios
      .map((s) => s.name.length)
      .reduce((a, b) => a > b ? a : b);

  for (final entry in groups.entries) {
    stdout
      ..writeln('  ${palette.section}${entry.key}${Ansi.reset}')
      ..writeln();
    for (final scenario in entry.value) {
      final result = results[scenario.name];
      stdout.writeln(
        '    ${scenario.name.padRight(width)}  ${resultColor(result)}'
        '${resultDetail(result)}${Ansi.reset}',
      );
    }
    stdout.writeln();
  }

  stdout.writeln(
    '  ${palette.detail}${scenarios.length} scenarios · recordings under '
    '$evidenceDirectory/${Ansi.reset}',
  );
  return 0;
}

/// One row's right-hand column: when it last ran, against which version of the
/// app, and how long it took.
///
/// Plain text, with [resultColor] answering the colour separately, because a
/// menu row right-aligns its metadata by counting characters and an escape
/// sequence counted as width pushes the row off the screen.
///
/// A scenario that never ran says so rather than being hidden.
String resultDetail(ScenarioResult? result) => switch (result) {
  null => 'never run',
  _ =>
    '${result.passed ? Status.ok : Status.fail} '
        '${describeWhen(result.when)} · v${result.version} · '
        '${describeElapsed(result.elapsed)}',
};

/// What colour [resultDetail] reads in.
///
/// Grey for a scenario that never ran: "it passed" and "it ran" are different
/// claims, and a list that made them look alike would be worse than no list.
String resultColor(ScenarioResult? result) => switch (result) {
  null => palette.rowDisabled,
  _ when result.passed => palette.ok,
  _ => palette.fail,
};

/// Removes the recordings, and keeps the record of what ran.
///
/// The frames and the videos are megabytes per run and accumulate; the results
/// file is a few lines and is the answer to "has anyone checked this recently",
/// which nothing else can rebuild.
Future<int> runE2eClean() async {
  final directory = Directory('${repoRoot().path}/$evidenceDirectory');
  announce('End-to-end — remove recordings');
  if (!directory.existsSync()) {
    stdout.writeln('  Nothing to remove.');
    return 0;
  }
  directory.deleteSync(recursive: true);
  stdout.writeln('  Removed $evidenceDirectory/');
  return 0;
}

/// Runs the scenario called [name].
///
/// The name is validated here rather than by the argument parser, because it is
/// prose: what the CLI can say about a name it does not know is the list of the
/// ones it does.
Future<int> runNamedScenario(
  String name, {
  String? device,
  bool watch = false,
}) async {
  final scenarios = discoverScenarios();
  final match = scenarios.where((s) => s.name == name);
  if (match.isEmpty) {
    stderr
      ..writeln('arch: no scenario called "$name". There are:')
      ..writeln();
    for (final scenario in scenarios) {
      stderr.writeln('  ${scenario.name}');
    }
    return 64; // EX_USAGE
  }
  return runScenario(match.first, device: device, watch: watch);
}

/// Runs every scenario, one at a time.
///
/// Sequential, and not because of anything this CLI does: one device, one app.
/// The next run reinstalls the same package, which cannot happen while the last
/// one is still on screen.
Future<int> runAllScenarios({String? device, bool watch = false}) async {
  final scenarios = discoverScenarios();
  if (scenarios.isEmpty) {
    stderr.writeln('arch: no scenarios found under $e2eDirectory');
    return 66; // EX_NOINPUT
  }

  final progress = SuiteProgress(scenarios.length);
  final failures = <String>[];
  var worst = 0;
  for (final scenario in scenarios) {
    progress.index++;
    // The next scenario takes the whole screen; a finished one says nothing the
    // summary below will not say better.
    clearScreen();
    final code = await runScenario(
      scenario,
      device: device,
      watch: watch,
      suite: progress,
    );
    if (code == 0) {
      progress.passed++;
    } else {
      progress.failed++;
      failures.add(scenario.name);
      worst = code;
    }
    // Room for the device to finish stopping the app before the next install.
    await Future<void>.delayed(const Duration(seconds: 2));
  }
  _printSummary(progress, failures);
  return worst;
}

/// What the whole run came to.
///
/// Printed after the last scenario's screen, because those screens are cleared
/// over each other and "one failed" is otherwise twelve screens back.
void _printSummary(SuiteProgress progress, List<String> failures) {
  clearScreen();
  stdout
    ..writeln(
      '${palette.title}${Layout.appTitle}${Ansi.reset} '
      '${palette.titleSuffix}${Layout.titleSeparator} '
      '${Layout.appSubtitle}${Ansi.reset}',
    )
    ..writeln()
    ..writeln('  ${palette.section}End-to-end${Ansi.reset}')
    ..writeln()
    ..writeln(
      '  ${progress.total} scenarios  ${palette.detail}·${Ansi.reset}  '
      '${palette.ok}${Status.ok} ${progress.passed}${Ansi.reset}  '
      '${progress.failed == 0 ? palette.detail : palette.fail}'
      '${Status.fail} ${progress.failed}${Ansi.reset}  '
      '${palette.detail}·  ${describeElapsed(progress.elapsed)}${Ansi.reset}',
    )
    ..writeln();
  if (failures.isEmpty) return;
  stdout.writeln('  ${palette.fail}Failed${Ansi.reset}');
  for (final name in failures) {
    stdout.writeln('    ${palette.detail}$name${Ansi.reset}');
  }
  stdout.writeln();
}
