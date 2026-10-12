#!/usr/bin/env dart

// The CLI entry point: `dart run tool/cli.dart`.
//
// Two faces, one engine. With no arguments it opens a navigable menu; with a
// subcommand it runs the same code path non-interactively, which is what CI
// and other agents call. The menu never does work the subcommand cannot do —
// it prints the command it is about to run, so the two can never drift apart
// without the divergence showing on screen.
//
// It imports nothing but `dart:*` on purpose. A tool that resolves the
// package, pins the SDK and tells you what is missing cannot require any of
// that to have happened before it runs.
library;

import 'dart:io';

import 'src/cli/menu.dart';
import 'src/cli/terminal.dart';
import 'src/commands/app.dart';
import 'src/commands/codegen.dart';
import 'src/commands/coverage.dart';
import 'src/commands/doctor.dart';
import 'src/commands/e2e.dart';
import 'src/commands/e2e_catalogue.dart';
import 'src/commands/process.dart';
import 'src/commands/quality.dart';
import 'src/commands/tests.dart';
import 'src/commands/updates.dart';
import 'src/commands/workspace.dart';

import 'src/theme/theme.dart';

const _title = Layout.appTitle;
const _subtitle = Layout.appSubtitle;

/// Everything the CLI can do, in the order the menu and `--help` list it.
///
/// Alphabetical, not by importance: the list is read by someone looking for a
/// name they already have in mind, and any other order makes them scan the
/// whole thing. The test kinds are ordered by cost instead — see [_testKinds],
/// where the reader is choosing rather than looking something up.
const _commands = <_Command>[
  // Hidden from the root screen, not from the CLI: `verify` already runs
  // both, and a menu row for each would offer two steps of a sequence nobody
  // runs one at a time. A script, and the Makefile, still call them directly.
  _Command('analyze', 'Static analysis over lib, test and tool', hidden: true),
  _Command(
    'build',
    'Compile check for a release artifact',
    description:
        'Builds the app in release mode — an APK, an app bundle or an '
        'unsigned iOS build. Nothing is signed and nothing is uploaded: what '
        'this proves is that the tree still compiles, plugins included.',
  ),
  _Command(
    'clean',
    'Clear build artifacts and resolve again',
    description:
        'Runs flutter clean and then pub get, because the first removes '
        '.dart_tool and nothing builds until the second puts it back. '
        'Measured coverage is left alone — the gate reads it.',
  ),
  _Command(
    'codegen',
    'build_runner and gen-l10n over the tree',
    description:
        'Runs both generators this project has. Normal regenerates what '
        'changed; Hard deletes every .freezed.dart, .g.dart, .gr.dart and '
        '.config.dart first — and build_runner\'s cache with them — then '
        'rebuilds the lot.',
  ),
  _Command(
    'codegen-gate',
    'Regenerate from scratch and fail if the result drifted',
    hidden: true,
  ),
  _Command(
    'coverage',
    'Build the coverage report and open it',
    description:
        'Runs the suite with coverage on — the same run, and the same '
        'progress bar, as Tests — then renders one HTML report out of it and '
        'opens it. Needs genhtml, which ships with lcov.',
  ),
  _Command(
    'coverage-gate',
    'Fail if a layer is under the coverage threshold',
    hidden: true,
  ),
  _Command(
    'doctor',
    'Check this machine has what the repository needs',
    description:
        'Reports the toolchain this repository asks for — git, the Dart the '
        'pubspec declares, the Flutter .fvmrc pins, lcov — and fails if any '
        'of it is missing. The platform toolchains stay flutter doctor\'s '
        'question.',
  ),
  _Command(
    'e2e',
    'Drive the real app on a device, one scenario at a time',
    label: 'End-to-end',
    description:
        'Opens the assembled app on a device and walks it through one named '
        'flow against the live Binance API, showing which step it is on. Every '
        'run is photographed step by step and filmed; the list remembers when '
        'each scenario last passed, and on which version of the app.',
  ),
  _Command(
    'format',
    'Format, failing if anything was not formatted',
    hidden: true,
  ),
  // The label is spelled out because the derivation would give `Fvm`, and a
  // tool's name is not a word to capitalize.
  _Command(
    'fvm',
    'Pin the Flutter version declared in .fvmrc',
    label: 'FVM',
    description:
        'Installs FVM and pins this checkout to the version in .fvmrc — the '
        'same file CI reads through flutter-version-file, so everyone builds '
        'against one Flutter.',
  ),
  _Command(
    'l10n',
    'Regenerate the localizations and check every locale',
    label: 'Localizations',
    description:
        'Runs gen-l10n over lib/core/l10n and fails if any message is left '
        'untranslated in any locale — gen-l10n itself reports that by writing '
        'a file and exiting zero, which is a warning nobody reads.',
  ),
  _Command(
    'run',
    'Open the app on a device',
    description: 'Builds and launches the app on an attached device.',
  ),
  // Labelled for what it does rather than for what it is called: `setup` is
  // the token scripts and the Makefile commit to, but on a screen it says
  // nothing, and the thing it runs has a name everyone already knows.
  _Command(
    'setup',
    'Resolve the dependencies',
    label: 'Pub get',
    description:
        'The first thing to run after a clone, and after pulling a pubspec '
        'change.',
  ),
  _Command('test', 'The whole suite, or one kind of it, or one layer'),
  // Spelled out for the same reason as FVM: the derivation would give
  // `Updates`, which reads as a noun — a list of them — rather than as the
  // question the command asks.
  _Command(
    'updates',
    'Compare the pinned Flutter and Dart against the latest stable',
    label: 'Check for updates',
    description:
        'Puts what .fvmrc pins and what this machine runs beside the current '
        'stable release. It reports and changes nothing: moving the pin moves '
        'it for CI too, so it stays a decision.',
  ),
  _Command(
    'verify',
    'Everything CI runs, in one pass',
    description:
        'Format, analyze, the codegen gate, the whole suite and the coverage '
        'gate — in that order, stopping at the first failure. Green here '
        'means green on the PR.',
  ),
];

/// The kinds of test the suite is split into, in the order they cost.
///
/// They match the folders under `test/` — `unit/`, `widget/`,
/// `integration/` — so a row maps to a path, not to a naming convention that
/// has to be maintained separately.
const _testKinds = <_TestKind>[
  _TestKind(
    'unit',
    'Unit',
    description:
        'Everything under test/unit — one class at a time, with mocktail '
        'standing in for whatever it depends on. The fastest thing here, and '
        'the folder that mirrors lib/ layer for layer.',
  ),
  _TestKind(
    'widget',
    'Widget',
    description:
        'Everything under test/widget — screens and widgets pumped in a test '
        'harness, with their providers overridden. Real Flutter, no device.',
  ),
  _TestKind(
    'integration',
    'Integration',
    description:
        'Everything under test/integration — real flows across layers, a use '
        'case through its repository to a faked data source. Grouped by '
        'feature rather than by layer, because a flow is not one layer\'s.',
  ),
];

