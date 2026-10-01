// The end-to-end catalogue, and the seams either side of it.
//
// The scenarios under `integration_test/` are read by `arch e2e` out of their
// own source: what a scenario is called, which group it is listed under, what
// it says it is for. Nothing else checks that — a scenario the parser cannot
// see is a flow nobody ever runs, and it fails by being absent from a list,
// which is the one failure nobody notices.
//
// The rest of this file is about the three places the CLI and the app have to
// agree on a literal. `tool/` imports nothing but `dart:*`, so they cannot
// share a constant: the protocol marker, the folder the frames go in, and the
// names of the defines are each spelled twice, and this is what keeps the two
// spellings the same.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/src/commands/e2e_catalogue.dart';
import '../../tool/src/commands/process.dart';

/// The defines the CLI hands a run, and the app reads back.
///
/// `E2E_STAMP` used to be among them, when the device named the frames it took
/// of itself. The host takes them now — see `_Camera` in
/// `tool/src/commands/e2e_run.dart` — so the stamp never leaves the machine
/// that made it, and a define nobody reads is one more thing to keep in step.
const List<String> defines = <String>['E2E_ONLY', 'E2E_HOLD_MS'];

void main() {
  group('the scenarios', () {
    test('there are some, and every file declares at least one', () {
      final List<Scenario> scenarios = discoverScenarios();
      expect(scenarios, isNotEmpty);

      final Set<String> declaring = scenarios
          .map((final Scenario s) => s.file)
          .toSet();
      for (final File file in Directory(
        e2eDirectory,
      ).listSync().whereType<File>()) {
        final String name = file.path.split('/').last;
        if (!name.endsWith('_test.dart')) {
          continue;
        }
        expect(
          declaring,
          contains(name),
          reason:
              '$name declares no scenario the CLI can see. A file that calls '
              'testWidgets directly runs, but never appears in `arch e2e` — '
              'declare it with scenario() instead.',
        );
      }
    });

    test('every name is unique', () {
      final List<String> names = discoverScenarios()
          .map((final Scenario s) => s.name)
          .toList();

      expect(
        names.toSet().length,
        names.length,
        reason:
            'The name is how a run is selected (--dart-define=E2E_ONLY) and '
            'the key its result is stored under, so two scenarios sharing one '
            "would overwrite each other's history and run together.",
      );
    });

    test('every scenario says what it is for', () {
      for (final Scenario scenario in discoverScenarios()) {
        expect(
          scenario.describe,
          isNotEmpty,
          reason:
              '"${scenario.name}" has no describe:, so its row in the menu is '
              'a name with nothing under it.',
        );
      }
    });

    test('every group is one the list knows', () {
      for (final Scenario scenario in discoverScenarios()) {
        expect(
          scenarioGroups,
          contains(scenario.group),
          reason:
              '"${scenario.name}" is in "${scenario.group}", which is not in '
              'scenarioGroups — it would be listed last, under a heading '
              'nobody decided the place of.',
        );
      }
    });

    test('every scenario points at a file that exists', () {
      for (final Scenario scenario in discoverScenarios()) {
        expect(File(scenario.target).existsSync(), isTrue);
      }
    });
  });

  group('the seams', () {
    test('the app and the CLI agree on the protocol marker', () {
      expect(
        _literal('stepMarker', inFile: '$e2eDirectory/support/scenario.dart'),
        _literal('stepMarker', inFile: 'tool/src/commands/e2e_run.dart'),
        reason:
            'The CLI finds a step report by this marker. Two spellings means '
            'a progress bar that never moves and a run that looks hung.',
      );
    });

    test('the driver and the CLI agree on where the frames go', () {
      expect(
        _literal(
          'evidenceDirectory',
          inFile: 'test_driver/integration_test.dart',
        ),
        _literal(
          'evidenceDirectory',
          inFile: 'tool/src/commands/e2e_catalogue.dart',
        ),
        reason:
            'The driver writes the frames and the CLI films them. Two folders '
            'means a run that records everything and reports no frames.',
      );
    });

    test('every define the CLI passes is one the app reads', () {
      final String cli = File(
        'tool/src/commands/e2e_run.dart',
      ).readAsStringSync();
      final String app = <String>[
        for (final File file in Directory(
          '$e2eDirectory/support',
        ).listSync().whereType<File>())
          file.readAsStringSync(),
      ].join();

      for (final String define in defines) {
        expect(
          cli,
          contains(define),
          reason: '$define is read by the app and handed over by nobody',
        );
        expect(
          app,
          contains(define),
          reason: '$define is handed over by the CLI and read by nobody',
        );
      }
    });

    test('the driver the CLI drives is the file that is there', () {
      expect(File(e2eDriver).existsSync(), isTrue);
    });

    test('every event the app reports is one the CLI handles', () {
      final Set<String> reported = _eventsReported();
      final Set<String> handled = _eventsHandled();

      // Both sides are scraped out of source, and a pattern that matches
      // nothing would agree with a pattern that matches nothing. The seam has
      // to be found before it can be compared.
      expect(reported, isNotEmpty, reason: 'No event is reported anywhere');
      expect(handled, isNotEmpty, reason: 'The CLI handles no event at all');

      expect(
        reported.difference(handled),
        isEmpty,
        reason:
            'The app reports this and the CLI does nothing with it. For '
            '"shot" that is a run that records nothing while every test still '
            'passes — the failure that looks like success.',
      );
      expect(
        handled.difference(reported),
        isEmpty,
        reason:
            'The CLI waits for an event nobody reports, which is a branch '
            'that can never be taken.',
      );
    });

    test('the host outwaits a step, rather than cutting it short', () {
      final Duration step = _duration('stepLimit', inFile: _scenarioFile);
      final Duration host = _duration('_scenarioLimit', inFile: _cliFile);

      expect(
        host,
        greaterThan(step),
        reason:
            'The CLI kills a run that overruns and the scenario gives up on a '
            'step that does. With the host the shorter of the two, a step '
            'that is merely slow is killed from outside, and the report '
            'naming which step it was never arrives — exactly the silence '
            'both limits exist to prevent.',
      );
    });
  });
}

