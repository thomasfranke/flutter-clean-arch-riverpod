// Every source file has a test named after it.
//
// Not a claim about coverage — the gate measures that, and it is at a
// hundred percent. This is about the mapping two commands depend on:
// `arch test diff` and `arch test last` take a changed `lib/foo.dart` and
// run `foo_test.dart`, by filename and nothing else. A file whose tests live
// under some other name is covered and invisible to both — so the fast loop
// that proves what you just touched silently skips it, and the only run that
// covers it is the whole suite.
//
// The fix is either a test file of that name or an entry below saying which
// test does cover it, which is the same information written where the
// tooling cannot read it.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the tests are.
const String testDirectory = 'test';

/// What a test file is called.
const String testSuffix = '_test';

/// Whether [source] declares nothing but a contract.
///
/// A pure `abstract` type has no behaviour to run: there is nothing to
/// construct, nothing to call, and a test of one would assert that Dart
/// still compiles. What a contract promises is checked statically instead —
/// `result_pattern` reads its signatures, and `mocks_use_contracts` is what
/// says the tests above it stand in for this and not for an implementation.
bool _isContractOnly(final Source source) {
  final List<Declaration> declared = source.publicDeclarations;
  if (declared.isEmpty) {
    return false;
  }
  // A `factory` is what tells a contract from a value: freezed writes its
  // value types as `abstract class … with _$…` and gives them factories, so
  // abstractness alone would exempt every entity in the repository.
  if (source.codeLines.any((final String line) => line.contains('factory '))) {
    return false;
  }
  return declared.every(
    (final Declaration each) => each.line.contains('abstract '),
  );
}

/// Files covered under another name, and the name.
///
/// An entry is a file `arch test diff` will not run when it changes. It buys
/// nothing except the record of that, which is why the list is worth reading
/// rather than growing.
const Map<String, String> coveredElsewhere = <String, String>{};

void main() {
  group('every source maps to a test by name', () {
    test('every file under lib has a test named after it', () {
      final Set<String> tests = <String>{
        for (final Source source in sourcesUnder(testDirectory))
          if (source.name.endsWith(testSuffix))
            source.name.substring(0, source.name.length - testSuffix.length),
      };

      final List<String> breaks = <String>[
        for (final Source source in libSources())
          if (source.path != compositionRoot &&
              !_isContractOnly(source) &&
              !tests.contains(source.name) &&
              !coveredElsewhere.containsKey(source.path))
            source.path,
      ];

      expect(
        breaks,
        isEmpty,
        reason:
            'Add <name>_test.dart for each, anywhere under test/ — the '
            'mapping reads the filename, not the folder. If something else '
            'already covers it, name that in coveredElsewhere and accept '
            'that `test diff` will not run it.',
      );
    });

    test('every file named as covered elsewhere is still there', () {
      final Set<String> present = <String>{
        for (final Source source in libSources()) source.path,
      };

      final List<String> gone = <String>[
        for (final String path in coveredElsewhere.keys)
          if (!present.contains(path)) path,
      ];

      expect(
        gone,
        isEmpty,
        reason:
            'These are listed as covered under another name but are no '
            'longer under lib/. Remove them — a list of exceptions that '
            'outlives the exceptions stops being read.',
      );
    });
  });
}
