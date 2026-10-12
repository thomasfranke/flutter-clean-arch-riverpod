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

import '../../tool/src/commands/process.dart';

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

  group('the rules', () {
    // The CLI names eleven rules and the folder holds eleven files. Neither
    // list is derived from the other — the names are the CLI's vocabulary and
    // the files are what `flutter test` runs — so this is the seam where a
    // rule added to one and not the other shows up.
    test('every rule the CLI names has a file', () {
      final List<String> missing = <String>[
        for (final String rule in ruleNames)
          if (!File('$rulesDirectory/${rule}_test.dart').existsSync()) rule,
      ];

      expect(
        missing,
        isEmpty,
        reason:
            'These rules are in `ruleNames` but have no file under '
            '$rulesDirectory, so `test $codeRules <name>` offers a row '
            'that runs nothing.\n${missing.join('\n')}',
      );
    });

    test('every file in the folder is a rule the CLI names', () {
      final List<String> unknown = <String>[
        for (final FileSystemEntity entity in Directory(
          rulesDirectory,
        ).listSync())
          if (entity is File && entity.path.endsWith('_test.dart'))
            if (!ruleNames.contains(_ruleName(entity.path)))
              _ruleName(entity.path),
      ];

      expect(
        unknown,
        isEmpty,
        reason:
            'These files are rules nobody can run one at a time: add the '
            'name to `ruleNames` in process.dart, and its sentence to '
            '`_ruleDescriptions` in cli.dart.\n${unknown.join('\n')}',
      );
    });

    test('every scope the test command takes is a folder under test/', () {
      // The whole point of the words being the paths: `arch test unit` and
      // `test/unit` are the same name, so neither can be renamed without the
      // other. A word that named no folder would be a row that runs nothing.
      final List<String> missing = <String>[
        for (final String scope in <String>[...testKinds, codeRules, cli])
          if (!Directory(directoryForKind(scope)).existsSync())
            '$scope -> ${directoryForKind(scope)}',
      ];

      expect(
        missing,
        isEmpty,
        reason:
            'These words the `test` command accepts name no folder under '
            'test/, so the narrowing resolves to nothing and the run is '
            'silently empty.\n${missing.join('\n')}',
      );
    });

    test('every rule is in exactly one menu group', () {
      // The groups live in `_ruleGroups`, which is private to cli.dart — so
      // they are read back out of its source, the same way the end-to-end
      // catalogue reads the literals the CLI and the app have to share.
      final List<String> grouped = _groupedRules();

      expect(
        grouped.toSet(),
        ruleNames.toSet(),
        reason:
            'The menu groups and `ruleNames` are different lists of the same '
            'thing. A rule in neither group is a rule the menu cannot reach; '
            'a group naming a rule that is gone is a row that runs nothing.',
      );
      expect(
        grouped.length,
        grouped.toSet().length,
        reason: 'a rule appears in more than one group',
      );
    });

    test('the menu row counts them correctly', () {
      // Spelled as a literal in cli.dart because the row is const and a list
      // length is not a constant expression. This is what keeps the literal
      // honest.
      final RegExp counted = RegExp(r"detail: '(\d+) rules'");
      final String source = File('tool/cli.dart').readAsStringSync();
      final RegExpMatch? match = counted.firstMatch(source);

      expect(
        match,
        isNotNull,
        reason: 'the Rules row no longer says how many rules there are',
      );
      expect(
        int.parse(match!.group(1)!),
        ruleNames.length,
        reason:
            'the Rules row says a different number of rules from the number '
            '`ruleNames` holds',
      );
    });

    test('a rule name with a typo is refused', () async {
      final ProcessResult result = await _arch(<String>[
        'test',
        codeRules,
        'layer_grph',
      ]);

      expect(result.exitCode, exNoInput);
      expect(result.stderr, contains('does not take "layer_grph"'));
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
/// `dart tool/cli.dart`, not `dart run tool/cli.dart`: the two are the same
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
    Process.run(_dart, <String>['tool/cli.dart', ...arguments]);

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

/// The rule a file is the test for: `layer_graph_test.dart` is
/// `layer_graph`.
String _ruleName(final String path) =>
    path.replaceAll(r'\', '/').split('/').last.replaceAll('_test.dart', '');

/// Every rule named inside `_ruleGroups`, in the order it is written.
///
/// The map is private, so this reads the block out of the source rather than
/// importing it: what matters is that the two lists hold the same names, and
/// a regular expression over the one place they are written is enough to say
/// so.
List<String> _groupedRules() {
  final String source = File('tool/cli.dart').readAsStringSync();
  final int start = source.indexOf('const _ruleGroups =');
  expect(start, greaterThan(-1), reason: 'cli.dart declares no _ruleGroups');
  final int end = source.indexOf('\n};', start);

  return <String>[
    for (final RegExpMatch match in RegExp(
      r"'(\w+)'",
    ).allMatches(source.substring(start, end)))
      if (ruleNames.contains(match.group(1))) match.group(1)!,
  ];
}