/// The code rules, grouped the way someone looks for one.
///
/// Twenty-one rows on one screen is a list nobody reads to the end, so the
/// menu asks which kind of rule first. The grouping is the menu's alone: a
/// rule is still addressed by its own name — `test code_rules layer_graph`,
/// never by its group — because three of the group names a reader would
/// reach for are also layer names, and `test code_rules domain` would mean
/// two things.
///
/// Every rule belongs to exactly one group, and `test/cli/cli_test.dart`
/// holds the two lists to that. Alphabetical twice over — the groups, and
/// the rules inside each — for the reason the command list is: both are read
/// by someone looking for a name they already have in mind.
const _ruleGroups = <String, List<String>>{
  'Application': <String>['one_method_per_usecase', 'usecases_only'],
  'Domain': <String>[
    'failure_origin',
    'immutable_domain',
    'no_json_in_domain',
    'no_throw',
    'result_pattern',
  ],
  'Infrastructure': <String>['complete_wrappers', 'wrapped_packages'],
  'Naming': <String>[
    'class_names',
    'file_names',
    'number_agreement',
    'one_public_type',
  ],
  'Presentation': <String>[
    'complete_wiring',
    'const_widgets',
    'every_message_is_read',
    'l10n',
    'riverpod_feature',
    'screens_are_consumers',
  ],
  'Source': <String>[
    'framework_independence',
    'impls_declare_contracts',
    'layer_graph',
    'no_dynamic',
    'no_exports',
    'no_print',
    'no_todo',
    'one_source_per_datasource',
    'tool_imports',
  ],
  'Tests': <String>[
    'e2e_scenarios',
    'every_test_asserts',
    'mocks_use_contracts',
    'no_coverage_ignore',
    'no_skipped_tests',
    'test_per_source',
  ],
};

/// What each code rule asserts, by the name of the file that asserts it.
///
/// Keyed by the rule's name and nothing else: the name is the file
/// (`layer_graph` is `layer_graph_test.dart`), the argument
/// (`test code_rules layer_graph`),
/// the menu row and the dashboard's label. One word in four places, so a
/// rule renamed in one is renamed in all of them — the same arrangement
/// [_layerDescriptions] has for the layers, and for the same reason.
///
/// The prose lives here rather than in the name because the names alone do
/// not say it: `contracts` and `wrappers` are both about `infrastructure/`,
/// and which one answers the question in hand is the sentence, not the word.
///
/// Alphabetical, like [ruleNames] and for the same reason.
const _ruleDescriptions = <String, String>{
  'class_names':
      'Asserts that the suffix on a file implies the suffix on the class it '
      'declares: _dto gives a DTO, _usecase a UseCase, _impl an Impl. The '
      'file and the class say the same thing, or neither can be trusted.',
  'complete_wiring':
      'Asserts that every use case, datasource and repository implementation '
      'has a *_di.dart beside it. Without one the class compiles, its '
      'unit test passes, and no screen can reach it.',
  'complete_wrappers':
      'Asserts that every wrapper under infrastructure/ has the full trio — '
      'a contract, a failure and an implementation — and that neither the '
      'contract nor the failure names the package it wraps.',
  'const_widgets':
      'Asserts that every widget declares a const constructor. Without one the '
      'parent rebuilds it every frame, and no `const` at the call site can '
      'help — which is the half the analyzer does not check.',
  'e2e_scenarios':
      'Asserts that every end-to-end flow is a declared scenario rather than '
      'a bare testWidgets, so `e2e` can name it, photograph each step and '
      'remember what the flow did last.',
  'every_message_is_read':
      'Asserts that every key in the ARB files is read somewhere. A key no '
      'screen reads is three translations carried for a sentence the app '
      'claims to say and never says.',
  'every_test_asserts':
      'Asserts that every file under test/ calls expect or verify. A test with '
      'no assertion passes by reaching the end of its body, and proves '
      'only that nothing threw.',
  'failure_origin':
      'Asserts that a domain Failure is minted in repositories_impl/ and '
      'nowhere else: a datasource returns the infrastructure failure it was '
      'handed, untouched.',
  'file_names':
      'Asserts that every file says what kind of file it is — _entity, '
      '_usecase, _dto, _widget — and that the suffix is the one its folder '
      'asks for. The same convention `test diff` maps a changed file by.',
  'framework_independence':
      'Asserts that domain, application and infrastructure import no '
      'Flutter, Riverpod, AutoRoute or fl_chart. That is what keeps their '
      'tests running without a widget binding.',
  'immutable_domain':
      'Asserts that every entity is @freezed and nothing in domain/ declares a '
      'late field or a setter. A mutable entity is a handle every holder '
      'shares, not a value.',
  'impls_declare_contracts':
      'Asserts that every repository implementation declares `implements` and '
      'names its contract from domain/repositories. Without it a method '
      'the contract gains is simply missing.',
  'l10n':
      'Asserts that no sentence is written in the source: every word a '
      'person reads comes from the ARB files through AppLocalizations, so a '
      'new language is three files rather than a hunt through the screens.',
  'layer_graph':
      'Reads the import statements under lib/ and asserts the graph: core, '
      'domain, application, data, with infrastructure below data and '
      'presentation on top. The fastest answer to "did I just break a '
      'boundary".',
  'mocks_use_contracts':
      'Asserts that a repository is mocked through its domain contract, never '
      'its implementation, and that a use case test names no file in '
      'data/ at all.',
  'no_coverage_ignore':
      'Asserts that no hand-written file carries a coverage:ignore marker. The '
      '95% gate measures what is left, so an excluded line raises the '
      'number by not being counted.',
  'no_dynamic':
      'Asserts that `dynamic` appears only where a decoded body arrives — the '
      'DTOs, the datasources and the HTTP client. Above them it is not the '
      'network\'s fault, it is a type nobody wrote.',
  'no_exports':
      'Asserts that nothing under lib/ exports. The layer graph reads import '
      'lines, so a re-export is a boundary crossed where nothing is '
      'looking.',
  'no_json_in_domain':
      'Asserts that no entity or contract names a JSON conversion. Parsing '
      'belongs to a DTO, which is also where an unreadable row becomes '
      'null instead of an entity full of zeros.',
  'no_print':
      'Asserts that nothing calls print. A print survives the release build '
      'and writes where nobody looks; log() from dart:developer takes a '
      'name and can be filtered.',
  'no_skipped_tests':
      'Asserts that no test or group is turned off with skip:. A skipped test '
      'reports green for something nobody checked, which is worse than '
      'the gap it hides.',
  'no_throw':
      'Asserts that nothing in domain, application or data throws. The '
      'Either is the only channel a failure travels; infrastructure is the '
      'layer that talks to packages which throw.',
  'no_todo':
      'Asserts that no TODO, FIXME, HACK or XXX is left under lib/. This '
      'repository is read as the answer, and a note to self in it reads '
      'as a defect the author knew about.',
  'number_agreement':
      'Asserts that a file and the class in it agree on number: a '
      'crypto_quotes_datasource holds a CryptoQuotesDatasource, not a '
      'CryptoQuoteDatasource. Only the trailing s is checked.',
  'one_method_per_usecase':
      'Asserts that a use case offers nothing but call. A second public method '
      'makes it a service, and then the folder stops naming what it does.',
  'one_public_type':
      'Asserts that a file declares one public type, so the name of the file '
      'says everything in it. A sealed type stands for its variants — Left '
      'and Right are what an Either is.',
  'one_source_per_datasource':
      'Asserts that a datasource holds exactly one infrastructure contract. '
      'Two would make it a repository with the wrong name — choosing '
      'between sources is what a repository is for.',
  'result_pattern':
      'Asserts that everything which can fail returns an Either — a domain '
      'Failure above the repository, an infrastructure one below it — and '
      'that every use case exposes call.',
  'riverpod_feature':
      'Asserts that every folder under presentation/providers holds the same '
      'three — a state, a notifier annotated so its provider is '
      'generated, and the four cases every screen switches over.',
  'screens_are_consumers':
      'Asserts that every screen is a ConsumerWidget, so it can watch its '
      'state. One that takes its data as an argument is reachable only '
      'from whoever holds the data, which a route cannot do.',
  'test_per_source':
      'Asserts that every file under lib/ has a test named after it. Not about '
      'coverage: `test diff` and `test last` map a changed file to its '
      'test by filename, so one named otherwise is invisible to both.',
  'tool_imports':
      'Asserts that tool/ imports nothing but dart:* and its own files. A '
      'tool that resolves the package and pins the SDK cannot require either '
      'to have happened before it runs.',
  'usecases_only':
      'Asserts that presentation reaches the domain through a use case and '
      'nothing else: no screen names a repository contract, and every '
      'notifier calls one. The layer graph stops data/, not this.',
  'wrapped_packages':
      'Asserts that Dio and SharedPreferences are named only inside '
      'infrastructure/, behind HttpClientInterface and StorageInterface, and '
      'that the list of tolerated leaks is still empty.',
};

