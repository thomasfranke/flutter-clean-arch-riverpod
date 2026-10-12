// A datasource resolves data from one place.
//
// One datasource, one source: the HTTP client or the key-value store, never
// both. That is what makes a datasource concrete by design — there is nothing
// to swap, so there is no contract above it, which is why
// `mocks_use_contracts` lets a test mock the class itself.
//
// Two sources in one would also be the wrong place for the decision. Reading
// from the network and falling back to the cache is a choice about what the
// app should show, and the repository is the class that sees both and is
// allowed to make it.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the datasources are.
const String datasourceFolder = 'lib/data/data_sources';

/// The contracts a datasource may hold, one each.
const List<String> sourceContracts = <String>[
  '${selfPackage}infrastructure/http_client/http_client_interface.dart',
  '${selfPackage}infrastructure/storage/storage_interface.dart',
];

void main() {
  group('a datasource has one source', () {
    test('there are datasources to check', () {
      expect(
        _datasources(),
        isNotEmpty,
        reason: 'Nothing under $datasourceFolder — the rule guards nothing.',
      );
    });

    test('each one holds exactly one infrastructure contract', () {
      final List<String> breaks = <String>[];

      for (final Source source in _datasources()) {
        final List<String> held = <String>[
          for (final String contract in sourceContracts)
            if (source.imports.contains(contract)) contract,
        ];

        if (held.length == 1) {
          continue;
        }
        breaks.add(
          held.isEmpty
              ? '${source.path} holds no source at all'
              : '${source.path} holds ${held.length}: '
                    '${held.map(_shortly).join(', ')}',
        );
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A datasource with two sources is a repository with the wrong '
            'name: deciding between them is what a repository is for. One '
            'with none resolves nothing.',
      );
    });
  });
}

/// The datasources, wiring left out.
List<Source> _datasources() => <Source>[
  for (final Source source in libSources())
    if (source.folder == datasourceFolder && !source.isWiring) source,
];

/// A contract import, as the file it names.
String _shortly(final String import) => import.split('/').last;
