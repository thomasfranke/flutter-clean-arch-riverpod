/// A scenario: a named flow, declared as steps, reported as it runs.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robot.dart';

/// The marker every line of the protocol starts with.
///
/// It is how the CLI tells a step report from anything else the run printed,
/// and it has to agree with `tool/src/commands/e2e_run.dart`. Not a word
/// anyone would type, so a label that happens to say "step" cannot drive the
/// progress bar.
const String stepMarker = '⦙arch-e2e⦙';

/// How long the screen is held still for the host to photograph it.
///
/// The picture is taken on the machine running the CLI, not here: it follows
/// this run's output for a `shot` report and answers it with
/// `adb exec-out screencap`. The app cannot photograph itself and carry on —
/// `takeScreenshot` needs `convertFlutterSurfaceToImage` on Android, which
/// swaps the render surface for an image until teardown, so every pump after
/// it waits for a frame nobody draws and the scenario hangs mid-flow. It also
/// fights the `screenrecord` filming the run.
///
/// Two seconds, which is what the same arrangement settled on in propesqmob:
/// the capture is a round trip to the device, and a marker the screen has
/// already moved on from names one thing and shows another.
const Duration shotPause = Duration(seconds: 2);

/// How long the screen is left to finish arriving before it is photographed.
///
/// A wait returns on the first frame its widget is in the tree, which for a
/// menu, a dialog or a snackbar is the first frame of an entrance animation —
/// photographed there, it comes out as a sliver. `pumpAndSettle` would not do:
/// a screen with a spinner on it never settles.
const Duration shotSettle = Duration(milliseconds: 500);

/// How long one step may take before the run gives up on it.
///
/// The backstop for the waits that are not bounded by a `pumpAndSettle`. It is
/// generous because the first step of every scenario asks Binance for every
/// ticker it has — about 1.9MB of JSON, deserialized on a phone.
const Duration stepLimit = Duration(seconds: 180);

/// The scenario the CLI asked for, or empty for every scenario in the file.
///
/// `flutter drive` has no `--plain-name`, so selection happens here: a
/// scenario the CLI did not name is never declared, and a file that declares
/// three is one test long when one of them was chosen.
const String _only = String.fromEnvironment('E2E_ONLY');

/// One named thing a scenario does.
///
/// The name is what the progress screen shows and what names a failure, so it
/// is written for a dashboard: *"favorite the first quote"*, not
/// *"tapStarIcon"*.
final class Step {
  /// A step called [name] that performs [body].
  const Step(this.name, this.body);

  /// What the progress screen shows while this runs.
  final String name;

  /// What it does, given the robot.
  final Future<void> Function(CryptoRobot robot) body;
}

/// Declares an end-to-end scenario and runs its [steps] in order.
///
/// The flow is data: a scenario lists what happens, and *how* lives in
/// [CryptoRobot], where the next scenario reuses it. Every step is known
/// before the first one runs, which is what a `4/11` progress bar needs.
///
/// [describe] says what the scenario is *for*, and is what the CLI prints
/// under the name while it runs. [group] is the heading it is listed under —
/// one of `scenarioGroups` in `tool/src/commands/e2e_catalogue.dart`.
void scenario(
  final String name, {
  required final String describe,
  required final List<Step> steps,
  final String group = 'Quotes',
}) {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // The live binding skips the frames between pumps; a watched run asks for
  // all of them, so the screen moves rather than jumps.
  if (CryptoRobot.hold > Duration.zero) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  if (_only.isNotEmpty && _only != name) {
    return;
  }

  testWidgets(name, (final WidgetTester tester) async {
    _report(<String, Object?>{
      'event': 'begin',
      'name': name,
      'describe': describe,
      'group': group,
      'steps': steps.length,
    });

    final CryptoRobot robot = CryptoRobot(tester);
    final Stopwatch watch = Stopwatch()..start();

    for (int index = 0; index < steps.length; index++) {
      final Step step = steps[index];
      _report(<String, Object?>{
        'event': 'step',
        'index': index + 1,
        'of': steps.length,
        'name': step.name,
      });
      try {
        await step.body(robot).timeout(stepLimit);
        // Photographed between steps, never inside one: a step mid-flight is
        // a screen halfway through changing, and that is not what the step
        // did.
        await _shoot(tester, index + 1, step.name);
      } on Object catch (error) {
        // The failure's own frame — except after a timeout, which cannot
        // cancel the body. That body is still inside the binding, and holding
        // still for a picture here would give it room to run into teardown and
        // report a second error over the first.
        if (error is! TimeoutException) {
          await _shoot(tester, index + 1, step.name);
        }
        _report(<String, Object?>{
          'event': 'failed',
          'index': index + 1,
          'name': step.name,
          'error': error.toString(),
          'elapsedMs': watch.elapsedMilliseconds,
        });
        fail('step ${index + 1}/${steps.length} — ${step.name}\n$error');
      }
    }

    _report(<String, Object?>{
      'event': 'finished',
      'steps': steps.length,
      'elapsedMs': watch.elapsedMilliseconds,
    });
  });
}

/// Asks the host for a picture of [step], and holds the screen still for it.
///
/// The hold is the whole mechanism: the host reads this run's output, so it
/// learns of the frame the moment the line is printed, and needs the screen to
/// still say what it said while it goes and takes it.
Future<void> _shoot(
  final WidgetTester tester,
  final int index,
  final String step,
) async {
  await tester.pump(shotSettle);
  _report(<String, Object?>{'event': 'shot', 'index': index, 'name': step});
  await tester.pump(shotPause);
}

/// Writes one line of the protocol.
///
/// `print`, because it is the one thing that survives the trip off a device —
/// `flutter drive` forwards the device log to its own stdout — and still reads
/// as words when nobody is parsing it.
void _report(Map<String, Object?> event) {
  // This is the protocol the CLI reads; see [stepMarker]. A logger would
  // decorate it, and the decoration is what the parser would then have to
  // know about.
  // ignore: avoid_print
  print('$stepMarker${jsonEncode(event)}');
}
