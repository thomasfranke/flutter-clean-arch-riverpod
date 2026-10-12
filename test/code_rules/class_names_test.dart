// The suffix on a file implies the suffix on the class it declares.
//
// The weaker claim on purpose. A rule that demanded the class be the file's
// name in PascalCase would be a rule that makes code worse: `main.dart`
// declares `MyApp`, `core/failures/failure.dart` declares `Failure`, and
// `http_methods.dart` declares `HttpMethod` — all three right, all three
// would fail it.
//
// What is worth holding is narrower and carries information: if the file says
// `_dto`, the class is a DTO; if it says `_usecase`, the class is a UseCase.
// Then a name read in one place means the same thing read in the other, and
// neither has to be checked against the file it came from.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// What the class in a file with each suffix must be called, in turn.
///
/// Matched longest-first, so `_repository_impl` is read before `_impl` and a
/// repository implementation is not satisfied by ending in `Impl` alone.

const Map<String, String> classSuffixes = <String, String>{
  '_repository_interface': 'Interface',
  '_repository_impl': 'RepositoryImpl',
  '_datasource': 'Datasource',
  '_notifier': 'Notifier',
  '_usecase': 'UseCase',
  '_failure': 'Failure',
  '_interface': 'Interface',
  '_entity': 'Entity',
  '_screen': 'Screen',
  '_widget': 'Widget',
  '_state': 'State',
  '_impl': 'Impl',
  '_dto': 'DTO',
  '_dao': 'DAO',
  '_tab': 'Tab',
};

void main() {
  group('a class is named after the file it is in', () {
    test('every suffixed file declares a type whose name agrees', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.isWiring) {
          continue;
        }
        final String? wanted = _classSuffixFor(source);
        if (wanted == null) {
          continue;
        }

        final String? declared = source.declaredType;
        if (declared == null) {
          breaks.add('${source.path} declares no public type');
          continue;
        }
        if (declared.endsWith(wanted)) {
          continue;
        }
        breaks.add('${source.path} declares $declared, not a …$wanted');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Either the class should carry the suffix, or the file should not '
            '— the two spellings are a pair, and one of them is wrong here. '
            'A file whose suffix means something the class denies is worse '
            'than one with no suffix at all.',
      );
    });

    test('every suffix in the table is one some file uses', () {
      final List<String> names = <String>[
        for (final Source source in libSources())
          if (!source.isWiring) source.name,
      ];

      for (final String suffix in classSuffixes.keys) {
        expect(
          names.any((final String name) => name.endsWith(suffix)),
          isTrue,
          reason:
              'No file under lib/ ends in $suffix. A convention for a kind '
              'of file that does not exist is a line nobody reads.',
        );
      }
    });
  });
}

/// The class suffix [source]'s own suffix asks for, longest match first, or
/// `null` when the file's name claims nothing.
String? _classSuffixFor(final Source source) {
  String? best;
  for (final String suffix in classSuffixes.keys) {
    if (!source.name.endsWith(suffix)) {
      continue;
    }
    if (best == null || suffix.length > best.length) {
      best = suffix;
    }
  }
  return best == null ? null : classSuffixes[best];
}
