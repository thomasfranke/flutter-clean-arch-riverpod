// Running one end-to-end scenario, and showing where it is while it runs.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../cli/dashboard.dart';
import '../repo.dart';
import '../theme/theme.dart';
import '../tty.dart';
import 'e2e_catalogue.dart';

/// The marker the scenarios prefix their reports with.
///
/// It has to agree with `integration_test/support/scenario.dart`, and it is not
/// a word anyone would type, so a step whose name contains "step" cannot drive
/// the progress bar.
const stepMarker = '⦙arch-e2e⦙';

/// How long `--watch` holds the screen after each action, in milliseconds.
///
/// Not a setting: a number somebody can tune is a number nobody agrees on.
const _holdWhileWatching = 700;

/// Where a run of several scenarios has got to.
///
/// Carried into each scenario's screen, so the header can say *2 of 12* and how
/// many have passed. It lives here rather than in the screen, which is thrown
/// away between scenarios: the question is how long the whole run has been
/// going, not this one flow.
final class SuiteProgress {
  SuiteProgress(this.total) : _started = DateTime.now();

  /// How many scenarios the run holds.
  final int total;

  final DateTime _started;

  /// Which one is running, counting from one.
  int index = 0;

  /// How many have finished, each way.
  int passed = 0;
  int failed = 0;

  /// How long the whole run has been going.
  Duration get elapsed => DateTime.now().difference(_started);

  /// How far through, as a percentage of scenarios *finished*.
  int get percent =>
      total == 0 ? 0 : (((passed + failed) / total) * 100).round();
}

/// Clears the screen so the next scenario has all of it.
void clearScreen() {
  if (!isPlain) stdout.write('${Ansi.clearScreen}${Ansi.home}');
}

/// How long a scenario may take before the run stops waiting on it.
///
/// The backstop for the process, where `stepLimit` in
/// `integration_test/support/scenario.dart` is the backstop for one step. They
/// are not the same failure: a step that hangs still reports, while a build
/// that never finishes, a device that never answers or an app that died with
/// the driver still talking to it report nothing at all. Without this the suite
/// waits forever on one scenario, having written nothing down — which is the
/// one failure that leaves nobody anything to read.
const _scenarioLimit = Duration(minutes: 15);

/// Runs [scenario] on [device], painting its progress until it is done.
///
/// One `flutter drive` per scenario, even for two that share a file: each one
/// starts the app from nothing and wipes what the last one stored, which is
/// what makes a row's result about that row.
Future<int> runScenario(
  Scenario scenario, {
  String? device,
  bool watch = false,
  SuiteProgress? suite,
}) async {
  final screen = _ScenarioScreen(scenario, suite: suite)..start();
  // One stamp for the whole run, so the frames, the video and the log all carry
  // the same one.
  final stamp = _stampNow();
  final camera = await _Camera.find(scenario, stamp, device: device);

  final process = await Process.start('flutter', [
    'drive',
    '--driver=$e2eDriver',
    '--target=${scenario.target}',
    if (device != null && device.isNotEmpty) ...['-d', device],
    // Defines rather than a file the run reads: these belong to this
    // invocation, and the next one must not inherit them.
    '--dart-define=E2E_ONLY=${scenario.name}',
    if (watch) '--dart-define=E2E_HOLD_MS=$_holdWhileWatching',
  ], workingDirectory: repoRoot().path);

  // Killed rather than answered, so the outcome can say so.
  var overran = false;
  final guard = Timer(_scenarioLimit, () {
    overran = true;
    process.kill(ProcessSignal.sigkill);
  });

  final errors = <String>[];
  final transcript = StringBuffer();
  // The pictures are taken one at a time and in order, off the line that asked
  // for one: the handler stays synchronous, so no report can overtake another.
  var shots = Future<void>.value();
  await Future.wait([
    for (final stream in [process.stdout, process.stderr])
      stream.transform(utf8.decoder).transform(const LineSplitter()).forEach((
        line,
      ) {
        transcript.writeln(line);
        final report = _parse(line);
        if (report != null) {
          if (report['event'] == 'begin') {
            shots = shots.then((_) => camera.roll());
          }
          if (report['event'] == 'shot') {
            shots = shots.then((_) => camera.shoot(report));
          }
          screen.apply(report);
        } else if (_looksLikeAFailure(line)) {
          errors.add(line.trim());
        }
      }),
  ]);

  final code = await process.exitCode;
  guard.cancel();
  await shots;
  // The outcome is the last word of every file the run leaves behind. A
  // negative code means killed, not answered.
  final outcome = overran
      ? 'timed-out'
      : code == 0
      ? 'passed'
      : code < 0
      ? 'cancelled'
      : 'failed';
  if (overran) {
    errors.add('Stopped after $_scenarioLimit: the run never finished.');
  }
  final log = _keep(scenario, transcript.toString(), stamp, outcome);
  final frames = await camera.cut(outcome);
  screen.finish(passed: code == 0, errors: errors, log: log, frames: frames);
  writeResult(
    scenario.name,
    ScenarioResult(
      passed: code == 0,
      when: DateTime.now().toUtc(),
      version: appVersion(),
      steps: screen.stepsDone,
      elapsed: screen.elapsed,
    ),
  );
  return code;
}