/// How `codegen` can be run.
///
/// Ordered by blast radius, mildest first: `normal` regenerates what changed,
/// `hard` deletes every generated file and rebuilds the lot.
const _codegenModes = <_CodegenMode>[
  _CodegenMode(
    'normal',
    'Normal',
    null,
    description:
        'Runs build_runner over what it decides has changed, then gen-l10n. '
        'What most edits need.',
  ),
  _CodegenMode(
    'hard',
    'Hard',
    'deletes and regenerates all',
    description:
        'Deletes every generated file and build_runner\'s asset graph first, '
        'then regenerates regardless. This is what answers whether what is '
        'committed is what the annotations actually produce.',
  ),
];

/// Runs the CLI and hands its exit code to the process.
///
/// The code has to be *assigned*, not returned: Dart discards whatever `main`
/// answers, so a `Future<int> main` reports success for every failure it ever
/// finds — which is the quiet version of a broken gate, because CI goes green
/// on a tree that does not analyze.
///
/// [exitCode] rather than [exit]: `exit` terminates the isolate where it
/// stands, skipping the `finally` in [_browse] that puts the terminal back. A
/// menu session that failed would leave the user in the alternate buffer with
/// no echo. Assigning lets the isolate finish and flush on its own.
Future<void> main(List<String> args) async {
  exitCode = await _run(args);
}

/// The CLI proper: dispatches [args] and answers the code the process should
/// exit with.
Future<int> _run(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return 0;
  }

  // Renders the root screen once, as static text, and exits. The redraw loop
  // needs a terminal; this does not, which is what makes the look reviewable
  // from a pipe, a diff or a test.
  if (args.contains('--preview')) {
    stdout.writeln(_rootFrame(columns: 96).join('\n'));
    return 0;
  }

  if (args.isNotEmpty) return _dispatch(args.first, args.skip(1).toList());

  // No arguments and nowhere to draw: a menu would hang waiting for a key
  // that is never coming, so say what to type instead.
  if (Terminal.isPlain) {
    stderr.writeln('arch: no terminal attached — pass a command.');
    _printUsage();
    return 64; // EX_USAGE
  }

  return _browse();
}

/// The interactive loop: pick a command, run it, come back to where it was
/// picked.
///
/// Everything happens full screen, the work included, so a run looks like the
/// menu that started it rather than like output arriving from somewhere else.
/// The cost is that the alternate buffer discards what it held on the way
/// out, which is why a finished run waits for a keystroke: that pause is the
/// only chance to read it.
///
/// After that keystroke the loop returns to the command's own screen, not to
/// the root — running codegen twice in a row is one keystroke, not four.
Future<int> _browse() async {
  final terminal = Terminal.attach();
  try {
    while (true) {
      terminal.enterFullScreen();
      final chosen = await showMenu<String>(
        terminal,
        title: _title,
        titleSuffix: _subtitle,
        prompt: _prompt,
        items: _rootItems,
      );
      if (chosen == null) {
        terminal.leaveFullScreen();
        return 0;
      }

      // A row's value is the invocation it stands for, so `Unit` arrives here
      // as `test unit`: the kind is already decided and only the scope is
      // still open.
      final invocation = chosen.split(' ');
      await _runUntilBack(
        terminal,
        invocation.first,
        invocation.skip(1).toList(),
      );
    }
  } finally {
    terminal.restore();
  }
}

/// Runs [name] as many times as asked, returning when the user backs out.
///
/// A command with a screen of its own returns to that screen after each run.
/// One without — `verify` — has nothing to return to, so it runs once and the
/// loop above takes over.
Future<void> _runUntilBack(
  Terminal terminal,
  String name,
  List<String> carried,
) async {
  var context = carried;
  while (true) {
    final arguments = await _promptFor(terminal, name, context);
    if (arguments == null) return;

    terminal.beginScreen();
    _printHeader(name, arguments);

    // Cooked mode for the duration of the work, so a Ctrl-C reaches the child
    // rather than arriving as a byte nobody is reading.
    //
    // The exit code is dropped on purpose — the only place in the CLI where
    // that is true. A failed command inside a session is something to read
    // and try again, not a reason to throw the user out of the menu; it has
    // already printed its own failure, and the keystroke below is what gives
    // them time to see it. The subcommand face is where a code has to
    // survive, and it does, through `main`.
    terminal.suspend();
    await _dispatch(name, arguments);
    terminal.resume();

    await _waitForKey(terminal);
    if (!_hasOwnScreen(name, context)) return;
    context = _contextAfter(name, arguments, context);
  }
}

