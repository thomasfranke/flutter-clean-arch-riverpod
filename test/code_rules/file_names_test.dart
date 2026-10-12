// A file carries the suffix its folder asks for.
//
// Not cosmetics. `arch test diff` and `arch test last` map a changed file to
// its tests by filename and nothing else, so a name is the only handle the
// tooling has on a file — and the suffix is what says which of the handful of
// things in this architecture it is. A `foo.dart` in `data_sources/` is a
// datasource whether or not it says so, and whoever reads the folder next
// has to open it to find out.
//
// Only the folders with a convention to enforce are listed. `core/` is a bag
// of cross-cutting things by definition and `infrastructure/` names its files
// after the package they wrap, which the `wrappers` rule asserts instead.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// What a file in each folder must be called, by longest matching prefix.
///
/// A set rather than one suffix where the folder holds two kinds that are
/// genuinely different: `data_objects/` has the DTOs that cross the network
/// and the DAOs that cross storage, and `providers/` has a notifier and the
/// state it publishes.
const Map<String, Set<String>> requiredSuffixes = <String, Set<String>>{
  'lib/domain/entities': <String>{'_entity'},
  'lib/domain/repositories': <String>{'_repository_interface'},
  'lib/application': <String>{'_usecase'},
  'lib/data/data_objects': <String>{'_dto', '_dao'},
  'lib/data/data_sources': <String>{'_datasource'},
  'lib/data/repositories_impl': <String>{'_repository_impl'},
  'lib/presentation/providers': <String>{'_notifier', '_state'},
  'lib/presentation/screens': <String>{'_screen', '_tab', '_widget'},
};

/// Every suffix this repository names a kind of file with.
///
/// The vocabulary, and the whole of it: a file whose name ends in none of
/// these says nothing about what it holds, and whoever reads the folder next
/// has to open it to find out. New kind of file, new entry — written here
/// once, so the word means the same thing in every folder that uses it.
const Set<String> typeSuffixes = <String>{
  '_colors',
  '_config',
  '_constants',
  '_dao',
  '_datasource',
  '_dto',
  '_either',
  '_entity',
  '_enum',
  '_failure',
  '_impl',
  '_interceptor',
  '_interface',
  '_mapper',
  '_notifier',
  '_repository_impl',
  '_repository_interface',
  '_router',
  '_screen',
  '_state',
  '_tab',
  '_theme',
  '_usecase',
  '_value_object',
  '_widget',
};

/// Files that name no kind, and why.
///
/// `main.dart` is the composition root: it is the one file whose name is the
/// convention rather than an instance of it. Composition wiring is covered by
/// `_di.dart`, which is a suffix this list does not need to repeat.
const Set<String> suffixExceptions = <String>{compositionRoot};

void main() {
  group('a file is named after what it is', () {
    test('every file carries a suffix naming the kind of file it is', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.isWiring || suffixExceptions.contains(source.path)) {
          continue;
        }
        if (_namesAKind(source.name)) {
          continue;
        }
        breaks.add(source.path);
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A name that does not say what kind of file it is makes the '
            'reader open it. Give each of these the suffix for what it holds '
            '— and if it is a kind this repository has not named yet, add '
            'the suffix to typeSuffixes first, so the word is chosen once '
            'rather than per file.',
      );
    });

    test('every file carries the suffix its folder asks for', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        // Composition wiring is named after what it wires, plus the suffix
        // that says it is wiring. The graph rule already knows it by that.
        if (source.isWiring) {
          continue;
        }
        // A suffix names a kind of class, so a file that declares none has
        // nothing for it to name: `entity_list.dart` is two functions and
        // `failure_mappers.dart` is two extensions. Both are helpers the
        // repositories are built from, not repositories.
        if (source.declaredType == null) {
          continue;
        }
        final Set<String>? wanted = _suffixesFor(source);
        if (wanted == null) {
          continue;
        }
        if (wanted.any(source.name.endsWith)) {
          continue;
        }
        breaks.add(
          '${source.path} is in a folder that asks for '
          '${wanted.map((final String s) => '$s.dart').join(' or ')}',
        );
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Either the file belongs somewhere else, or it is one of these '
            'things and should say so, or the folder holds a kind nobody has '
            'declared yet — in which case the suffix goes in the table above, '
            'with the others.',
      );
    });

    test('every suffix a folder asks for is in the vocabulary', () {
      final List<String> unknown = <String>[
        for (final Set<String> wanted in requiredSuffixes.values)
          for (final String suffix in wanted)
            if (!typeSuffixes.contains(suffix)) suffix,
      ];

      expect(
        unknown,
        isEmpty,
        reason:
            'A folder asking for a suffix the vocabulary does not hold is two '
            'lists disagreeing about the same word.',
      );
    });

    test('every folder in the table is a folder that exists', () {
      final Set<String> folders = <String>{
        for (final Source source in libSources()) source.folder,
      };

      for (final String prefix in requiredSuffixes.keys) {
        expect(
          folders.any((final String folder) => folder.startsWith(prefix)),
          isTrue,
          reason:
              '$prefix is in the table but nothing under lib/ is in it. A '
              'convention for a folder that no longer exists is a line '
              'nobody reads.',
        );
      }
    });
  });
}

/// Whether [name] says which kind of file it is.
///
/// Either it ends in a suffix from [typeSuffixes], or it *is* one: a file
/// holding nothing but the type the suffix names has no prefix to carry —
/// `either.dart` is the `Either`, not an `Either` of something.
bool _namesAKind(final String name) =>
    typeSuffixes.any(name.endsWith) ||
    typeSuffixes.any((final String suffix) => name == suffix.substring(1));

/// The suffixes [source]'s folder asks for, by the longest prefix that
/// matches it, or `null` when no folder in the table claims it.
Set<String>? _suffixesFor(final Source source) {
  String? best;
  for (final String prefix in requiredSuffixes.keys) {
    if (!source.folder.startsWith(prefix)) {
      continue;
    }
    if (best == null || prefix.length > best.length) {
      best = prefix;
    }
  }
  return best == null ? null : requiredSuffixes[best];
}