/// Photographs and films a run, from here rather than from inside the app.
///
/// The app cannot photograph itself and carry on. `takeScreenshot` needs
/// `convertFlutterSurfaceToImage()` on Android, which swaps the render surface
/// for an image and only swaps it back at teardown: every pump after that waits
/// for a frame nobody draws, so the scenario hangs mid-flow and the suite stops
/// on it. `adb` has no such problem — it reads the window without the app
/// knowing, and `screenrecord` films on the device, so there is no ffmpeg to
/// install to get a video out.
///
/// Both halves are best effort. A machine with no `adb`, or a run on something
/// other than Android, records nothing and asserts everything it asserted
/// before: evidence never decides whether a scenario passed.
final class _Camera {
  _Camera._(this.scenario, this.stamp, this.device);

  /// What is being recorded, which is what names the folder.
  final Scenario scenario;

  /// The run's stamp, which is what keeps two runs of it apart.
  final String stamp;

  /// The adb device id, or empty when there is nothing to record with.
  final String device;

  /// How many stills were asked for and actually arrived.
  int taken = 0;

  /// The local half of the device-side recording, while one is running.
  Process? _filming;

  /// Where the device writes while recording.
  ///
  /// Pulled and deleted when the run ends. On the device because that is where
  /// `screenrecord` writes, and nowhere else is reachable from it.
  static const _onDevice = '/sdcard/arch-e2e.mp4';

  /// The camera for this run, or one that does nothing.
  ///
  /// Resolved once: the alternative is probing for `adb` on every picture, and
  /// a run takes one per step.
  static Future<_Camera> find(
    Scenario scenario,
    String stamp, {
    String? device,
  }) async {
    final attached = await _attached();
    // A named device is only usable when adb has it; `-d macos` and an iPhone
    // are both perfectly good runs that this cannot record.
    final id = device == null || device.isEmpty
        ? (attached.length == 1 ? attached.single : '')
        : (attached.contains(device) ? device : '');
    return _Camera._(scenario, stamp, id);
  }

  /// The device ids `adb` is currently talking to.
  static Future<List<String>> _attached() async {
    try {
      final result = await Process.run('adb', ['devices']);
      return LineSplitter.split('${result.stdout}')
          .skip(1)
          .map((line) => line.split(RegExp(r'\s+')))
          .where((parts) => parts.length >= 2 && parts[1] == 'device')
          .map((parts) => parts.first)
          .toList();
    } on ProcessException {
      // No adb on this machine. The run still runs.
      return const [];
    }
  }

