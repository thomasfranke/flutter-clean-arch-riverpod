// The CLI's own tests — `arch`, driven as a process.
//
// Black box on purpose. What the Makefile, the GitHub workflow and anyone
// reading the README actually depend on is the command line: the names, the
// exit codes, and the fact that a typo is refused instead of being read as
// "all of them". None of that is visible from inside the functions, and all
// of it breaks the same way — quietly.
//
// So every test here spawns the real thing. It costs a second each and buys
// the only contract the CLI has.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every command `--help` is expected to list.
///
/// Spelled out rather than read back from the CLI, which would make the test
/// agree with whatever it found. A command removed by accident fails here.
const List<String> commands = <String>[
  'analyze',
  'build',
  'clean',
  'codegen',
  'codegen-gate',
  'coverage',
  'coverage-gate',
  'doctor',
  'e2e',
  'format',
  'fvm',
  'l10n',
  'run',
  'setup',
  'test',
  'updates',
  'verify',
];

/// The exit code a wrong invocation gets: `EX_USAGE` from sysexits.h.
const int exUsage = 64;

/// The exit code an argument the command does not take gets: `EX_NOINPUT`.
const int exNoInput = 66;

void main() {
  group('--help', () {
    test('lists every command, each with a summary', () async {
      final ProcessResult result = await _arch(<String>['--help']);

      expect(result.exitCode, 0);
      for (final String command in commands) {
        final RegExp row = RegExp('^\\s+$command\\s+\\S.*\$', multiLine: true);
        expect(
          row.hasMatch(result.stdout as String),
          isTrue,
          reason: '`$command` is missing from --help, or has no summary',
        );
      }
    });

    test('-h says the same thing', () async {
      final ProcessResult long = await _arch(<String>['--help']);
      final ProcessResult short = await _arch(<String>['-h']);

      expect(short.stdout, long.stdout);
      expect(short.exitCode, 0);
    });
  });

  group('exit codes', () {
    test('an unknown command is refused with EX_USAGE', () async {
      final ProcessResult result = await _arch(<String>['nonsense']);

      expect(result.exitCode, exUsage);
      expect(result.stderr, contains('unknown command'));
    });

    test('an argument a command does not take is refused', () async {
      // The case this is here for: `_targetsFrom` ignores what it does not
      // recognise, so without the check a typo'd layer name becomes "none
      // named", and none named means all of them — a narrowed run that
      // quietly runs everything.
      final ProcessResult result = await _arch(<String>['test', 'domian']);

      expect(result.exitCode, exNoInput);
      expect(result.stderr, contains('does not take "domian"'));
    });

    test('a layer that does exist is accepted', () async {
      // Accepted, not run: `--help` short-circuits before any work, so this
      // asks whether the word is known without paying for a test run.
      final ProcessResult result = await _arch(<String>[
        'test',
        'domain',
        '--help',
      ]);

      expect(result.exitCode, 0);
    });

    test('no arguments and no terminal says what to type', () async {
      // A menu would hang waiting for a key that is never coming. This is the
      // path CI takes if anyone ever calls `arch` with nothing.
      final ProcessResult result = await _arch(<String>[]);

      expect(result.exitCode, exUsage);
      expect(result.stderr, contains('no terminal attached'));
    });
  });

  group('e2e', () {
    // The one command whose argument is prose: a scenario is named by the
    // sentence it declares itself with, so the usual "is this a word I know"
    // check cannot apply and the command validates the name itself.
    test('with no scenario named, it lists them', () async {
      final ProcessResult result = await _arch(<String>['e2e']);

      expect(result.exitCode, 0);
      expect(_plain(result.stdout as String), contains('never run'));
    });

    test(
      'a name no scenario has is refused, with the ones there are',
      () async {
        final ProcessResult result = await _arch(<String>[
          'e2e',
          'no such flow',
        ]);

        expect(result.exitCode, exUsage);
        expect(result.stderr, contains('no scenario called "no such flow"'));
        // The list, not just the refusal: a name typed from memory is one word
        // out, and the answer to that is the names.
        expect(result.stderr, contains('The complete demo journey'));
      },
    );

    test('the device is a flag, so a name can be several words', () async {
      // `--device=` and `--watch` are taken out of the line before what is
      // left is read as a name. Without that, `arch e2e <name> --watch` would
      // look for a scenario whose name ends in a flag.
      final ProcessResult result = await _arch(<String>[
        'e2e',
        '--device=nothing-is-attached',
        '--watch',
        'no such flow',
      ]);

      expect(result.exitCode, exUsage);
      expect(result.stderr, contains('no scenario called "no such flow"'));
    });
  });

  group('--preview', () {
    test('draws the root screen without a terminal', () async {
      final ProcessResult result = await _arch(<String>['--preview']);
      final String frame = _plain(result.stdout as String);

      expect(result.exitCode, 0);
      expect(frame, contains('ARCH'));
      for (final String section in <String>['Setup', 'Dev Tools', 'Tests']) {
        expect(
          frame,
          contains(section),
          reason: 'the root screen lost its `$section` section',
        );
      }
    });

    test('every section heading has rows under it', () async {
      final ProcessResult result = await _arch(<String>['--preview']);
      final List<String> lines = _plain(
        result.stdout as String,
      ).split('\n').where((String line) => line.trim().isNotEmpty).toList();

      final int tests = lines.indexWhere((String l) => l.trim() == 'Tests');
      expect(tests, greaterThan(0));
      expect(
        lines.length,
        greaterThan(tests + 1),
        reason: 'the Tests section is the last thing on the screen',
      );
    });
  });
}

/// Runs the CLI with [arguments] and waits for it.
///
/// `dart tool/arch.dart`, not `dart run tool/arch.dart`: the two are the same
/// program, but `dart run` goes through pub, and running the file directly
/// needs nothing resolved — the CLI imports nothing but `dart:*`.
///
/// And **not** [Platform.resolvedExecutable], which is the obvious way to
/// spell "the SDK running this test" and is wrong here: under `flutter test`
/// the executable running this code is `flutter_tester`, the engine. Handing
/// it a script produces a process that starts an engine, waits for a Flutter
/// app that is never coming, and times the test out thirty seconds later with
/// nothing on stdout to explain it.
///
/// `FLUTTER_ROOT` is what `flutter test` exports, and the Dart beside that
/// Flutter is the one this repository is built with — which is the guarantee
/// [Platform.resolvedExecutable] was reached for in the first place.
Future<ProcessResult> _arch(List<String> arguments) =>
    Process.run(_dart, <String>['tool/arch.dart', ...arguments]);

/// The Dart bundled with the Flutter running this test, or whatever `dart` is
/// on `PATH` when nothing says otherwise.
String get _dart {
  final String? flutterRoot = Platform.environment['FLUTTER_ROOT'];
  return flutterRoot == null ? 'dart' : '$flutterRoot/bin/dart';
}

/// [text] with the ANSI escape sequences taken out.
///
/// The frame is drawn in colour even when nothing is watching — `--preview`
/// renders exactly what the menu would — so a test that matched on the raw
/// bytes would be matching on the palette.
String _plain(String text) =>
    text.replaceAll(RegExp(r'\x1B\[[0-9;?]*[a-zA-Z]'), '');
