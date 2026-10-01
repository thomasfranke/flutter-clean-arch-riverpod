// What end-to-end scenarios exist, and what happened the last time each ran.
library;

import 'dart:convert';
import 'dart:io';

import '../repo.dart';
import 'process.dart';

/// The driver the host half of a run goes through.
///
/// See `test_driver/integration_test.dart`: the frames are photographed on the
/// device and written here, which is why a run is `flutter drive` rather than
/// `flutter test`.
const e2eDriver = 'test_driver/integration_test.dart';

/// Where the frames and logs of every run go, relative to the repository root.
///
/// It has to agree with `test_driver/integration_test.dart`, which writes the
/// frames, and it is gitignored: a recording is evidence of one run on one
/// machine, not something a checkout carries.
const evidenceDirectory = '.e2e-evidence';

/// Where the record of what ran is kept.
///
/// Beside the recordings and **not inside** them, because `arch e2e clean`
/// throws those away by design and this is a record nothing rebuilds.
const resultsFile = '.e2e-results.json';

/// The headings the list is grouped under, in the order somebody walks through
/// the app.
///
/// Declared rather than discovered, so the order is a decision. A group a
/// scenario names and this list does not is listed last rather than hidden, so
/// a typo is visible instead of silently moving a row.
const scenarioGroups = <String>[
  'Quotes',
  'Detail',
  'Favorites',
  'Preferences',
  'The whole journey',
];

/// One scenario the CLI can list and run.
final class Scenario {
  const Scenario({
    required this.name,
    required this.group,
    required this.describe,
    required this.file,
  });

  /// What it is called — the string in the source, the argument on the command
  /// line, and the key a result is stored under.
  final String name;

  /// The heading it is listed under.
  final String group;

  /// What it is for, shown while it runs.
  final String describe;

  /// The file that declares it, relative to [e2eDirectory].
  final String file;

  /// The path `flutter drive` is pointed at.
  String get target => '$e2eDirectory/$file';
}

/// What happened the last time a scenario ran.
final class ScenarioResult {
  const ScenarioResult({
    required this.passed,
    required this.when,
    required this.version,
    required this.steps,
    required this.elapsed,
  });

  /// Reads one entry of [resultsFile], or null when it is not one.
  static ScenarioResult? fromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    final when = DateTime.tryParse(value['when'] as String? ?? '');
    if (when == null) return null;
    return ScenarioResult(
      passed: value['passed'] as bool? ?? false,
      when: when.toUtc(),
      version: value['version'] as String? ?? '?',
      steps: value['steps'] as int? ?? 0,
      elapsed: Duration(milliseconds: value['elapsedMs'] as int? ?? 0),
    );
  }

  /// Whether it finished.
  final bool passed;

  /// When it ran, in UTC.
  final DateTime when;

  /// The version of the app that ran it.
  ///
  /// A green tick against an old version is not the same claim as one against
  /// this one, and a list that showed only the date would make them look
  /// identical.
  final String version;

  /// How many steps it got through.
  final int steps;

  /// How long it took, from the moment the row was chosen.
  final Duration elapsed;

  Map<String, Object?> toJson() => <String, Object?>{
    'passed': passed,
    'when': when.toIso8601String(),
    'version': version,
    'steps': steps,
    'elapsedMs': elapsed.inMilliseconds,
  };
}

/// Every scenario declared under [e2eDirectory], sorted by name.
///
/// Read out of the source rather than kept in a list here, since a registry
/// beside `scenario('…')` would be wrong the first time somebody forgot it.
List<Scenario> discoverScenarios() {
  final directory = Directory('${repoRoot().path}/$e2eDirectory');
  if (!directory.existsSync()) return const <Scenario>[];
  final found = <Scenario>[];
  for (final file in directory.listSync().whereType<File>()) {
    if (!file.path.endsWith('_test.dart')) continue;
    final source = file.readAsStringSync();
    for (final match in _declaration.allMatches(source)) {
      found.add(
        Scenario(
          name: match.group(1)!,
          // The fallback is `scenario`'s own default parameter, in
          // `integration_test/support/scenario.dart`. The two have to agree.
          group: _valueOf(_group, source, match.start) ?? scenarioGroups.first,
          describe: _valueOf(_describe, source, match.start) ?? '',
          file: file.path.split('/').last,
        ),
      );
    }
  }
  return found..sort((a, b) => a.name.compareTo(b.name));
}

/// `scenario('The name'`, which is how one is declared.
final _declaration = RegExp(r"""\bscenario\(\s*'([^']+)'""", multiLine: true);

/// The named argument [pattern] in the call that starts at [from].
///
/// Bounded to the next declaration, so a scenario cannot read the group of the
/// one after it.
String? _valueOf(RegExp pattern, String source, int from) {
  final next = _declaration.allMatches(source, from + 1);
  final end = next.isEmpty ? source.length : next.first.start;
  final match = pattern.firstMatch(source.substring(from, end));
  return match?.group(1);
}

final _group = RegExp(r"""group:\s*'([^']+)'""");

/// The first line of `describe:`, which is all a row has space for.
final _describe = RegExp(r"""describe:\s*\n?\s*'([^']*)'""");

/// The results of the last run of each scenario, by name.
Map<String, ScenarioResult> readResults() {
  final file = File('${repoRoot().path}/$resultsFile');
  if (!file.existsSync()) return const {};
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) return const {};
    return <String, ScenarioResult>{
      for (final entry in decoded.entries)
        if (ScenarioResult.fromJson(entry.value) case final result?)
          entry.key: result,
    };
  } on FormatException {
    // A results file nobody can read is a results file with nothing in it.
    return const {};
  }
}

/// Records what [name] did, keeping every other scenario's result.
void writeResult(String name, ScenarioResult result) {
  final all = <String, Object?>{
    for (final entry in readResults().entries) entry.key: entry.value.toJson(),
    name: result.toJson(),
  };
  File(
    '${repoRoot().path}/$resultsFile',
  ).writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(all)}\n');
}

/// The version of the app under test, from the pubspec.
///
/// Recorded with every result, because "it passed" means nothing without
/// "against what".
String appVersion() {
  final file = File('${repoRoot().path}/pubspec.yaml');
  if (!file.existsSync()) return '?';
  final match = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(file.readAsStringSync());
  return match?.group(1) ?? '?';
}

/// [text] as a path segment, the way
/// `integration_test/support/evidence.dart` spells it: the device names the
/// frames and this reads them back.
String slugOf(String text) => text
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-|-$'), '');

/// `01:23`, the way a stopwatch reads.
///
/// It measures the whole wait from the moment the row was chosen — the build,
/// the install, the app opening and the flow — because compiling is part of
/// what a run costs whoever asked for it.
String describeElapsed(Duration elapsed) =>
    '${elapsed.inMinutes.toString().padLeft(2, '0')}:'
    '${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';

/// `2026-09-25 · today`.
///
/// The relative half answers "has anyone checked this recently"; the absolute
/// half is what compares against a release.
String describeWhen(DateTime when) {
  final local = when.toLocal();
  final date = '${local.year}-${_two(local.month)}-${_two(local.day)}';
  final days = DateTime.now().difference(local).inDays;
  final relative = switch (days) {
    <= 0 => 'today',
    1 => 'yesterday',
    < 7 => '$days days ago',
    < 14 => 'last week',
    < 60 => '${days ~/ 7} weeks ago',
    _ => '${days ~/ 30} months ago',
  };
  return '$date · $relative';
}

String _two(int value) => value.toString().padLeft(2, '0');
