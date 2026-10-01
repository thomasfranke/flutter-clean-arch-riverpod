/// The host half of an end-to-end run.
///
/// `flutter drive --driver=test_driver/integration_test.dart --target=<a
/// scenario>`. It used to be what every frame travelled through: the device
/// photographed itself and had nowhere to keep the result. It no longer is —
/// `convertFlutterSurfaceToImage()` swaps the Android render surface for an
/// image until teardown, so a scenario that took a picture and carried on
/// hung on its next pump. The CLI photographs the device from the outside
/// instead, with `adb`; see `_Camera` in `tool/src/commands/e2e_run.dart`.
///
/// The hook below stays because this is still where a device-side frame would
/// land, and the driver is still what carries the run's verdict back.
library;

import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Where the frames of every run go, relative to the repository root.
///
/// It has to agree with `tool/src/commands/e2e_run.dart`, which films them and
/// reads them back, and it is gitignored: a recording is evidence of one run
/// on one machine, not something a checkout carries.
const String evidenceDirectory = '.e2e-evidence';

Future<void> main() => integrationDriver(
  onScreenshot:
      (
        final String name,
        final List<int> bytes, [
        final Map<String, Object?>? args,
      ]) async {
        // The name is already a path — `<scenario>/<stamp>-shot-<n>-<step>` —
        // built by `integration_test/support/evidence.dart`, so the folder per
        // scenario is decided where the scenario is, not here.
        final File file = File('$evidenceDirectory/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes);
        return true;
      },
);
