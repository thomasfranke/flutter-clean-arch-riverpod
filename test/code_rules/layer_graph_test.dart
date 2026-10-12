// The layer graph, asserted against the import statements themselves.
//
// This repository keeps its layers as folders inside one package rather than
// as separate packages, which is the whole reason this file exists: a
// workspace can let each package's `pubspec.yaml` declare what it is allowed
// to see, and the resolver enforces it for free. Here nothing stops
// `domain/` importing `presentation/` except a reviewer noticing — so the
// rule is written down once, here, and checked on every run.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// What each layer may import, beyond itself.
///
/// Read it as "who may know about whom". The shape worth noticing is that
/// `domain` sees almost nothing and `presentation` sees almost everything:
/// the rules at the bottom outlive the screens at the top, so the arrows
/// point downwards and never back.
///
/// `core` is the exception that proves it — everything may import `core`, and
/// `core` may import nothing, because a cross-cutting utility that knew about
/// a use case would stop being cross-cutting.
const Map<String, Set<String>> allowed = <String, Set<String>>{
  'core': <String>{},
  'domain': <String>{'core'},
  'application': <String>{'core', 'domain'},
  'data': <String>{'core', 'domain', 'infrastructure'},
  // Not even `core`: the failure types it hands up carry no domain meaning,
  // and the one config it reads is read in its wiring, below. `Either` is
  // the exception, and is not a layer — see [kernel].
  'infrastructure': <String>{},
  'presentation': <String>{'core', 'domain', 'application'},
};

/// Files that are allowed to reach past [allowed], and why.
///
/// Composition is the exception every dependency graph has: something has to
/// know both the contract and the implementation, or nothing is ever wired
/// together. Riverpod puts that job in the `_di.dart` files and AutoRoute
/// puts it in the route table, so those are named here — by path, one line
/// each, with the reason — rather than left as a hole in the rule.
///
/// The point of naming them is that the list cannot grow by accident. A new
/// `_di.dart` is covered by the pattern below and needs no entry; a
/// hand-written file that crosses a boundary fails until someone writes down
/// why it should not.
const Map<String, Set<String>> wiringExceptions = <String, Set<String>>{
  // The route table names the screens it routes to, and the entity one of
  // them takes as an argument. AutoRoute generates from this file, so the
  // alternative is a router that knows no screens.
  'lib/core/routes/app_router.dart': <String>{'presentation', 'domain'},
};

/// What a `*_di.dart` may see, on top of what its layer may.
const Map<String, Set<String>> wiringReach = <String, Set<String>>{
  'application': <String>{'data'},
  'presentation': <String>{'data'},
  'data': <String>{'infrastructure'},
  // The HTTP client's provider reads the base URL from `AppConfig`.
  'infrastructure': <String>{'core'},
};

void main() {
  group('the layer graph', () {
    test('no file imports a layer its own layer may not see', () {
      final List<String> breaks = <String>[];

      for (final Source source in _graphSources()) {
        for (final String imported in source.importedLayers) {
          if (_mayImport(source, imported)) {
            continue;
          }
          breaks.add('${source.path} imports $imported');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'These imports cross a layer boundary the graph does not allow.\n'
            'Either the dependency belongs the other way round, or the file '
            'is composition wiring and belongs in a *_di.dart.',
      );
    });

    test('every layer in the graph is a folder that exists', () {
      for (final String layer in layers) {
        expect(
          Directory('lib/$layer').existsSync(),
          isTrue,
          reason: 'lib/$layer is in the graph but not on disk',
        );
      }
    });

    test('every folder under lib is a layer the graph knows', () {
      final List<String> unknown = <String>[
        for (final FileSystemEntity entity in Directory('lib').listSync())
          if (entity is Directory && !layers.contains(_name(entity.path)))
            _name(entity.path),
      ];

      expect(
        unknown,
        isEmpty,
        reason:
            'A folder under lib/ that is not a layer is a layer nobody '
            'declared: add it to the graph, or move it into one.',
      );
    });
  });
}

/// Every file the graph has an opinion about.
///
/// [compositionRoot] is skipped: its whole job is to know every layer at
/// once, and a graph that made an exception for it would be a graph with a
/// hole in the middle rather than one with a root.
List<Source> _graphSources() => <Source>[
  for (final Source source in libSources())
    if (source.path != compositionRoot) source,
];

/// Whether [source] may import [imported].
bool _mayImport(final Source source, final String imported) {
  if (imported == source.layer) {
    return true;
  }
  if (allowed[source.layer]?.contains(imported) ?? false) {
    return true;
  }
  if (source.isWiring &&
      (wiringReach[source.layer]?.contains(imported) ?? false)) {
    return true;
  }
  return wiringExceptions[source.path]?.contains(imported) ?? false;
}

String _name(final String path) => path.replaceAll(r'\', '/').split('/').last;
