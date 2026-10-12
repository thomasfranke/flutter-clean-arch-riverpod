// Nothing prints.
//
// `print` writes to the console and keeps doing it in a release build, where
// nobody is reading and the string is still built. What this app has instead
// is `dart:developer`'s `log`, which takes a name and a stack trace, and
// which the tooling can filter — the dropped-row counter in
// `entity_mapper.dart` is the example worth copying.
//
// Small rule, and the reason it exists is that a `print` is the easiest line
// to leave behind: it is what you reach for while finding the bug, and it
// does not fail anything on the way out.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

void main() {
  group('nothing prints', () {
    test('no file under lib calls print', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        for (final MapEntry<int, String> line
            in source.codeLines.asMap().entries) {
          if (!_print.hasMatch(line.value)) {
            continue;
          }
          breaks.add('${source.path}:${line.key + 1}: ${line.value.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Use log() from dart:developer, with a name, the way the '
            'datasources and the entity mapper do. A print survives the '
            'release build and goes somewhere nobody looks.',
      );
    });
  });
}

/// A call to `print`, not a word ending in it.
final RegExp _print = RegExp(r'(?<![\w.])print\s*\(');