  /// Starts filming, once the app is up rather than when the CLI started.
  ///
  /// A scenario is seconds and the build before it is minutes; filming from the
  /// top would be a video that is mostly Gradle.
  Future<void> roll() async {
    if (device.isEmpty || _filming != null) return;
    await _adb(['shell', 'rm', '-f', _onDevice]);
    try {
      // 720p at 2Mbps rather than the defaults: the point is to see which
      // control was pressed, not to read the fonts, and a tenth of the bitrate
      // is a tenth of the file.
      //
      // `--time-limit` and not the `0` the help offers for "no limit", which
      // has been seen to write a file with no index that no player opens.
      _filming = await Process.start('adb', [
        '-s',
        device,
        'shell',
        'screenrecord',
        '--time-limit',
        '1800',
        '--bit-rate',
        '2M',
        '--size',
        '720x1280',
        _onDevice,
      ]);
    } on ProcessException {
      _filming = null;
    }
  }

  /// Takes the still [report] asked for, named after the step it belongs to.
  ///
  /// `exec-out` and never `shell … >`: the shell path translates line endings
  /// on the way out, and a PNG that went through it does not open. A capture
  /// that comes back empty is dropped rather than left as zero bytes, which
  /// would read as evidence in a listing and show nothing.
  Future<void> shoot(Map<String, Object?> report) async {
    if (device.isEmpty) return;
    final index = report['index'] as int? ?? taken + 1;
    final step = report['name'] as String? ?? 'step';
    // Three digits, because the stills are read back alphabetically and
    // `shot-100` sorts before `shot-99`.
    final number = index.toString().padLeft(3, '0');
    final file = File(
      '${_directory.path}/$stamp-shot-$number-${slugOf(step)}.png',
    );
    try {
      final result = await Process.run('adb', [
        '-s',
        device,
        'exec-out',
        'screencap',
        '-p',
      ], stdoutEncoding: null);
      final bytes = result.stdout as List<int>;
      if (bytes.isEmpty) return;
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      taken++;
    } on ProcessException {
      // One lost frame, and the run keeps photographing.
    }
  }

  /// Stops filming, files the video under [outcome], and answers the still
  /// count.
  ///
  /// `pkill -INT` and never `-KILL`: the mp4 is finalised when `screenrecord`
  /// catches the interrupt, and one killed outright leaves a file no player
  /// opens. The signal goes over the wire because the local half dying does not
  /// stop the device-side process.
  Future<int> cut(String outcome) async {
    final filming = _filming;
    if (device.isEmpty || filming == null) return taken;
    _filming = null;

    await _adb(['shell', 'pkill', '-INT', 'screenrecord']);
    await filming.exitCode;
    // A moment for the encoder to write the trailer, which it does after the
    // signal; pulling before it catches a file still missing its index.
    await _adb(['wait-for-device']);

    await Directory(_directory.path).create(recursive: true);
    await _adb(['pull', _onDevice, '${_directory.path}/$stamp-$outcome.mp4']);
    await _adb(['shell', 'rm', '-f', _onDevice]);
    return taken;
  }

  Directory get _directory => Directory(
    '${repoRoot().path}/$evidenceDirectory/${slugOf(scenario.name)}',
  );

  Future<void> _adb(List<String> arguments) async {
    try {
      await Process.run('adb', ['-s', device, ...arguments]);
    } on ProcessException {
      // Nothing to clean up on a machine that cannot talk to the device.
    }
  }
}

/// Keeps everything a run printed, and answers its path.
///
/// The screen shows the handful of lines worth reading; this is the rest, for
/// the failure that does not happen again when the run is repeated. Beside the
/// frames of the same run, named after the scenario rather than after the file
/// two of them may share, with the stamp keeping runs apart and the outcome
/// readable from a listing.
String _keep(
  Scenario scenario,
  String transcript,
  String stamp,
  String outcome,
) {
  final path =
      '$evidenceDirectory/${slugOf(scenario.name)}/$stamp-$outcome.log';
  File('${repoRoot().path}/$path')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(transcript);
  return path;
}

