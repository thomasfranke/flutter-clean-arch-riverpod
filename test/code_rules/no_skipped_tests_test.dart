// No test is skipped.
//
// A skipped test is the worst of both: it still reads as a test anyone
// scanning the file would count on, and it runs nothing. Worse, the runner
// reports the suite green, so the thing it was written to catch is now
// uncaught *and* believed to be caught.
//
// There are two honest alternatives, and both are better: fix it, or delete
// it and let the gap be visible. A `skip:` is the third one, which keeps the
// gap and hides it.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the tests are, end-to-end included — a skipped scenario is a flow
/// the demo claims to cover and does not.
const List<String> testDirectories = <String>['test', 'integration_test'];

void main() {
  group('nothing is skipped', () {
    test('no test or group is turned off', () {
      final List<String> breaks = <String>[];

      for (final String directory in testDirectories) {
        for (final Source source in sourcesUnder(directory)) {
          for (final MapEntry<int, String> line
              in source.codeLines.asMap().entries) {
            if (!_skip.hasMatch(line.value)) {
              continue;
            }
            breaks.add('${source.path}:${line.key + 1}: ${line.value.trim()}');
          }
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Fix it or delete it. Skipped, it reports green for something '
            'nobody checked, which is worse than the gap it was hiding.',
      );
    });
  });
}

/// A `skip:` argument, which is how `test` and `group` are turned off.
final RegExp _skip = RegExp(r'\bskip\s*:');
