// Nothing hand-written is excluded from coverage.
//
// `arch coverage-gate` fails under ninety-five percent per layer, and a
// `// coverage:ignore` comment is the one thing that makes that number
// meaningless: the line stops being counted, so the percentage goes up by
// not measuring rather than by being covered.
//
// Generated files carry the marker legitimately — freezed and auto_route
// write it themselves, and nobody tests a generated `copyWith` — and those
// are skipped here because the walker never reads them in the first place.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The markers lcov honours.
const List<String> markers = <String>[
  'coverage:ignore-file',
  'coverage:ignore-line',
  'coverage:ignore-start',
];

void main() {
  group('coverage is measured, not excluded', () {
    test('no hand-written file opts out of coverage', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        for (final String line in source.lines) {
          final String found = markers.firstWhere(
            line.contains,
            orElse: () => '',
          );
          if (found.isEmpty) {
            continue;
          }
          breaks.add('${source.path}: $found');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Cover the line or delete it. Excluded, it raises the percentage '
            'by not being measured, and the gate stops meaning anything.',
      );
    });
  });
}
