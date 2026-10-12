// A use case is one operation.
//
// `result_pattern` already says a use case is invoked through `call` and
// answers with an `Either`. This says the other half: `call` is the only
// thing it offers. A second public method makes the class a service — a bag
// of related operations — and then the name on the folder stops telling you
// what it does, because it does several things.
//
// The cost of keeping it to one is a file per operation, which is also the
// benefit: `ToggleFavoriteUseCase` is findable by the name of the thing it
// does, and the screen that needs it names it and nothing else.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The suffix that marks a class as a use case.
const String useCaseSuffix = '_usecase';

/// The method a use case is invoked through.
const String invocation = 'call';

void main() {
  group('a use case does one thing', () {
    test('there are use cases to check', () {
      expect(
        _useCases(),
        isNotEmpty,
        reason: 'No *$useCaseSuffix.dart under lib/ — the rule guards nothing.',
      );
    });

    test('each one offers nothing but call', () {
      final List<String> breaks = <String>[];

      for (final Source source in _useCases()) {
        final List<String> offered = <String>[
          for (final String line in source.codeLines)
            if (_method.firstMatch(line) case final RegExpMatch match)
              match.group(1)!,
        ];

        final Iterable<String> extra = offered.where(
          (final String name) => name != invocation,
        );
        if (extra.isEmpty) {
          continue;
        }
        breaks.add('${source.path} also offers ${extra.join(', ')}');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Give the second operation its own use case. Two in one class is '
            'a service, and the folder stops naming what it does.',
      );
    });
  });
}

/// Every use case under `lib/`, wiring left out.
List<Source> _useCases() => <Source>[
  for (final Source source in libSources())
    if (source.name.endsWith(useCaseSuffix) && !source.isWiring) source,
];

/// A public method declaration at the class's own indentation.
///
/// The return type is capitalised and the name is not, which is what tells a
/// method from the constructor beside it.
final RegExp _method = RegExp(r'^  [A-Z][\w<>, ?]*\s+([a-z_]\w*)\s*\(');
