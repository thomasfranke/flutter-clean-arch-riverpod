// The layers that stay pure Dart, asserted against their imports.
//
// A layer that imports Flutter cannot be tested without a widget binding,
// cannot be reused outside an app, and has quietly become a UI layer. The
// four layers below `presentation` are checked against the list below —
// which is also what makes their tests fast, since none of them needs a
// `TestWidgetsFlutterBinding` to run.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Packages that only exist because Flutter does.
const List<String> flutterPackages = <String>[
  'package:flutter/',
  'package:flutter_riverpod/',
  'package:flutter_localizations/',
  'package:auto_route/',
  'package:fl_chart/',
];

/// Layers that must stay Flutter-free.
///
/// `core` is not among them: it holds the theme, the generated localizations
/// and the route table, and all three are Flutter by definition.
const List<String> pureLayers = <String>[
  'domain',
  'application',
  'infrastructure',
];

void main() {
  group('framework independence', () {
    test('the layers below presentation do not import Flutter', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (!pureLayers.contains(source.layer)) {
          continue;
        }
        for (final String import in source.imports) {
          if (!flutterPackages.any(import.startsWith)) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'These layers are pure Dart, and that is what makes their tests '
            'run without a widget binding.',
      );
    });
  });
}
