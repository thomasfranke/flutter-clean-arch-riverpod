// A repository is mocked through the contract, never the implementation.
//
// The whole point of `domain/repositories/` is that the layers above name a
// contract and not a class. A unit test is where that is easiest to forget:
// mocking `KlineRepositoryImpl` works, and quietly makes the use case's test
// depend on the implementation the use case itself is written not to know.
//
// Datasources are mocked as themselves on purpose — they are concrete by
// design, one per source, with nothing to swap — and so are the packages
// `infrastructure` wraps, since a test of the wrapper has to stand in for
// the thing being wrapped.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the tests are.
const String testDirectory = 'test';

/// What marks a class as the implementation of a repository.
const String implementationSuffix = 'RepositoryImpl';

/// The folder whose tests may name an implementation: its own.
const String implementationTests = 'test/unit/data/repositories_impl';

/// Where a use case's tests live, which may name no `data/` file at all.
const String useCaseTests = 'test/unit/application';

/// The import prefix of the layer a use case test may not reach.
const String dataLayer = '${selfPackage}data/';

void main() {
  group('a mock stands in for a contract', () {
    test('no mock implements a repository implementation', () {
      final List<String> breaks = <String>[];

      for (final Source source in sourcesUnder(testDirectory)) {
        if (source.path.startsWith('$implementationTests/')) {
          continue;
        }
        for (final RegExpMatch match in _mock.allMatches(
          source.codeLines.join('\n'),
        )) {
          final String mocked = match.group(2)!;
          if (!mocked.endsWith(implementationSuffix)) {
            continue;
          }
          breaks.add('${source.path}: ${match.group(1)} mocks $mocked');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Mock the contract in domain/repositories instead. A test that '
            'stands in for the implementation asserts against the class its '
            'subject was written never to name.',
      );
    });

    test('no use case test names the data layer', () {
      final List<String> breaks = <String>[];

      for (final Source source in sourcesUnder(useCaseTests)) {
        for (final String import in source.imports) {
          if (!import.startsWith(dataLayer)) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A use case sees a contract and an entity. Its test seeing more '
            'than that is the test knowing something the subject does not, '
            'and it will keep passing after the contract stops matching.',
      );
    });
  });
}

/// A mocktail double and the type it stands in for.
final RegExp _mock = RegExp(
  r'class\s+(_?\w*(?:Mock|Fake)\w*)\s+(?:extends\s+Mock\s+)?'
  r'implements\s+([A-Za-z_]\w*)',
  dotAll: true,
);