/// What the next round of [name]'s screen should already know.
///
/// Only end-to-end is two screens deep: the device is chosen once and the
/// scenarios many times, so a finished run comes back to the list of scenarios
/// rather than to the question of where to run them. Every other command keeps
/// what the row it was chosen from decided — a second lap of `Tests › Unit`
/// still asks which layer, and asking about the kind again would be a screen
/// nobody went back to.
List<String> _contextAfter(
  String name,
  List<String> arguments,
  List<String> context,
) => switch (name) {
  'e2e' => arguments.where((a) => a.startsWith(deviceFlag)).toList(),
  _ => context,
};

/// Whether [name] shows a screen of its own — and so has one to return to
/// after a run, and one to ask on before it.
///
/// The same predicate answers both, which is what keeps them from
/// disagreeing: a command that returned to a screen it never showed would
/// loop forever.
bool _hasOwnScreen(String name, List<String> carried) => switch (name) {
  'build' || 'codegen' || 'run' => true,
  // The list of scenarios is the screen: run one, read the row it wrote, run
  // the next.
  'e2e' => true,
  // Only the per-layer form asks anything; `coverage last` and
  // `coverage diff` already know what they are about.
  'coverage' => carried.isEmpty,
  // `test` asks about scope only once a kind is chosen. The whole suite has
  // nothing to ask, and neither do the CLI's own tests or the two narrowed
  // runs — none of them is split per layer. `code_rules` does: it asks which
  // one, so it has a screen until one is named.
  'test' =>
    carried.isNotEmpty &&
        carried.first != cli &&
        carried.first != changed &&
        carried.first != last &&
        (carried.first != codeRules || carried.length == 1),
  _ => false,
};

/// Draws the same title and section a menu would, above a run's output, so
/// the work reads as part of the screen that started it.
void _printHeader(String name, List<String> arguments) {
  stdout
    ..writeln(
      '${palette.title}$_title${Ansi.reset} ${palette.titleSuffix}'
      '${Layout.titleSeparator} $_subtitle${Ansi.reset}',
    )
    ..writeln()
    ..writeln('${palette.section}${_labelFor(name)}${Ansi.reset}')
    ..writeln()
    ..writeln(
      '${' ' * Layout.promptColumn}${palette.prompt}→ dart run tool/cli.dart '
      '${[name, ...arguments].join(' ')}${Ansi.reset}',
    );
}

/// Holds the finished output on screen until a key is pressed.
///
/// Without it the alternate buffer would be cleared by the next screen and
/// the run would have produced nothing anyone could read.
Future<void> _waitForKey(Terminal terminal) async {
  stdout
    ..writeln()
    ..write(
      '${' ' * Layout.promptColumn}${palette.prompt}'
      'Press enter to continue${Ansi.reset}',
    );
  await terminal.keys.firstWhere(_leavesTheOutput);
}

/// Whether [key] means "I have read this", at the prompt that holds a run's
/// output on screen.
///
/// Not "any key", which is what it used to be: inside the alternate screen
/// buffer a terminal reports a mouse scroll as arrow keys, so a flick of the
/// wheel while reading the output dismissed the screen. Enter is the answer
/// the prompt asks for; escape and quit are honoured because swallowing a
/// deliberate attempt to leave would be the opposite mistake.
bool _leavesTheOutput(Key key) =>
    key == Key.enter || key == Key.escape || key == Key.quit;

/// The root screen has no section heading: there is only one group of
/// commands above `Setup`, and a heading over the only thing on screen names
/// nothing the title has not already said.
const _prompt = 'What do you want to run?';

/// Commands the root screen lists under `Tests` rather than in the first
/// group.
///
/// `test` itself is here because the screen offers its kinds rather than the
/// command; `coverage` because someone looking for it is thinking about
/// tests, not about the browser it happens to open.
const _testGroup = {'test', 'coverage', 'e2e'};

/// Commands the root screen lists under `Dev Tools`.
///
/// What they have in common is that they act on the repository rather than on
/// the product: they regenerate it, tidy it, check it before a PR. The first
/// group is left with the two things that produce the app itself.
const _devToolsGroup = {'clean', 'codegen', 'l10n', 'verify'};

/// Commands the root screen lists under `Setup`: getting a machine ready.
const _setupGroup = {'doctor', 'fvm', 'setup', 'updates'};

/// The root screen's rows.
///
/// Labels only. The right-hand slot is for metadata a row carries, not for
/// descriptions; filling it on every row turns the list into a ragged second
/// column. The summaries live in `--help`, where there is room for them.
///
/// The test kinds are a group on this screen rather than a submenu behind
/// `Test`: they are the rows reached most often, and a whole screen to choose
/// between three of them is a keystroke spent on nothing. A row's value is
/// the invocation it stands for, which is what keeps `Unit` and
/// `arch test unit` the same thing.
List<MenuItem<String>> get _rootItems => [
  for (final command in _commands)
    if (!command.hidden &&
        !_testGroup.contains(command.name) &&
        !_setupGroup.contains(command.name) &&
        !_devToolsGroup.contains(command.name))
      MenuItem(command.label, command.name, description: command.description),
  const MenuItem.rule(),
  const MenuItem.section('Setup'),
  ..._setupRows,
  const MenuItem.rule(),
  const MenuItem.section('Dev Tools'),
  for (final command in _commands)
    if (_devToolsGroup.contains(command.name))
      MenuItem(command.label, command.name, description: command.description),
  const MenuItem.rule(),
  const MenuItem.section('Tests'),
  const MenuItem(
    'Everything',
    'test',
    emphasized: true,
    description:
        'Every test under test/ — the code rules and the CLI\'s own tests, '
        'then the unit tests '
        'layer by layer, then widget and integration. With coverage, because '
        'the same run measures it.',
  ),
  for (final kind in _testKinds)
    MenuItem(kind.label, 'test ${kind.name}', description: kind.description),
  for (final command in _commands)
    if (command.name == 'e2e')
      MenuItem(command.label, command.name, description: command.description),
  const MenuItem(
    'Coverage report',
    'coverage',
    description:
        'Measures a run, renders it as HTML and opens it. Needs genhtml, '
        'which ships with lcov. The threshold itself is checked by Verify, '
        'not here.',
  ),
  const MenuItem.rule(),
  // The rule above separates what runs a body of tests from what asks a
  // question about the repository — different things, even though both are
  // `test`.
  const MenuItem(
    'Code rules',
    'test $codeRules',
    detail: '34 rules',
    description:
        'The rules this repository holds itself to, one file each: the layer '
        'graph, the Flutter-free layers, the wrapped packages, where a '
        'Failure is minted, how it travels, and how files and classes are '
        'named. Leads to the list; all of them is still seconds.',
  ),
  const MenuItem(
    'CLI',
    'test $cli',
    description:
        'Drives `arch` itself — every command --help lists, the exit codes a '
        'script depends on, and the menu frame. Black box: it runs the CLI as '
        'a process, which is what the Makefile and CI do.',
  ),
  const MenuItem(
    'Diff — only what changed on this branch',
    'test $changed',
    description:
        'Runs only the tests this branch\'s diff maps to, by filename: a '
        'changed lib/foo.dart runs foo_test.dart. Proves the part you touched '
        'is green — the full run is what proves the repository is.',
  ),
  const MenuItem(
    'Last — the 10 files edited most recently',
    'test $last',
    description:
        'Same mapping as Diff, over what the filesystem says you touched last '
        'rather than what git says differs from main. The one that still '
        'answers "run what I was just working on" on a branch whose diff has '
        'grown too large to mean that.',
  ),
  const MenuItem(
    'Last coverage',
    'coverage $last',
    description:
        'Runs the test the file you just changed maps to, and reports the '
        'coverage of that file — here, in the terminal. Seconds, because the '
        'rest of the suite never runs.',
  ),
  const MenuItem.rule(),
  const MenuItem.back(
    label: Layout.quitLabel,
    description: 'Leaves the CLI and restores the terminal as it was.',
  ),
];

