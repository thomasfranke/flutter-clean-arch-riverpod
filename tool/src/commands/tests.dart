// `arch test` — the suite, or one kind of it, over one layer or all.
library;

import 'dart:io';

import '../repo.dart';
import 'process.dart';

/// The dashboard that runs the tests and renders them.
const _runner = 'tool/src/commands/run_tests.dart';

/// The argument that selects the architecture assertions.
///
/// Not a kind: a run narrowed to unit tests is not asking about the layer
/// graph, and the graph is not a layer's own property. It lives in
/// `test/integrity/` with the other suite that reads the repository as text.
const arch = 'arch';

/// The argument that selects this CLI's own tests.
const cli = 'cli';

/// The argument that selects the diff-driven run.
const changed = 'diff';

/// The argument that selects the recency-driven run.
const last = 'last';

/// Runs tests.
///
/// With neither [kind] nor [targets], everything under `test/` — the
/// integrity suites included, since they are the cheapest thing in the run
/// and the most likely to explain the rest of it. [kind] narrows to a folder;
/// [targets] narrows to the layers, which means every `test/<kind>/<layer>`
/// that exists — `test/unit/core` and `test/widget/core` for `core`, because
/// both of those are that layer's tests and neither is more so than the
/// other.
///
/// [coverage] is on by default: `flutter test --coverage` measures the whole
/// of `lib/` in the same run, so the number costs one extra pass over the
/// output and nothing else. Turn it off when iterating on one failing test.
Future<int> runTests({
  String? kind,
  List<String> targets = const [],
  bool coverage = true,
}) async {
  final paths = _pathsFor(kind: kind, targets: targets);
  if (paths.isEmpty) {
    stderr.writeln(
      'arch: nothing to run — ${_describe(kind: kind, targets: targets)} '
      'has no tests',
    );
    return 66; // EX_NOINPUT
  }
  return dart([_runner, if (coverage) '--coverage', ...paths]);
}

/// Runs only the architecture assertions.
///
/// Worth running alone because they are the fastest answer to "did I just
/// break a layer boundary" — they read the import statements under `lib/` and
/// never start the app — and because crossing a boundary is where the intent
/// gets declared, deliberately, since the graph is a decision.
Future<int> runArchTests({bool coverage = false}) => dart([
  _runner,
  if (coverage) '--coverage',
  '$integrityDirectory/architecture_test.dart',
]);

/// Runs the tests for `arch` itself.
///
/// Black box: they drive the CLI as a process, the way the Makefile and CI
/// do, because that is the contract a script depends on. Coverage is off —
/// `flutter test --coverage` measures `lib/`, and none of this is in it.
Future<int> runCliTests({bool coverage = false}) => dart([
  _runner,
  if (coverage) '--coverage',
  '$integrityDirectory/cli_test.dart',
]);

/// Runs only the tests this branch's diff maps to, by filename convention.
///
/// A changed `lib/foo.dart` runs `foo_test.dart`, wherever it lives under
/// `test/`; a changed test file runs directly. No import graph and no
/// layer-wide fallback — touching `core` does not rerun every layer above it,
/// only the tests whose own name says they cover what changed.
///
/// So this is not a cheaper `test`: it proves the part you touched is green,
/// where the full run proves the repository is. [base] narrows what counts as
/// changed — `HEAD` for uncommitted work only.
Future<int> runChangedTests({String base = 'main', bool coverage = true}) =>
    dart([
      'tool/src/commands/run_changed_tests.dart',
      if (coverage) '--coverage',
      base,
    ]);

/// Runs the tests that the most recently edited files map to.
///
/// The same mapping as [runChangedTests], over a different set of files: what
/// the filesystem says was touched last, rather than what git says differs
/// from a commit.
///
/// That is the case the diff run cannot serve. A branch whose diff has grown
/// to two hundred files no longer describes the last hour of work on it, and
/// a file edited and then edited back to what the commit already holds is
/// invisible to git and is exactly what someone means by "run what I was just
/// working on". [count] defaults to ten, about a sitting's worth.
Future<int> runLastTests({int? count, bool coverage = true}) => dart([
  'tool/src/commands/run_changed_tests.dart',
  if (coverage) '--coverage',
  count == null ? '--last' : '--last=$count',
]);

/// The paths a narrowing resolves to, dropping the ones that do not exist.
///
/// Dropped rather than passed through: `flutter test` fails outright on a
/// path that is not there, and "the integration tests are not split by layer"
/// is a fact about this repository, not a mistake by whoever asked for one.
List<String> _pathsFor({String? kind, List<String> targets = const []}) {
  final root = repoRoot().path;
  bool exists(String path) =>
      Directory('$root/$path').existsSync() || File('$root/$path').existsSync();

  if (targets.isEmpty) {
    final path = kind == null ? 'test' : directoryForKind(kind);
    return exists(path) ? [path] : const [];
  }

  final kinds = kind == null ? testKinds : [kind];
  return [
    for (final target in targets)
      for (final each in kinds)
        if (exists('test/$each/$target')) 'test/$each/$target',
  ];
}

/// How a narrowing reads in the message that says it found nothing.
String _describe({String? kind, List<String> targets = const []}) =>
    switch ((kind, targets)) {
      (null, []) => 'test/',
      (final String kind, []) => directoryForKind(kind),
      (null, final List<String> targets) => targets.join(', '),
      (final String kind, final List<String> targets) =>
        '${targets.join(', ')} under test/$kind',
    };