/// When a run started, to the second, as every file it writes spells it.
///
/// To the second because the stamp is all that keeps two runs apart: the frame
/// counter restarts every run, so two runs in one minute would overwrite each
/// other's frames and be filmed as one. It has to agree with
/// `integration_test/support/evidence.dart`, which stamps itself the same way.
String _stampNow() {
  final now = DateTime.now();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${now.year}-${two(now.month)}-${two(now.day)}'
      'T${two(now.hour)}-${two(now.minute)}-${two(now.second)}';
}

/// One report from a running scenario, or null for anything else.
Map<String, Object?>? _parse(String line) {
  // Found anywhere in the line, not at the start of it: a device log arrives
  // through logcat, which prefixes every line with its own tag.
  final at = line.indexOf(stepMarker);
  if (at < 0) return null;
  try {
    final decoded = jsonDecode(line.substring(at + stepMarker.length));
    return decoded is Map<String, Object?> ? decoded : null;
  } on FormatException {
    return null;
  }
}

/// Whether [line] is worth showing after a failure.
///
/// The assertion, the step it happened in, or the run never starting at all —
/// which is the case worth naming, because a scenario that reports `0/0 steps`
/// and nothing under it reads as a flake and is usually a missing device.
bool _looksLikeAFailure(String line) =>
    line.contains('Expected:') ||
    line.contains('Actual:') ||
    line.startsWith('step ') ||
    line.contains('No supported devices') ||
    line.contains('No connected devices') ||
    line.contains('Unable to') ||
    line.contains('Gradle task') ||
    line.contains('BUILD FAILED') ||
    line.contains('Build failed') ||
    line.contains('Driver tests failed');

/// The block repainted while a scenario runs.
///
/// Not a [Dashboard]: that paints a row per target, and this paints one
/// scenario in detail — the name, what it is for, and which of its steps it is
/// on. A row could not hold any of that.
final class _ScenarioScreen {
  _ScenarioScreen(this.scenario, {this.suite}) : _started = DateTime.now();

  final Scenario scenario;

  /// Where the whole run has got to, when there is a whole run.
  final SuiteProgress? suite;

  final DateTime _started;

  int _total = 0;
  int _done = 0;
  String _step = 'building, installing, starting the app…';
  bool _finished = false;
  bool _passed = false;
  int _drawn = 0;
  Timer? _ticker;

  /// How many steps ran.
  int get stepsDone => _done;

  /// How long it has taken.
  Duration get elapsed => DateTime.now().difference(_started);

