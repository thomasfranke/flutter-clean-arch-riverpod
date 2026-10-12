// Nothing under `lib/` re-publishes anything.
//
// A blind spot in the layer graph, closed before anyone finds it. That rule
// reads `import` lines, because an import is how a file names another layer.
// An `export` names one too, and launders it: a barrel file in `core/` that
// exported `presentation/` would let every layer reach the screens, through
// an import of `core` the graph reads as allowed.
//
// So no exports, which costs this repository nothing — it has never had one.
// A file is imported by its own path, which is also what keeps the graph
// readable: the import line says which layer, and there is no indirection
// between the two.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

void main() {
  group('no file re-publishes another', () {
    test('nothing under lib exports', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        for (final String line in source.codeLines) {
          if (!_export.hasMatch(line)) {
            continue;
          }
          breaks.add('${source.path}: ${line.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'An export is an import the layer graph cannot see: it reads '
            'import lines, so a layer reached through a re-export is a '
            'boundary crossed with nothing to catch it. Import the file by '
            'its own path.',
      );
    });
  });
}

final RegExp _export = RegExp(r'''^\s*export\s+['"]''');
