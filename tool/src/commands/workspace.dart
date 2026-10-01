// `arch setup`, `arch clean` and `arch fvm` — the checkout itself, rather
// than the code in it.
library;

import 'dart:io';

import 'process.dart';
import 'toolchain.dart';

/// Resolves the package.
///
/// The first thing to run after a clone, and after pulling a pubspec change.
Future<int> runSetup() async {
  announce('Resolve dependencies');
  return flutter(['pub', 'get']);
}

/// Clears build artifacts, then resolves again.
///
/// What it leaves behind is `coverage/`, and that is wanted rather than an
/// oversight: the coverage gate reads an `lcov.info` the last test run wrote
/// instead of running the suite a second time, so clearing it would cost the
/// next `verify` a full extra run for nothing.
///
/// The resolve at the end is not optional: `flutter clean` removes
/// `.dart_tool`, so stopping halfway leaves a checkout that cannot build at
/// all.
Future<int> runClean() async {
  announce('Clean');
  final cleaned = await flutter(['clean']);
  if (cleaned != 0) return cleaned;

  return runSetup();
}

/// Pins the Flutter version this repository is built against.
///
/// `.fvmrc` is the single source of truth — the GitHub workflow and
/// `arch doctor` read the same file — so the version is taken from there
/// rather than passed in. The Makefile this replaced hardcoded `3.44.5` in a
/// recipe beside a `.fvmrc` that said the same thing, which is two sources of
/// truth waiting to disagree.
Future<int> runFvm() async {
  final version = pinnedFlutterVersion();
  if (version == null) {
    stderr.writeln('arch: could not read the Flutter version from $fvmrcPath');
    return 66; // EX_NOINPUT
  }

  announce('FVM — $version');

  final activated = await dart(['pub', 'global', 'activate', 'fvm']);
  if (activated != 0) return activated;

  return exec('fvm', ['use', version]);
}