/// The file the scenarios are declared and reported from.
const String _scenarioFile = '$e2eDirectory/support/scenario.dart';

/// The file that reads those reports back.
const String _cliFile = 'tool/src/commands/e2e_run.dart';

/// The event names the app prints.
Set<String> _eventsReported() => RegExp(r"'event':\s*'([a-z]+)'")
    .allMatches(File(_scenarioFile).readAsStringSync())
    .map((final RegExpMatch m) => m.group(1)!)
    .toSet();

/// The event names the CLI acts on — the arms of its switch, and the reports
/// it singles out on the way past.
Set<String> _eventsHandled() {
  final String source = File(_cliFile).readAsStringSync();
  return <String>{
    ...RegExp(
      r"case\s*'([a-z]+)':",
    ).allMatches(source).map((final RegExpMatch m) => m.group(1)!),
    ...RegExp(
      r"report\['event'\]\s*==\s*'([a-z]+)'",
    ).allMatches(source).map((final RegExpMatch m) => m.group(1)!),
  };
}

/// The [Duration] a `const` called [name] is declared with, in [inFile].
///
/// Read as text for the same reason [_literal] is: the two files cannot share
/// a declaration, so the only thing able to compare them is something that
/// reads both.
Duration _duration(final String name, {required final String inFile}) {
  final RegExpMatch? match = RegExp(
    '$name\\s*=\\s*(?:const\\s*)?Duration\\(\\s*(seconds|minutes):\\s*([0-9]+)',
  ).firstMatch(File(inFile).readAsStringSync());
  expect(match, isNotNull, reason: '$inFile declares no $name as a Duration');
  final int value = int.parse(match!.group(2)!);
  return match.group(1) == 'minutes'
      ? Duration(minutes: value)
      : Duration(seconds: value);
}

/// The string a `const` called [name] is declared with, in the file at
/// [inFile].
///
/// Read as text rather than imported, because the point is that the two files
/// cannot share a declaration: `tool/` imports nothing but `dart:*`, and an
/// import here would prove something the CLI itself cannot rely on.
String _literal(String name, {required String inFile}) {
  final RegExpMatch? match = RegExp(
    "(?:const|final)\\s+(?:String\\s+)?$name\\s*=\\s*'([^']*)'",
  ).firstMatch(File(inFile).readAsStringSync());
  expect(match, isNotNull, reason: '$inFile declares no $name');
  return match!.group(1)!;
}
