// Every test asserts something.
//
// A test with no assertion passes by arriving at the end of its body. It
// reports green, it counts towards the total, and it proves that the code it
// touched did not throw — which is not what anybody reading the name of it
// believes.
//
// `integration_test/` is out of scope and not an exception: a scenario
// asserts through the robot, which fails the step rather than the
// expectation, and `e2e_scenarios` is the rule that reads those.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the tests that assert for themselves are.
const String testDirectory = 'test';

/// Every way this repository makes a claim.
///
/// `verify` counts: a mocktail verification fails the test when the call did
/// not happen, which is an assertion written the other way round.
const List<String> assertions = <String>[
  'expect(',
  'expectLater(',
  'verify(',
  'verifyNever(',
  'verifyInOrder(',
];

void main() {
  group('no test passes by arriving at the end', () {
    test('every test file makes at least one claim', () {
      final List<String> breaks = <String>[];

      for (final Source source in sourcesUnder(testDirectory)) {
        if (!source.name.endsWith('_test')) {
          continue;
        }
        final String text = source.codeLines.join('\n');
        if (assertions.any(text.contains)) {
          continue;
        }
        breaks.add(source.path);
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A file of tests that never calls expect proves only that '
            'nothing threw. Say what the result should be.',
      );
    });
  });
}