/// The `Setup` section's rows, alphabetically.
///
/// By label rather than by command name, which is the one section where the
/// two disagree: `setup` reads as `Pub get` and `updates` as `Check for
/// updates`, so ordering by name would put `FVM` first and produce a list
/// that is alphabetical only to whoever wrote it.
///
/// Sorted here rather than stored in order, so relabelling a row cannot leave
/// the section out of order behind it.
List<MenuItem<String>> get _setupRows =>
    [for (final name in _setupGroup) _rowFor(name)]
      ..sort((a, b) => a.label.compareTo(b.label));

/// The root-screen row for the command called [name].
///
/// Read off the command rather than restated, so a row and its `--help` line
/// cannot drift apart.
MenuItem<String> _rowFor(String name) {
  final command = _commands.firstWhere((command) => command.name == name);
  return MenuItem(
    command.label,
    command.name,
    description: command.description,
  );
}

List<String> _rootFrame({required int columns}) => composeFrame<String>(
  title: _title,
  titleSuffix: _subtitle,
  prompt: _prompt,
  items: _rootItems,
  selected: 0,
  columns: columns,
);

/// Collects the arguments [command] needs, on a screen of its own.
///
/// Returns an empty list for a command that takes none, and `null` when the
/// user backed out — which is a return to the root menu, not a run with
/// defaults filled in behind their back.
///
/// [carried] is what the chosen row already decided — `Unit` arrives as
/// `test unit`. A command can still ask for the rest.
Future<List<String>?> _promptFor(
  Terminal terminal,
  String command,
  List<String> carried,
) async => switch (command) {
  'build' => await _askBuildTarget(terminal),
  'codegen' => await _askCodegen(terminal),
  'coverage' =>
    carried.isEmpty ? await _askLayer(terminal, 'Coverage') : carried,
  'e2e' => await _askE2e(terminal, carried),
  'run' => await _askDevice(terminal),
  'test' => await _askTestTarget(terminal, carried),
  _ => carried,
};

/// Asks which layer to narrow to, with the whole tree first.
///
/// `All of them` leads because it is what most runs want; the individual rows
/// are for the case where the whole point is not waiting on the other five.
/// The order is the dependency order, not the alphabet: this list is a
/// picture of the architecture, and sorting it would take that away.
Future<List<String>?> _askLayer(Terminal terminal, String section) async {
  final chosen = await showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section: section,
    prompt: 'Which layer?',
    items: [
      const MenuItem(
        'All of them',
        _allTargets,
        description:
            'Every layer — what the command does when nothing narrows it.',
      ),
      const MenuItem.rule(),
      const MenuItem.section('Layers, in dependency order'),
      for (final layer in layers)
        MenuItem(
          _labelFor(layer),
          layer,
          description: _layerDescriptions[layer],
        ),
      const MenuItem.rule(),
      const MenuItem.back(description: _backDescription),
    ],
  );
  if (chosen == null) return null;
  return chosen == _allTargets ? const <String>[] : <String>[chosen];
}

/// Asks which layer to run a kind of test over, or which rule to assert.
Future<List<String>?> _askTestTarget(
  Terminal terminal,
  List<String> carried,
) async {
  // The whole suite, the CLI's own tests and the narrowed runs have nothing
  // left to narrow.
  if (!_hasOwnScreen('test', carried)) return carried;

  // The rules are not split per layer — a rule is about the tree, not about
  // one folder in it — so they get a list of their own.
  if (carried.first == codeRules) {
    final chosen = await _askRule(terminal);
    return chosen == null ? null : [codeRules, ...chosen];
  }

  final kind = _testKinds.firstWhere((k) => k.name == carried.first);
  final chosen = await _askLayer(
    terminal,
    'Tests ${Layout.crumbSeparator} ${kind.label}',
  );
  return chosen == null ? null : [kind.name, ...chosen];
}

/// Asks which code rule to assert: the kind first, then the rule.
///
/// Two screens because there are twenty-one of them. `All of them` leads on
/// both, so the common answer is one keypress deep and the specific one is
/// two — and backing out of the second returns to the kinds rather than out
/// of the question.
Future<List<String>?> _askRule(Terminal terminal) async {
  while (true) {
    final group = await showMenu<String>(
      terminal,
      title: _title,
      titleSuffix: _subtitle,
      section: 'Tests ${Layout.crumbSeparator} Code rules',
      prompt: 'Which kind of rule?',
      items: [
        const MenuItem(
          'All of them',
          _allTargets,
          description: 'Every rule in one run — one VM, still seconds.',
        ),
        const MenuItem.rule(),
        const MenuItem.section('By what they are about'),
        for (final entry in _ruleGroups.entries)
          MenuItem(
            entry.key,
            entry.key,
            detail: '${entry.value.length}',
            description: _groupDescriptions[entry.key],
          ),
        const MenuItem.rule(),
        const MenuItem.back(description: _backDescription),
      ],
    );
    if (group == null) return null;
    if (group == _allTargets) return const <String>[];

    final chosen = await _askRuleIn(terminal, group);
    if (chosen != null) return chosen;
  }
}