  /// Paints the first frame and keeps the clocks moving.
  ///
  /// A repaint every second, because building and installing report nothing for
  /// a minute or two and a clock that stopped there would look like a hang.
  void start() {
    paint();
    if (isPlain) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => paint());
  }

  /// Folds one report into what is on screen.
  void apply(Map<String, Object?> report) {
    switch (report['event']) {
      case 'begin':
        _total = report['steps'] as int? ?? 0;
      case 'step':
        _done = (report['index'] as int? ?? 1) - 1;
        _step = report['name'] as String? ?? '';
      case 'failed':
        _step = report['name'] as String? ?? '';
      case 'finished':
        _done = report['steps'] as int? ?? _done;
        _step = 'done';
    }
    paint();
  }

  /// Paints the last frame, and says what went wrong if anything did.
  void finish({
    required bool passed,
    required List<String> errors,
    required String log,
    required int frames,
  }) {
    _ticker?.cancel();
    _finished = true;
    _passed = passed;
    if (passed) {
      _done = _total;
      _step = 'done';
    }
    paint();
    stdout.writeln();
    if (!passed) {
      for (final line in errors.take(8)) {
        stdout.writeln('  ${palette.detail}$line${Ansi.reset}');
      }
    }
    // Always, and not only after a failure: a passing run is the one whose
    // recording somebody wanted, and this is where it went.
    stdout.writeln(
      '  ${palette.detail}'
      '${frames == 0 ? 'nothing recorded' : '$frames stills + video'}'
      ' · $evidenceDirectory/${slugOf(scenario.name)}/${Ansi.reset}',
    );
    stdout.writeln('  ${palette.detail}Full output: $log${Ansi.reset}');
  }

  /// Repaints the block where it stands.
  void paint() {
    if (isPlain) {
      // Append-only, so a log of a CI run still reads as a sequence.
      if (_finished) {
        stdout.writeln(
          '  ${_passed ? Status.ok : Status.fail} ${scenario.name} '
          '— $_done/$_total steps',
        );
      }
      return;
    }
    stdout.write(Ansi.up(_drawn));
    final lines = _compose();
    for (final line in lines) {
      stdout.writeln('$line${Ansi.clearLine}');
    }
    _drawn = lines.length;
  }

  List<String> _compose() {
    final mark = switch (_finished) {
      false => '${palette.running}${Status.running}',
      true when _passed => '${palette.ok}${Status.ok}',
      true => '${palette.fail}${Status.fail}',
    };
    final state = _finished ? (_passed ? 'finished' : 'failed') : 'running';
    final percent = _total == 0 ? 0 : ((_done / _total) * 100).round();
    return [
      ..._suiteHeader(),
      '',
      '  ${palette.detail}${scenario.group}${Ansi.reset}',
      '',
      '  ${palette.title}${scenario.name}${Ansi.reset}',
      ..._wrapped(scenario.describe),
      '',
      '  $mark $state${Ansi.reset}  ${palette.detail}·  ${scenario.file}'
          '${Ansi.reset}',
      '',
      '  ${progressBar(_done, _total)}  ${palette.detail}$percent%  '
          '$_done/$_total steps · ${formatDuration(elapsed)}${Ansi.reset}',
      '',
      '  ${palette.detail}$_step${Ansi.reset}',
      '',
    ];
  }

  /// The lines above a scenario when it is one of many.
  ///
  /// Counts, because the question then is whether the run is going well and how
  /// much of it is left.
  List<String> _suiteHeader() {
    final progress = suite;
    if (progress == null) return const <String>[];
    final passed = progress.passed == 0
        ? ''
        : '  ${palette.ok}${Status.ok} ${progress.passed}${Ansi.reset}';
    final failed = progress.failed == 0
        ? ''
        : '  ${palette.fail}${Status.fail} ${progress.failed}${Ansi.reset}';
    return [
      // The header every other screen carries, painted here because this one
      // cleared the terminal the CLI had drawn it on.
      '${palette.title}${Layout.appTitle}${Ansi.reset} '
          '${palette.titleSuffix}${Layout.titleSeparator} '
          '${Layout.appSubtitle}${Ansi.reset}',
      '',
      '  ${palette.section}End-to-end${Ansi.reset}  ${palette.detail}'
          '·  ${progress.index}/${progress.total}  ·  '
          '${formatDuration(progress.elapsed)}${Ansi.reset}',
      '',
      '  ${progressBar(progress.passed + progress.failed, progress.total)}  '
          '${palette.detail}${progress.percent}%${Ansi.reset}$passed$failed',
      '',
      '  ${palette.rule}${Layout.ruleGlyph * 40}${Ansi.reset}',
    ];
  }

  /// [text] folded to the width the screen uses, indented under the name.
  List<String> _wrapped(String text, {int width = 64}) {
    if (text.isEmpty) return const <String>[];
    final lines = <String>[];
    var line = StringBuffer();
    for (final word in text.split(' ')) {
      if (line.length + word.length + 1 > width) {
        lines.add(line.toString());
        line = StringBuffer();
      }
      if (line.isNotEmpty) line.write(' ');
      line.write(word);
    }
    if (line.isNotEmpty) lines.add(line.toString());
    return [
      for (final line in lines) '    ${palette.detail}$line${Ansi.reset}',
    ];
  }
}
