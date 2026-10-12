// Every widget can be built `const`.
//
// A `const` constructor is what lets the parent build the child once and hand
// the same instance back on every rebuild: Flutter compares the two by
// identity, finds them equal, and skips the subtree. Without one the child is
// a new object each frame and the comparison always fails.
//
// The analyzer's `prefer_const_constructors` only looks at call sites — it
// asks whoever builds a widget to write `const` where they can. This is the
// other half, and the half nobody is reminded of: the widget has to offer the
// constructor in the first place.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The classes a widget is written as.
const List<String> widgetBases = <String>[
  'StatelessWidget',
  'StatefulWidget',
  'ConsumerWidget',
  'ConsumerStatefulWidget',
];

void main() {
  group('every widget offers a const constructor', () {
    test('there are widgets to check', () {
      expect(
        _widgets(),
        isNotEmpty,
        reason: 'No widget classes under lib/ — the rule guards nothing.',
      );
    });

    test('each one declares its constructor const', () {
      final List<String> breaks = <String>[];

      for (final (Source source, String widget) in _widgets()) {
        final bool offers = source.codeLines.any(
          (final String line) => line.contains('const $widget('),
        );
        if (offers) {
          continue;
        }
        breaks.add('${source.path}: $widget has no const constructor');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Mark the constructor const. Without it the parent rebuilds this '
            'widget every frame however little has changed, and no `const` '
            'at the call site can help.',
      );
    });
  });
}

/// Every public widget class under `lib/`, with the file it is in.
///
/// Public only: a screen declares the pieces it is built from privately in
/// the same file, and a const constructor on one of those is the author's
/// own business.
List<(Source, String)> _widgets() => <(Source, String)>[
  for (final Source source in libSources())
    for (final Declaration declared in source.publicDeclarations)
      if (widgetBases.any(
        (final String base) => declared.line.contains('extends $base'),
      ))
        (source, declared.name),
];