/// Asks which rule within [group], or comes back with `null` to the kinds.
Future<List<String>?> _askRuleIn(Terminal terminal, String group) async {
  final rules = _ruleGroups[group]!;
  final chosen = await showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section:
        'Tests ${Layout.crumbSeparator} Code rules '
        '${Layout.crumbSeparator} $group',
    prompt: 'Which rule?',
    items: [
      MenuItem(
        'All of $group',
        _allTargets,
        detail: '${rules.length}',
        description: _groupDescriptions[group],
      ),
      const MenuItem.rule(),
      const MenuItem.section('One rule at a time'),
      for (final rule in rules)
        MenuItem(_labelFor(rule), rule, description: _ruleDescriptions[rule]),
      const MenuItem.rule(),
      const MenuItem.back(description: _backDescription),
    ],
  );
  if (chosen == null) return null;
  // The whole group is not one argument — the CLI addresses rules, not
  // groups — so it resolves to the names it holds.
  return chosen == _allTargets ? rules : <String>[chosen];
}

/// What each group of rules is about, for the row that leads into it.
const _groupDescriptions = <String, String>{
  'Application':
      'The seam the screens ask through: one operation per use case, and a '
      'use case as the only way in.',
  'Domain':
      'What the middle of the app promises: entities that cannot change and '
      'do not know they are serialized, a Failure minted in one place, an '
      'Either on everything that can fail, and no throw to go around it.',
  'Infrastructure':
      'The packages this app would rather not know: reached only through a '
      'contract, and wrapped completely enough to swap.',
  'Naming':
      'What a name has to say before anyone opens the file: the kind of '
      'file, the class that matches it, the number they agree on, and one '
      'public type in it.',
  'Presentation':
      'The top layer: one Riverpod feature per folder, a provider for '
      'everything constructed, screens that can watch, widgets that can be '
      'built const, and every sentence read from the ARB files.',
  'Source':
      'What the source may and may not contain, whatever layer it is in: '
      'the dependency graph, pure Dart below presentation, implementations '
      'that name their contract, no re-exports, no dynamic past the '
      'decoding seam, no print, no notes to self, one source per datasource, '
      'and a CLI depending on nothing.',
  'Tests':
      'The suite about itself: a test named after every source, every one of '
      'them asserting something, none skipped, none excluded from coverage, '
      'mocks standing in for contracts, and every end-to-end flow declared.',
};

/// Asks how thoroughly to regenerate.
///
/// `Hard` carries its consequence in the annotation rather than behind a
/// confirmation prompt: it is destructive only to files that are generated by
/// definition, so the cost of picking it by accident is time, not work.
Future<List<String>?> _askCodegen(Terminal terminal) async {
  final mode = await showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section: 'Codegen',
    prompt: 'How much to regenerate?',
    items: [
      for (final option in _codegenModes)
        MenuItem(
          option.label,
          option.name,
          detail: option.caveat,
          description: option.description,
        ),
      const MenuItem.rule(),
      const MenuItem.back(description: _backDescription),
    ],
  );
  return mode == null ? null : [mode];
}

/// Asks which artifact to build.
///
/// iOS is listed on every platform and disabled off a Mac, rather than hidden:
/// the `ios/` folder is in the repository, and a screen that showed only
/// Android on Linux would read as a bug rather than as a fact about the host.
Future<List<String>?> _askBuildTarget(Terminal terminal) async {
  final items = <MenuItem<String>>[
    for (final target in buildTargets)
      if (target != 'ios' || Platform.isMacOS)
        MenuItem(
          buildTargetLabels[target]!,
          target,
          description: _buildDescriptions[target],
        )
      else
        MenuItem.disabled(
          buildTargetLabels[target]!,
          detail: 'needs a Mac',
          description:
              'The iOS toolchain only exists on macOS; this is '
              '${Platform.operatingSystem}.',
        ),
    const MenuItem.rule(),
    const MenuItem.back(description: _backDescription),
  ];

  final chosen = await showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section: 'Build',
    prompt: 'Which artifact?',
    items: items,
  );
  return chosen == null ? null : [chosen];
}

/// Asks which device to open the app on.
///
/// The rows are whatever Flutter says is attached right now, because that is
/// the one question this CLI cannot answer from the repository. An empty list
/// is shown as an empty list, with the reason — rather than as a menu of
/// devices that are not there.
Future<List<String>?> _askDevice(Terminal terminal) async {
  final chosen = await _chooseDevice(terminal, 'Run');
  if (chosen == null) return null;
  return chosen == _anyDevice ? const <String>[] : <String>[chosen];
}

/// The device screen itself, shared by `run` and `e2e`.
///
/// Answers the chosen id, [_anyDevice] for "let Flutter choose", or `null` when
/// the user backed out — three answers the two callers spell differently, which
/// is the only thing that differs between them.
Future<String?> _chooseDevice(Terminal terminal, String section) async {
  final attached = await devices();

  return showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section: section,
    prompt: attached.isEmpty
        ? 'No device is attached — start an emulator, or plug one in'
        : 'Which device?',
    items: <MenuItem<String>>[
      MenuItem(
        'Let Flutter choose',
        _anyDevice,
        emphasized: true,
        description: attached.isEmpty
            ? 'Runs `flutter run` with no device named, which will fail until '
                  'something is attached — and say so better than this screen '
                  'can.'
            : 'Runs `flutter run` with no device named. With one attached '
                  'that is this one; with several, Flutter asks.',
      ),
      if (attached.isNotEmpty) ...[
        const MenuItem.rule(),
        const MenuItem.section('Attached'),
        for (final device in attached)
          MenuItem(
            device.name,
            device.id,
            detail: device.platform,
            description: 'Runs the app on ${device.name} (${device.id}).',
          ),
      ],
      const MenuItem.rule(),
      const MenuItem.back(description: _backDescription),
    ],
  );
}

/// Asks where to run the end-to-end scenarios, and then which one.
///
/// Two screens, one question each. The device is not a scenario, so it does not
/// belong on the same list; and once it is chosen, [_contextAfter] carries it,
/// so running six scenarios in a row asks about the device once.
Future<List<String>?> _askE2e(Terminal terminal, List<String> carried) async {
  const section = 'End-to-end';
  if (carried.any((a) => a.startsWith(deviceFlag))) {
    final chosen = await _askScenario(terminal, section);
    return chosen == null ? null : [...carried, ...chosen];
  }
  final device = await _chooseDevice(terminal, section);
  if (device == null) return null;
  final chosen = await _askScenario(terminal, section);
  return chosen == null ? null : ['$deviceFlag$device', ...chosen];
}

