// Everything that is constructed has a provider beside it.
//
// A use case, a datasource and a repository implementation are each built
// from something else, and the composition that builds them lives in a
// `*_di.dart` next to the file — which is the one place in this repository
// allowed to know both a contract and its implementation.
//
// Written down because the failure is quiet: a use case with no provider
// compiles, its unit test passes with a mock, and it is simply unreachable
// from a screen. Nothing fails until somebody tries to use it.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The suffixes of files whose classes something has to construct.
///
/// Entities and DTOs are not among them: they are made from data, by whoever
/// holds the data, and a provider for one would be a provider for a value.
const List<String> wiredSuffixes = <String>[
  '_usecase',
  '_datasource',
  '_repository_impl',
];

void main() {
  group('everything constructed has a provider', () {
    test('every wired file has a *_di.dart beside it', () {
      final Set<String> present = <String>{
        for (final Source source in libSources()) source.path,
      };
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.isWiring) {
          continue;
        }
        if (!wiredSuffixes.any(source.name.endsWith)) {
          continue;
        }
        final String wiring = '${source.folder}/${source.name}$wiringSuffix';
        if (present.contains(wiring)) {
          continue;
        }
        breaks.add('${source.path} has no $wiring');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Without a provider the class is reachable only by constructing '
            'it by hand, which is what the composition root exists to avoid. '
            'The unit test will still pass — it builds its own.',
      );
    });

    test('every *_di.dart is named after something beside it', () {
      final List<String> orphans = <String>[];

      for (final Source source in libSources()) {
        if (!source.isWiring) {
          continue;
        }
        final String wires = source.name.substring(
          0,
          source.name.length - '_di'.length,
        );
        // Prefix rather than equality: a provider file is named after what it
        // offers, and what it offers is usually a contract and an
        // implementation — `http_client_di.dart` wires
        // `http_client_interface.dart`, not an `http_client.dart` that has
        // never existed.
        final bool names = libSources().any(
          (final Source each) =>
              each.folder == source.folder &&
              !each.isWiring &&
              each.name.startsWith(wires),
        );
        if (names) {
          continue;
        }
        orphans.add(
          '${source.path} is named for "$wires", and nothing '
          'beside it is',
        );
      }

      expect(
        orphans,
        isEmpty,
        reason:
            'A provider file is found by the name of what it provides. Named '
            'after its folder instead, it is the one file in the folder whose '
            'name says nothing about what is in it.',
      );
    });
  });
}
