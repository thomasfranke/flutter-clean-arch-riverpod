// An implementation says what it implements.
//
// A `*_repository_impl.dart` exists to satisfy a contract in
// `domain/repositories/`, and `implements` is what makes the compiler check
// that it does. Without it the class still compiles, the provider still
// resolves it, and a method the contract gained is simply missing — found at
// the call site, if at all.
//
// The same reasoning as `complete_wrappers` one layer up: what crosses a
// boundary is a contract, and the class on the far side is checked against
// it rather than trusted to match.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the implementations are.
const String implementationFolder = 'lib/data/repositories_impl';

/// What marks a file as one.
const String implementationSuffix = '_repository_impl';

/// Where the contracts they satisfy are declared.
const String contractFolder = '${selfPackage}domain/repositories/';

void main() {
  group('an implementation declares its contract', () {
    test('there are implementations to check', () {
      expect(
        _implementations(),
        isNotEmpty,
        reason: 'Nothing under $implementationFolder — nothing to check.',
      );
    });

    test('each one implements a contract from the domain', () {
      final List<String> breaks = <String>[];

      for (final Source source in _implementations()) {
        final String? declared = source.declaredType;
        final bool declares = source.codeLines.any(
          (final String line) =>
              line.contains('class $declared') && line.contains('implements '),
        );
        if (!declares) {
          breaks.add('$declared implements nothing (${source.path})');
          continue;
        }
        final bool fromDomain = source.imports.any(
          (final String import) => import.startsWith(contractFolder),
        );
        if (fromDomain) {
          continue;
        }
        breaks.add(
          '${source.path} implements something, but names no contract in '
          'domain/repositories',
        );
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Add `implements` and the contract\'s import. Without them a '
            'method the contract gains is missing here and nothing says so '
            'until something calls it.',
      );
    });
  });
}

/// The repository implementations, wiring left out.
List<Source> _implementations() => <Source>[
  for (final Source source in libSources())
    if (source.folder == implementationFolder &&
        source.name.endsWith(implementationSuffix) &&
        !source.isWiring)
      source,
];