/// Asks which scenario to run.
///
/// Each row says when it last passed, against which version of the app, and how
/// long it took, because "has anyone checked this since?" is what the list is
/// read for. One that never ran is listed without a date rather than hidden —
/// the list is also how somebody learns what exists.
Future<List<String>?> _askScenario(Terminal terminal, String section) async {
  final scenarios = discoverScenarios();
  if (scenarios.isEmpty) {
    stdout.writeln('arch: no scenarios under $e2eDirectory yet.');
    return null;
  }
  final results = readResults();
  final groups = <String, List<Scenario>>{
    for (final heading in scenarioGroups) heading: <Scenario>[],
  };
  for (final scenario in scenarios) {
    groups.putIfAbsent(scenario.group, () => <Scenario>[]).add(scenario);
  }
  groups.removeWhere((_, scenarios) => scenarios.isEmpty);

  final chosen = await showMenu<String>(
    terminal,
    title: _title,
    titleSuffix: _subtitle,
    section: section,
    prompt: 'Which flow?',
    items: <MenuItem<String>>[
      const MenuItem(
        'All of them',
        _allTargets,
        emphasized: true,
        description:
            'Runs every scenario, one at a time — each one installs the app '
            'and starts it from nothing, and the next cannot begin until the '
            'last has stopped. Tens of minutes.',
      ),
      const MenuItem.rule(),
      for (final entry in groups.entries) ...[
        MenuItem<String>.section(entry.key),
        for (final scenario in entry.value)
          MenuItem<String>(
            scenario.name,
            scenario.name,
            detail: resultDetail(results[scenario.name]),
            detailColor: resultColor(results[scenario.name]),
            description: scenario.describe,
          ),
      ],
      const MenuItem.rule(),
      const MenuItem.section('Recordings'),
      const MenuItem(
        'Remove them',
        'clean',
        description:
            'Deletes the frames, the videos and the logs every run left '
            'behind. The record of what passed and when is kept — nothing '
            'rebuilds that.',
      ),
      const MenuItem.rule(),
      const MenuItem.back(description: _backDescription),
    ],
  );
  if (chosen == null) return null;
  // A scenario is named in prose, so the name travels as its own words.
  return chosen.split(' ');
}

/// What `← Back` says in the footer, on every screen that has one.
const _backDescription =
    'Returns to the previous screen without running anything. Esc and q do '
    'the same.';

/// The argument that stands for every layer.
const _allTargets = 'all';

/// The menu value for "no device named" — not an argument, since what it
/// means is an empty argument list.
const _anyDevice = '';

/// A layer name as the menu shows it.
String _labelFor(String target) =>
    '${target[0].toUpperCase()}${target.substring(1)}';

/// What each layer is, for the footer.
///
/// Taken from the table in README.md, which is the source of truth for what
/// a layer is for — a row that described a layer differently from the
/// document would be worse than a row that said nothing.
const _layerDescriptions = <String, String>{
  'core':
      'Cross-cutting utilities: app config, the failure hierarchy, the l10n '
      'output, the theme and the AutoRoute table.',
  'domain':
      'Business rules: the entities, and the repository contracts the layers '
      'above depend on instead of on an implementation.',
  'application':
      'The use cases — one per thing the product does, orchestrating the '
      'domain contracts and nothing else.',
  'data':
      'The repository implementations, the data sources behind them and the '
      'DTOs and DAOs that cross the boundary.',
  'infrastructure':
      'The raw outside world — Dio, SharedPreferences — each behind a '
      'contract so it can be swapped without touching a repository.',
  'presentation':
      'The Riverpod notifiers, the states they expose, and the screens and '
      'widgets that draw them.',
};

/// What each build target produces, for the footer.
const _buildDescriptions = <String, String>{
  'apk': 'A release APK — what you sideload onto a device to try a build.',
  'appbundle': 'A release .aab — the format Play Store uploads take.',
  'ios':
      'An unsigned iOS release build. It compiles every line of Dart and '
      'every plugin\'s native side; signing needs a team and a certificate, '
      'and neither belongs in a repository.',
};

/// Runs [name] with [rest], or explains why it cannot.
///
/// Every command does its own work here. Nothing shells out to `make`: the
/// Makefile is a thin face over this, not the other way round, so a CLI that
/// called it would be a circle.
Future<int> _dispatch(String name, List<String> rest) async {
  final command = _commands.where((c) => c.name == name).firstOrNull;
  if (command == null) {
    stderr.writeln('arch: unknown command "$name"');
    _printUsage();
    return 64;
  }

  // Before anything runs. `_targetsFrom` ignores what it does not recognise,
  // which is right for the modes and kinds travelling in the same list and
  // wrong for everything else: it turns a typo into "none named", and none
  // named means all of them.
  final unrecognized = _unrecognized(command.name, rest);
  if (unrecognized.isNotEmpty) {
    stderr.writeln(
      'arch: ${command.name} does not take "${unrecognized.first}"',
    );
    return 66; // EX_NOINPUT
  }

  return switch (command.name) {
    'analyze' => await runAnalyze(),
    'build' => await runBuild(target: _firstOf(rest, buildTargets) ?? 'apk'),
    'clean' => await runClean(),
    'codegen' => await runCodegen(hard: rest.contains('hard')),
    'codegen-gate' => await runCodegenGate(),
    'coverage' => switch (rest) {
      // Narrowed to what was just touched, which is the case where the point
      // is the suite that does not run.
      _ when rest.contains(last) => await runLastCoverage(
        count: _countFrom(rest),
      ),
      _ when rest.contains(changed) => await runDiffCoverage(
        base: _baseFrom(rest),
      ),
      _ => await runCoverageReport(targets: _targetsFrom(rest)),
    },
    'coverage-gate' => await runCoverageGate(threshold: _thresholdFrom(rest)),
    'doctor' => await runDoctor(),
    // A word is a keyword only when it is the whole argument. Read out of the
    // middle of a name it would not be one: `Shows all the quotes` is a
    // scenario, and matching `all` anywhere in the line would run the suite.
    'e2e' => switch (_wordsOf(rest)) {
      // `arch e2e` names no scenario, and neither does `arch e2e --watch`, so
      // both answer with the list rather than guessing which flow was meant.
      [] || ['list'] => await runE2eList(),
      ['clean'] => await runE2eClean(),
      [_allTargets] => await runAllScenarios(
        device: _deviceFrom(rest),
        watch: rest.contains(watchFlag),
      ),
      // Anything else is a scenario name, in prose.
      final List<String> words => await runNamedScenario(
        words.join(' '),
        device: _deviceFrom(rest),
        watch: rest.contains(watchFlag),
      ),
    },
    'format' => await runFormat(),
    'fvm' => await runFvm(),
    'l10n' => await runL10n(),
    'run' => await runApp(device: rest.isEmpty ? null : rest.first),
    'setup' => await runSetup(),
    'test' => switch (rest) {
      _ when rest.contains(codeRules) => await runRuleTests(
        rules: rest.where(ruleNames.contains).toList(),
      ),
      _ when rest.contains(cli) => await runCliTests(),
      _ when rest.contains(last) => await runLastTests(count: _countFrom(rest)),
      _ when rest.contains(changed) => await runChangedTests(
        base: _baseFrom(rest) ?? 'main',
      ),
      _ => await runTests(
        kind: _firstOf(rest, testKinds),
        targets: _targetsFrom(rest),
      ),
    },
    'updates' => await runUpdates(),
    'verify' => await runVerify(),
    _ => 64,
  };
}

