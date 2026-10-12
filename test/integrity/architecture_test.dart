// The layer graph, asserted against the import statements themselves.
//
// This repository keeps its layers as folders inside one package rather than
// as separate packages, which is the whole reason this file exists: a
// workspace can let each package's `pubspec.yaml` declare what it is allowed
// to see, and the resolver enforces it for free. Here nothing stops
// `domain/` importing `presentation/` except a reviewer noticing — so the
// rule is written down once, here, and checked on every run.
//
// It reads the source as text. No analyzer, no package, no app started: the
// question is which files name which other files, and the import line is
// where that is said.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The layers, in dependency order.
const List<String> layers = <String>[
  'core',
  'domain',
  'application',
  'data',
  'infrastructure',
  'presentation',
];

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
  'lib/core/routes/auto_route.dart': <String>{'presentation', 'domain'},
};

/// The suffix that marks a file as composition wiring rather than logic.
///
/// A `*_di.dart` holds Riverpod providers and nothing else: it names an
/// implementation so something else does not have to. `application`'s
/// providers hand a use case its repository, which is the one place the
/// application layer is allowed to see `data`.
const String wiringSuffix = '_di.dart';

/// What a `*_di.dart` may see, on top of what its layer may.
const Map<String, Set<String>> wiringReach = <String, Set<String>>{
  'application': <String>{'data'},
  'presentation': <String>{'data'},
  'data': <String>{'infrastructure'},
  // The HTTP client's provider reads the base URL from `AppConfig`.
  'infrastructure': <String>{'core'},
};

/// Packages that only exist because Flutter does.
///
/// A layer that imports one of these cannot be tested without a widget
/// binding, cannot be reused outside an app, and has quietly become a UI
/// layer. The four layers below `presentation` are checked against this list
/// — which is also what makes their tests fast, since none of them needs a
/// `TestWidgetsFlutterBinding` to run.
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

/// The packages `infrastructure` exists to wrap.
///
/// Each one is reached through a contract — `HttpClientInterface`,
/// `StorageInterface` — so that swapping Dio for something else is an edit
/// inside one folder rather than across the repository.
const List<String> wrappedPackages = <String>[
  'package:dio/',
  'package:shared_preferences/',
];

/// Files outside `infrastructure/` allowed to import a wrapped package, and
/// the reason each one is tolerated.
///
/// Empty, and meant to stay that way. The two files once listed here imported
/// `shared_preferences` only to name it in a doc comment; an entry is a leak
/// written down rather than forgiven silently, so a new one needs its reason
/// on the line above it.
const Set<String> wrappedPackageExceptions = <String>{};

/// Files any layer may import, whatever [allowed] says.
///
/// `Either` is vocabulary at the level of the language — what `Future` is to
/// async code — so importing it says nothing about which layer a file knows.
/// It sits under `core/` for want of a better home, but counting it as `core`
/// would hand `infrastructure` the domain's `Failure` along with it.
const Set<String> kernel = <String>{'core/either/either.dart'};

/// The package's own import prefix, which is how a file names another layer.
const String selfPackage = 'package:flutter_clean_arch_riverpod/';

