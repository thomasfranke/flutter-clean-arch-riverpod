// Dio and SharedPreferences stay behind their contracts.
//
// Each one is reached through `HttpClientInterface` or `StorageInterface`, so
// that swapping Dio for something else is an edit inside one folder rather
// than across the repository. The list of tolerated leaks below is empty, and
// this file is what keeps it that way.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Files outside `infrastructure/` allowed to import a wrapped package, and
/// the reason each one is tolerated.
///
/// Empty, and meant to stay that way. The two files once listed here imported
/// `shared_preferences` only to name it in a doc comment; an entry is a leak
/// written down rather than forgiven silently, so a new one needs its reason
/// on the line above it.
const Set<String> wrappedPackageExceptions = <String>{};

void main() {
  group('infrastructure stays behind its contracts', () {
    test('nothing outside infrastructure imports a wrapped package', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer == 'infrastructure') {
          continue;
        }
        if (wrappedPackageExceptions.contains(source.path)) {
          continue;
        }
        for (final String import in source.imports) {
          if (!wrappedPackages.any(import.startsWith)) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Dio and SharedPreferences are reached through '
            'HttpClientInterface and StorageInterface, so that swapping one '
            'is an edit inside lib/infrastructure rather than across the '
            'repository.',
      );
    });

    test('every tolerated leak in the list is still there', () {
      for (final String path in wrappedPackageExceptions) {
        expect(
          File(path).existsSync(),
          isTrue,
          reason:
              '$path is listed as a tolerated leak but no longer exists. '
              'Remove it from wrappedPackageExceptions — a list of '
              'exceptions that outlives the exceptions stops being read.',
        );
      }
    });
  });
}
