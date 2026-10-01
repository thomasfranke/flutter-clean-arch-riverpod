// `arch codegen` — build_runner and gen-l10n, in two strengths.
library;

import 'dart:io';

import '../repo.dart';
import '../theme/theme.dart';
import 'process.dart';

/// Regenerates everything a generator owns.
///
/// Two generators run here, and both have to: `build_runner` writes the
/// freezed unions, the JSON (de)serialisation, the Riverpod providers and the
/// AutoRoute table, and `gen-l10n` writes `lib/core/l10n/generated`. They are
/// separate tools with separate outputs, and CI checks both — so a codegen
/// command that ran only the first would leave half the generated tree behind
/// and the gate would be the thing that found out.
///
/// [hard] deletes the generated files first, and build_runner's asset graph
/// with them, then regenerates from nothing. That is the mode that answers
/// "is what is committed actually what the annotations produce", which is why
/// the gate sits behind it.
Future<int> runCodegen({required bool hard}) async {
  if (hard) {
    final deleted = _deleteGenerated(libDirectory);
    _deleteBuildCache();
    stdout.writeln(
      '${palette.prompt}• Deleted $deleted generated file'
      '${deleted == 1 ? '' : 's'}${Ansi.reset}',
    );
  }

  announce('Codegen — build_runner');
  // No `--delete-conflicting-outputs`: build_runner 2.13 removed it and warns
  // on every run that it was ignored. What it used to settle — which of two
  // builders wins a file — this project never had, and the cache it did *not*
  // settle is deleted above, which is the part that actually mattered.
  final generated = await dart(['run', 'build_runner', 'build']);
  if (generated != 0) return generated;

  return runL10n();
}

/// Regenerates the localizations, and fails if any message is untranslated.
///
/// Two things rather than one, because `gen-l10n` reports a missing
/// translation by writing it to a file and exiting zero — which is a warning
/// nobody reads. `l10n.yaml` points `untranslated-messages-file` at
/// `l10n_missing_translations.json`, and this is what turns that file into an
/// answer: an empty file, or a literal `{}`, means every message is
/// translated in every locale.
Future<int> runL10n() async {
  announce('Codegen — gen-l10n');
  final generated = await flutter(['gen-l10n']);
  if (generated != 0) return generated;

  final report = File('${repoRoot().path}/$untranslatedMessagesPath');
  // Absent is the strongest pass there is: gen-l10n removes the file
  // altogether when there was nothing to report.
  if (!report.existsSync()) return _translationsComplete();

  final contents = report.readAsStringSync().trim();
  if (contents.isEmpty || contents == '{}') return _translationsComplete();

  stdout
    ..writeln('  Missing translations:')
    ..writeln(contents);
  return 1;
}

int _translationsComplete() {
  stdout.writeln('  Every message is translated in every locale.');
  return 0;
}

/// Where `gen-l10n` lists whatever it could not translate. Declared in
/// `l10n.yaml`, and named here so the check and the config cannot drift.
const untranslatedMessagesPath = 'l10n_missing_translations.json';

/// Removes build_runner's asset graph, which is what `build_runner clean`
/// does and the only way to make it build again after its outputs are gone.
///
/// The half that is easy to miss: `--delete-conflicting-outputs` only settles
/// which of two builders wins a file, while the asset graph still records
/// every output as written. Deleting the files without deleting this leaves a
/// package that rebuilds nothing and reports success — the tree half
/// generated, the analyzer full of undefined types, and the gate the only
/// thing that notices.
void _deleteBuildCache() {
  final cache = Directory('${repoRoot().path}/.dart_tool/build');
  if (cache.existsSync()) cache.deleteSync(recursive: true);
}

/// Deletes every generated file under [directory], returning how many.
///
/// In Dart rather than by shelling out to `find -name ... -delete`, which is
/// what the Makefile did and what does not exist on Windows.
///
/// Symlinks are not followed: a link out of the tree is not ours to delete
/// through.
int _deleteGenerated(Directory directory) {
  if (!directory.existsSync()) return 0;

  var deleted = 0;
  for (final entity in directory.listSync(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is! File) continue;
    if (!generatedSuffixes.any(entity.path.endsWith)) continue;
    entity.deleteSync();
    deleted++;
  }
  return deleted;
}