void main() {
  group('the layer graph', () {
    test('no file imports a layer its own layer may not see', () {
      final List<String> breaks = <String>[];

      for (final _Source source in _sources()) {
        for (final String imported in source.importedLayers) {
          if (source.mayImport(imported)) {
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
            'is composition wiring and belongs in a *_di.dart.\n'
            '${breaks.join('\n')}',
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
            'declared: add it to the graph, or move it into one.\n'
            '${unknown.join('\n')}',
      );
    });
  });

  group('framework independence', () {
    test('the layers below presentation do not import Flutter', () {
      final List<String> breaks = <String>[];

      for (final _Source source in _sources()) {
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
            'run without a widget binding.\n${breaks.join('\n')}',
      );
    });
  });

  group('infrastructure stays behind its contracts', () {
    test('nothing outside infrastructure imports a wrapped package', () {
      final List<String> breaks = <String>[];

      for (final _Source source in _sources()) {
        if (source.layer == 'infrastructure') {
          continue;
        }
        if (wrappedPackageExceptions.contains(source.path)) {
          continue;
        }
        for (final String import in source.imports) {
          if (!wrappedPackages.any(import.startsWith)) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Dio and SharedPreferences are reached through '
            'HttpClientInterface and StorageInterface, so that swapping one '
            'is an edit inside lib/infrastructure rather than across the '
            'repository.\n${breaks.join('\n')}',
      );
    });

    test('every tolerated leak in the list is still there', () {
      for (final String path in wrappedPackageExceptions) {
        expect(
          File(path).existsSync(),
          isTrue,
          reason:
              '$path is listed as a tolerated leak but no longer exists. '
              'Remove it from wrappedPackageExceptions — a list of '
              'exceptions that outlives the exceptions stops being read.',
        );
      }
    });
  });
}

/// One source file under `lib/`, with its import lines read out of it.
class _Source {
  _Source(this.path, this.imports);

  /// Repository-relative, with forward slashes: `lib/domain/entities/x.dart`.
  final String path;

  /// Every `package:` URI the file imports, in the order they appear.
  final List<String> imports;

  /// Which layer the file belongs to, or an empty string for `lib/main.dart`.
  String get layer {
    final List<String> parts = path.split('/');
    return parts.length > 2 && layers.contains(parts[1]) ? parts[1] : '';
  }

  /// Whether this file is composition wiring.
  bool get isWiring => path.endsWith(wiringSuffix);

  /// The layers of this package that the file imports, each once.
  Set<String> get importedLayers => <String>{
    for (final String import in imports)
      if (import.startsWith(selfPackage) &&
          !kernel.contains(import.substring(selfPackage.length)))
        import.substring(selfPackage.length).split('/').first,
  }..removeWhere((String imported) => !layers.contains(imported));

  /// Whether this file may import [imported].
  bool mayImport(String imported) {
    if (imported == layer) {
      return true;
    }
    if (allowed[layer]?.contains(imported) ?? false) {
      return true;
    }
    if (isWiring && (wiringReach[layer]?.contains(imported) ?? false)) {
      return true;
    }
    return wiringExceptions[path]?.contains(imported) ?? false;
  }
}

/// Every hand-written source file under `lib/`.
///
/// `lib/main.dart` is skipped: it is the composition root, its whole job is
/// to know every layer at once, and a graph that made an exception for it
/// would be a graph with a hole in the middle rather than one with a root.
///
/// Generated files are skipped for a different reason: nobody chose their
/// imports, so a boundary crossed there is a bug to report to the generator's
/// configuration rather than to the author.
List<_Source> _sources() {
  final List<_Source> sources = <_Source>[];

  for (final FileSystemEntity entity in Directory(
    'lib',
  ).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    final String path = entity.path.replaceAll(r'\', '/');
    if (path == 'lib/main.dart') {
      continue;
    }
    if (_generated.any(path.endsWith)) {
      continue;
    }

    sources.add(_Source(path, _importsIn(entity)));
  }

  return sources;
}

/// The `package:` URIs [file] imports.
///
/// Matched on the line rather than parsed, because an import is the one Dart
/// construct that has to be on its own line and cannot be built at runtime.
List<String> _importsIn(File file) => <String>[
  for (final String line in file.readAsLinesSync())
    if (_import.firstMatch(line) case final RegExpMatch match) match.group(1)!,
];

final RegExp _import = RegExp(r'''^\s*import\s+['"](package:[^'"]+)['"]''');

/// The suffixes a generator owns. The same four `arch codegen hard` deletes.
const List<String> _generated = <String>[
  '.freezed.dart',
  '.g.dart',
  '.gr.dart',
  '.config.dart',
];

String _name(String path) => path.replaceAll(r'\', '/').split('/').last;
