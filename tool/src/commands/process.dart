// Running other programs, which is most of what the commands do — and the
// handful of names that say how this repository is laid out.
library;

import 'dart:io';

import '../repo.dart';
import '../theme/theme.dart';

/// Runs [executable] and returns its exit code.
///
/// stdio is inherited rather than captured: these children are dashboards,
/// compilers and test runners that draw their own output, and piping them
/// would turn a live display into a transcript of every frame. It also means
/// a Ctrl-C reaches the child, which is the only way to stop a long build.
Future<int> exec(
  String executable,
  List<String> arguments, {
  Directory? workingDirectory,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: (workingDirectory ?? repoRoot()).path,
    mode: ProcessStartMode.inheritStdio,
  );
  return process.exitCode;
}

/// Runs [executable] and answers what it printed, or `null` when there is no
/// such program to run.
///
/// The opposite trade to [exec]: stdio is captured rather than inherited,
/// because the caller wants the output as a value — a version string, a
/// porcelain listing — not on screen. A missing binary comes back as `null`
/// rather than as an exception, since "is this installed" is a question with
/// an answer, not an error.
Future<ProcessResult?> capture(
  String executable,
  List<String> arguments, {
  Directory? workingDirectory,
}) async {
  try {
    return await Process.run(
      executable,
      arguments,
      workingDirectory: (workingDirectory ?? repoRoot()).path,
    );
  } on ProcessException {
    return null;
  }
}

/// The Dart to spawn, wherever this CLI spawns one.
///
/// [Platform.resolvedExecutable] rather than a bare `dart`: the SDK running
/// this process is the one that must run its children, or a machine with two
/// of them — an FVM-pinned one and whatever is on `PATH` — resolves against
/// the wrong one, and the failure is silent, since the wrong SDK still
/// builds, still tests, still generates.
///
/// `flutter` has no equivalent to borrow: the Dart binary inside an SDK is
/// not the Flutter wrapper beside it, so [flutter] stays a `PATH` lookup.
String get dartExecutable => Platform.resolvedExecutable;

/// Runs one of this repository's own scripts under the current Dart.
///
/// Called as `dart <file>.dart`, never `dart run <file>.dart`. The two are
/// the same program, but `dart run` goes through pub, which takes a lock on
/// `.dart_tool/` — so a script spawned from inside a `flutter test` process,
/// which already holds that lock, waits for it forever. Running the file
/// directly needs no lock, because everything under `tool/` imports nothing
/// but `dart:*` and has nothing to resolve. It is also three times faster to
/// start, which a CLI that spawns a runner per command notices.
///
/// `dart run build_runner …` is the exception and keeps its `run`: that one
/// is a package's executable, so pub is exactly what has to find it.
Future<int> dart(List<String> arguments, {Directory? workingDirectory}) =>
    exec(dartExecutable, arguments, workingDirectory: workingDirectory);

/// Runs `flutter`, which has to come from `PATH`.
Future<int> flutter(List<String> arguments, {Directory? workingDirectory}) =>
    exec('flutter', arguments, workingDirectory: workingDirectory);

/// Announces a step, so a composed command reads as a sequence rather than as
/// output arriving from nowhere.
void announce(String what) {
  stdout
    ..writeln()
    ..writeln('${palette.prompt}• $what${Ansi.reset}');
}

/// The layers, in dependency order: each may be imported by the ones after
/// it, and `test/integrity/architecture_test.dart` is what proves it.
///
/// Folders under `lib/`, not packages. That is the one structural difference
/// from a workspace that splits its layers into published packages, and it is
/// why the graph here has to be read out of the import statements rather than
/// out of a set of pubspecs.
const layers = [
  'core',
  'domain',
  'application',
  'data',
  'infrastructure',
  'presentation',
];

/// The kinds of test the suite is split into, as folders under `test/`.
///
/// A kind is a path, which is what keeps the menu and the filesystem from
/// drifting apart. End-to-end is not one of them: it lives in
/// `integration_test/`, it needs a device, and it is [e2eKind] below.
const testKinds = ['unit', 'widget', 'integration'];

/// The end-to-end suite — the real app, on a real device.
///
/// A kind by name and a different thing by nature: everything else here runs
/// on the host in seconds, and this one boots the app against the live API.
/// It is never part of an unnarrowed run for exactly that reason.
const e2eKind = 'e2e';

/// Where the end-to-end suite lives, which is beside `test/` rather than in
/// it — `integration_test/` is the folder name the `integration_test` package
/// requires.
const e2eDirectory = 'integration_test';

/// Tests that assert something about the repository rather than about the
/// product: the layer graph, and this CLI.
///
/// Their own folder because they answer their own kind of question, and
/// because both of them read the tree as text — no widget is pumped and no
/// use case is called.
const integrityDirectory = 'test/integrity';

/// `lib/`, where every layer is a folder.
Directory get libDirectory => Directory('${repoRoot().path}/lib');

/// `test/`, where every kind is a folder.
Directory get testDirectory => Directory('${repoRoot().path}/test');

/// Where a kind of test lives, relative to the repository root.
///
/// The one place that knows end-to-end is somewhere else, so no caller has to
/// remember it.
String directoryForKind(String kind) =>
    kind == e2eKind ? e2eDirectory : 'test/$kind';

/// The suffixes of every file a generator owns, and nobody edits by hand.
///
/// Four generators, four suffixes: freezed, json_serializable and riverpod
/// write the first two, auto_route writes `.gr.dart`, and `.config.dart` is
/// left in the list because the Makefile this CLI replaced deleted it and
/// dropping it silently would be a change nobody asked for.
///
/// Shared rather than declared where each reader needs it: `arch codegen
/// hard` deletes by this list and `arch test last` skips by it, and the two
/// disagreeing would mean a regenerated tree that reports ten edited files.
const generatedSuffixes = [
  '.freezed.dart',
  '.g.dart',
  '.gr.dart',
  '.config.dart',
];
