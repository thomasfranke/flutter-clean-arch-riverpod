// There are no notes to self left in the source.
//
// This repository exists to be read as a finished example, and a `TODO` is
// the author saying it is not — in the one place a reader takes as the
// answer. Either the thing is worth doing, and it belongs in the issue
// tracker where it can be prioritised, or it is not, and the line is
// somebody's abandoned intention left where it reads as a known defect.
//
// `tool/analysis_options.yaml` turns the analyzer's `todo` hint off on
// purpose — a hint nobody can fail is a hint nobody reads — which is exactly
// why this is a rule instead.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The words a note to self is written with.
const List<String> notes = <String>['TODO', 'FIXME', 'HACK', 'XXX'];

void main() {
  group('nothing is left for later', () {
    test('no file under lib carries a note to self', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        for (final MapEntry<int, String> line in source.lines.asMap().entries) {
          final String found = notes.firstWhere(
            line.value.contains,
            orElse: () => '',
          );
          if (found.isEmpty) {
            continue;
          }
          breaks.add('${source.path}:${line.key + 1}: $found');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Do it, or drop it and raise it where it can be prioritised. '
            'Left here it reads as a defect the author knew about and this '
            'repository is meant to be read as the answer.',
      );
    });
  });
}
