// The Either is the only channel a failure travels.
//
// A `throw` in a layer that promises an `Either` is a second, invisible
// return path: the signature says the caller must handle a failure, and the
// exception walks past it. These three layers return failures as values, so
// none of them throws.
//
// `infrastructure/` is deliberately out of scope. It is the layer that talks
// to packages which throw — that is what it is for — and catching there is
// how the exception becomes a value in the first place. `presentation/` is
// out too: a widget that cannot build has no caller to answer.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Layers that answer with a value, never with an exception.
const List<String> valueLayers = <String>['domain', 'application', 'data'];

/// Files allowed to throw anyway, and why.
///
/// Empty. A provider overridden at the composition root is the usual reason
/// to want an entry here, and the only one in this repository sits in
/// `infrastructure/`, which this rule does not read.
const Set<String> throwExceptions = <String>{};

void main() {
  group('failures travel as values', () {
    test('nothing in the value layers throws', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (!valueLayers.contains(source.layer)) {
          continue;
        }
        if (throwExceptions.contains(source.path)) {
          continue;
        }
        final Map<int, String> numbered = source.codeLines.asMap();
        for (final MapEntry<int, String> line in numbered.entries) {
          if (!_throw.hasMatch(line.value)) {
            continue;
          }
          breaks.add('${source.path}:${line.key + 1}: ${line.value.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'These layers return an Either, which is a promise that the '
            'caller gets to decide. A throw makes that promise false for one '
            'path and leaves no trace of it in the signature.',
      );
    });

    test('every tolerated throw in the list is still there', () {
      for (final String path in throwExceptions) {
        final Source? source = <Source?>[
          for (final Source candidate in libSources())
            if (candidate.path == path) candidate,
        ].firstOrNull;

        expect(
          source,
          isNotNull,
          reason:
              '$path is listed as a tolerated throw but is no longer under '
              'lib/. Remove it — a list of exceptions that outlives the '
              'exceptions stops being read.',
        );
      }
    });
  });
}

/// A `throw` or a `rethrow` as a statement, not as a word in prose.
///
/// The comments are already off the line by the time this reads it, so the
/// doc comment in `kline_dto.dart` that says "instead of throwing" is not a
/// candidate — the word boundary is what keeps "throwing" from counting even
/// if it were.
final RegExp _throw = RegExp(r'\b(throw|rethrow)\b');
