// One public type per file.
//
// A file is found by its name, and the name can only say one thing. Two
// public classes in one file means one of them is reachable only by someone
// who already knows it is there — and it means `arch test diff`, which maps a
// changed file to the test named after it, covers the second one by accident
// or not at all.
//
// A sealed type is the exception that is not one: its variants are the type.
// `Left` and `Right` are what an `Either` is, and splitting them into three
// files would hide the one thing worth seeing, which is that there are
// exactly two of them.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Public types declared beside another one anyway, and the reason each is.
///
/// One entry, by path, with the type it covers. The point of naming them is
/// that the list cannot grow by accident: a second public class in a file
/// fails until someone writes down why it should not.
const Map<String, Set<String>> declarationExceptions = <String, Set<String>>{
  // `Unit` is what the right-hand side of an `Either` carries when the
  // operation has nothing to return. It lives beside `Either` because
  // `kernel` in the graph rule admits exactly one file from `core/` —
  // give `Unit` its own and every signature that uses it needs a second
  // import that `infrastructure` is not allowed to write.
  'lib/core/either/either.dart': <String>{'Unit'},
};

void main() {
  group('a file declares one public type', () {
    test('nothing public is declared beside something unrelated', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        final List<Declaration> declared = source.publicDeclarations;
        if (declared.length < 2) {
          continue;
        }

        final Declaration root = declared.first;
        final Set<String> allowed =
            declarationExceptions[source.path] ?? const <String>{};

        for (final Declaration extra in declared.skip(1)) {
          if (allowed.contains(extra.name)) {
            continue;
          }
          // A sealed type stands for its variants: they are cases of it, not
          // neighbours of it.
          if (root.isSealed && extra.isVariantOf(root.name)) {
            continue;
          }
          breaks.add(
            '${source.path} declares ${extra.name} beside ${root.name}',
          );
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Give the second type its own file, named after it — or, if it '
            'genuinely belongs here, add it to declarationExceptions with '
            'the reason on the line above.',
      );
    });

    test('every declaration named as an exception is still there', () {
      for (final MapEntry<String, Set<String>> entry
          in declarationExceptions.entries) {
        final Source? source = <Source?>[
          for (final Source candidate in libSources())
            if (candidate.path == entry.key) candidate,
        ].firstOrNull;

        expect(
          source,
          isNotNull,
          reason:
              '${entry.key} is listed in declarationExceptions but is no '
              'longer under lib/.',
        );

        final Set<String> declared = <String>{
          for (final Declaration each in source!.publicDeclarations) each.name,
        };
        for (final String name in entry.value) {
          expect(
            declared,
            contains(name),
            reason:
                '${entry.key} no longer declares $name. Remove it from '
                'declarationExceptions — a list of exceptions that outlives '
                'the exceptions stops being read.',
          );
        }
      }
    });
  });
}
