// Where a domain `Failure` is allowed to be minted.
//
// A datasource resolves data and nothing else: it returns the
// `HttpClientFailure` or `StorageFailure` it was handed, untouched. The
// repository implementation calls `toDomainFailure()` on the way out, because
// it is the class that implements a `domain` contract.
//
// Translating earlier flattens distinctions a repository composing two
// sources would need: an infrastructure failure is an input to a decision,
// not only something to report. The repository is the first class that sees
// every source, which makes it the last one that can still tell them apart.
//
// Read as imports rather than as calls wherever possible — a file that cannot
// name `Failure` cannot mint one, whatever it does with the name.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The import that gives a file the domain's failure vocabulary.
const String domainFailures = '${selfPackage}core/failures/failure.dart';

/// The folder allowed to translate an infrastructure failure into a domain
/// one, because it is the folder that implements the domain's contracts.
const String mintingFolder = 'lib/data/repositories_impl';

/// Folders that must not name the domain's `Failure` at all.
///
/// `data/data_sources/` because a datasource resolves data; `infrastructure/`
/// because the failure types it hands up carry no domain meaning, and naming
/// one would make the bottom layer import the top's vocabulary.
const List<String> mintingForbidden = <String>[
  'lib/data/data_sources',
  'lib/infrastructure',
];

/// The call that performs the translation.
const String translation = 'toDomainFailure';

void main() {
  group('a domain Failure is minted in one place', () {
    test('no datasource and nothing in infrastructure names Failure', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (!mintingForbidden.any(source.path.startsWith)) {
          continue;
        }
        if (!source.imports.contains(domainFailures)) {
          continue;
        }
        breaks.add(source.path);
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'These files import the domain\'s Failure, and the layer they '
            'are in is not allowed to know it. A datasource returns the '
            'HttpClientFailure or StorageFailure it was handed; the '
            'repository implementation translates it.',
      );
    });

    test('only repositories_impl calls toDomainFailure', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.folder == mintingFolder) {
          continue;
        }
        for (final String line in source.codeLines) {
          if (!line.contains(translation)) {
            continue;
          }
          breaks.add('${source.path}: ${line.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'toDomainFailure() is called on the way out of a repository '
            'implementation, which is the class that implements a domain '
            'contract. Called anywhere else it translates too early.',
      );
    });

    test('the folder that mints one still exists, and still does', () {
      final List<Source> minting = <Source>[
        for (final Source source in libSources())
          if (source.folder == mintingFolder &&
              source.codeLines.any((final String l) => l.contains(translation)))
            source,
      ];

      expect(
        minting,
        isNotEmpty,
        reason:
            'Nothing under $mintingFolder calls $translation any more. Either '
            'the translation moved — and this rule should say where to — or '
            'it is gone and the rule is guarding nothing.',
      );
    });
  });
}
