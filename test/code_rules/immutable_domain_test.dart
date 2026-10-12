// The domain holds values, and a value does not change.
//
// An entity is what the layers above compare, cache and pass around freely,
// and all three of those are only safe while it cannot change under them. A
// mutable field turns every reference into a shared handle: a screen holding
// yesterday's quote and a notifier holding today's would be the same object.
//
// `@freezed` is how this repository says it — the generated class is final,
// its fields are final, and `copyWith` is the only way to get a different
// one. So the rule is that annotation, plus the two ways a field gets
// mutable anyway.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The folder holding the types the whole app passes around.
const String entityFolder = 'lib/domain/entities';

/// The annotation that makes a class a value.
const String annotation = '@freezed';

void main() {
  group('the domain is immutable', () {
    test('every entity is @freezed', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.folder != entityFolder) {
          continue;
        }
        if (source.codeLines.any((final String l) => l.contains(annotation))) {
          continue;
        }
        breaks.add(source.path);
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Without $annotation the class is an ordinary one: nothing makes '
            'its fields final, nothing gives it value equality, and two '
            'entities with the same contents stop being equal.',
      );
    });

    test('nothing in the domain declares a mutable member', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != 'domain') {
          continue;
        }
        for (final MapEntry<int, String> line
            in source.codeLines.asMap().entries) {
          if (!_mutable.hasMatch(line.value)) {
            continue;
          }
          breaks.add('${source.path}:${line.key + 1}: ${line.value.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A `late` field is assigned after construction and a setter is '
            'assigned at any time. Either one makes the entity a handle '
            'rather than a value, and every holder of it shares the change.',
      );
    });
  });
}

/// A `late` field or a setter, as a declaration rather than a word.
final RegExp _mutable = RegExp(r'^\s*(late\s|set\s+[a-z_])');