/// The arguments [command] does not understand.
///
/// Every command that takes any reads them out of one flat list, so the list
/// is the only place that can tell a word it was given from a word it knows.
List<String> _unrecognized(String command, List<String> arguments) {
  // A device id is spelled whatever the device says it is — `emulator-5554`, a
  // UDID, a hostname — so there is no set of words to check `run` against.
  // `flutter run` validates the name itself, and lists them all when it does
  // not match. An end-to-end scenario is named in prose for the same reason,
  // and `arch e2e` checks the name against what the source declares.
  if (command == 'run' || command == 'e2e') return const <String>[];

  final words = _wordsFor(command);
  final flags = _flagsFor(command);
  return [
    for (final argument in arguments)
      if (argument.startsWith('--')
          ? !flags.any(argument.startsWith)
          : !words.contains(argument))
        argument,
  ];
}

/// The bare words [command] accepts.
Set<String> _wordsFor(String command) => switch (command) {
  'build' => const {...buildTargets},
  'codegen' => const {..._codegenModeNames},
  'coverage' => const {_allTargets, ...layers, changed, last},
  'test' => const {
    _allTargets,
    ...layers,
    ...testKinds,
    ...ruleNames,
    codeRules,
    cli,
    changed,
    last,
  },
  _ => const {},
};

/// The flags [command] reads, by prefix — each one is `--name=value`.
Set<String> _flagsFor(String command) => switch (command) {
  'test' || 'coverage' => const {'--base=', '--count='},
  'coverage-gate' => const {'--threshold='},
  _ => const {},
};

/// The layers named in [rest], or none — which every command reads as all.
///
/// Anything that is not a layer is ignored rather than rejected: the kinds
/// travel in the same argument list, and `all` is spelled out precisely so it
/// lands here as "none named".
List<String> _targetsFrom(List<String> rest) =>
    rest.where(layers.contains).toList();

/// The device a run was pointed at, if any.
///
/// A flag, because `e2e` takes a scenario name in prose: with both positional,
/// a device id and the first word of a name would be the same argument.
String? _deviceFrom(List<String> rest) => _valueOf(rest, deviceFlag);

/// [rest] with the flags taken out, which leaves a scenario name in prose.
///
/// Both questions — was anything named, and what — are asked of the filtered
/// list, or `arch e2e --watch` looks for a scenario called nothing.
List<String> _wordsOf(List<String> rest) =>
    rest.where((word) => !word.startsWith('--')).toList();

/// The `--base=REF` an argument list carries, if any.
///
/// A flag rather than a bare argument: a git ref can be spelled anything at
/// all, so a positional one would be indistinguishable from a typo'd layer
/// name.
String? _baseFrom(List<String> arguments) => _valueOf(arguments, '--base=');

/// The `--count=N` an argument list carries, if any.
int? _countFrom(List<String> arguments) =>
    int.tryParse(_valueOf(arguments, '--count=') ?? '');

/// The `--threshold=N` an argument list carries, if any.
int? _thresholdFrom(List<String> arguments) =>
    int.tryParse(_valueOf(arguments, '--threshold=') ?? '');

/// The value of the `--name=value` flag spelled [flag], or `null`.
String? _valueOf(List<String> arguments, String flag) {
  final argument = arguments.where((a) => a.startsWith(flag)).firstOrNull;
  return argument?.substring(flag.length);
}

/// The first argument that is one of [known], or `null`.
String? _firstOf(List<String> arguments, Iterable<String> known) =>
    arguments.where(known.contains).firstOrNull;

/// How `codegen` can be run, as the command line spells it.
const _codegenModeNames = ['normal', 'hard'];

void _printUsage() {
  stdout
    ..writeln()
    ..writeln('  $_title ${Layout.titleSeparator} $_subtitle')
    ..writeln()
    ..writeln('  dart run tool/cli.dart           Open the menu')
    ..writeln('  dart run tool/cli.dart <command> Run it directly')
    ..writeln();
  // Width from the longest name rather than a constant, so adding a command
  // cannot quietly break the column.
  final width = _commands
      .map((c) => c.name.length)
      .reduce((a, b) => a > b ? a : b);
  for (final command in _commands) {
    stdout.writeln('    ${command.name.padRight(width)}  ${command.summary}');
  }
  stdout.writeln();
}

final class _Command {
  const _Command(
    this.name,
    this.summary, {
    this.hidden = false,
    this.description,
    String? label,
  }) : _label = label;

  final String? _label;

  /// What the footer says while this command's row is selected.
  ///
  /// Longer than [summary], which has one line in `--help` to work with.
  /// Hidden commands have none: they are never a row.
  final String? description;

  /// Kept out of the root screen's rows, but still a command: reachable by
  /// name, listed in `--help`.
  final bool hidden;

  /// What the command is called on the command line: lowercase, one word, the
  /// token a user types and a script commits to.
  final String name;

  /// What the menu reads as: [name] capitalized, unless the command spells
  /// itself differently.
  ///
  /// Derived rather than stored so the two cannot drift — a row that says
  /// `Verify` always runs `verify`. The override exists for names that are
  /// not words, like `FVM`.
  String get label => _label ?? '${name[0].toUpperCase()}${name.substring(1)}';

  final String summary;
}

/// One kind of test, as a folder under `test/` and as a row.
final class _TestKind {
  const _TestKind(this.name, this.label, {this.description});

  /// The folder under `test/`, which is also the argument.
  final String name;
  final String label;
  final String? description;
}

/// One way to run `codegen`.
final class _CodegenMode {
  const _CodegenMode(this.name, this.label, this.caveat, {this.description});

  final String name;
  final String label;

  /// The consequence worth reading before choosing it, in the row's metadata
  /// column.
  final String? caveat;
  final String? description;
}
