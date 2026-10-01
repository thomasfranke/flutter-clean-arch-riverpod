// `arch run` and `arch build` — the app itself.
library;

import 'dart:convert';
import 'dart:io';

import '../theme/theme.dart';
import 'process.dart';

/// What `build` can produce.
///
/// Three artifacts rather than two platforms, because that is what the
/// question actually is: Android ships as an APK for a device and as an app
/// bundle for the store, and those are different commands with different
/// output. iOS is one, and only from a Mac.
const buildTargets = ['apk', 'appbundle', 'ios'];

/// How each target spells itself on a screen.
const buildTargetLabels = <String, String>{
  'apk': 'Android APK',
  'appbundle': 'Android App Bundle',
  'ios': 'iOS',
};

/// A device `flutter run` could target.
typedef Device = ({String id, String name, String platform});

/// The devices attached right now, as Flutter sees them.
///
/// Asked of Flutter rather than assumed, because "which device" is the one
/// question this CLI genuinely cannot answer from the repository: an emulator
/// that is booted this minute and not the next is not a property of the
/// checkout. An empty list is an answer — `arch run` then says so instead of
/// handing the question to `flutter run` and letting it fail further away.
Future<List<Device>> devices() async {
  final result = await capture('flutter', ['devices', '--machine']);
  if (result == null || result.exitCode != 0) return const [];

  final text = result.stdout as String;
  final start = text.indexOf('[');
  final end = text.lastIndexOf(']');
  if (start < 0 || end < start) return const [];

  final Object? decoded;
  try {
    decoded = jsonDecode(text.substring(start, end + 1));
  } on FormatException {
    return const [];
  }
  if (decoded is! List) return const [];

  return [
    for (final entry in decoded.whereType<Map<String, dynamic>>())
      (
        id: '${entry['id']}',
        name: '${entry['name']}',
        platform: '${entry['targetPlatform'] ?? 'unknown'}',
      ),
  ];
}

/// Opens the app on [device], or on whatever Flutter picks when it is null.
///
/// Left to Flutter deliberately when nothing is named: with one device
/// attached that is the right answer, and with several it prompts — which is
/// the same question this CLI would be asking, one process further in.
Future<int> runApp({String? device}) async {
  announce('Run${device == null ? '' : ' — $device'}');
  return flutter([
    'run',
    if (device != null) ...['-d', device],
  ]);
}

/// Builds [target] in release mode.
///
/// A compile check as much as an artifact: nothing here is signed and nothing
/// is uploaded, so what it proves is that the tree still builds — which is
/// the thing a repository this size is most likely to lose quietly.
Future<int> runBuild({required String target}) async {
  if (target == 'ios' && !Platform.isMacOS) {
    stderr.writeln(
      'arch: iOS builds need a Mac — this is ${Platform.operatingSystem}',
    );
    return 64; // EX_USAGE
  }

  announce('Build — ${buildTargetLabels[target] ?? target}');
  return flutter([
    'build',
    target,
    '--release',
    // Unsigned: signing needs a team and a certificate, and neither belongs
    // in a repository. The build still compiles every line of Dart and every
    // plugin's native side, which is what is being checked.
    if (target == 'ios') '--no-codesign',
  ]);
}

/// A one-line note for a device row in the menu.
String describeDevice(Device device) =>
    '${device.name}${palette.detail} — ${device.platform}${Ansi.reset}';
