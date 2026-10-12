// Presentation reaches the domain through a use case, and nothing else.
//
// The layer graph already stops a screen importing `data/`. It does not stop
// one importing `domain/repositories/` and calling the repository straight —
// which compiles, which works, and which quietly moves the operation into
// the widget that happens to need it first. The next screen that needs the
// same thing either calls it again with its own arguments or finds the use
// case that should have existed all along.
//
// So the contract a repository offers is the application layer's to call: a
// use case is the one name an operation has, and `presentation/` knows it by
// that name or not at all.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The layer that may only ask through a use case.
const String askingLayer = 'presentation';

/// The folder holding the contracts a use case calls, and a screen does not.
const String contractFolder = 'domain/repositories/';

/// Where the use cases live.
const String useCaseFolder = 'application/';

/// The suffix of a file holding the state of one feature.
const String notifierSuffix = '_notifier';

/// Notifiers that call no use case, and why.
///
/// Empty. A notifier holding nothing but view state — a selected tab, a
/// scroll offset — would be the reason to want an entry here, and this
/// repository has none: every one of its four notifiers runs an operation.
const Set<String> stateOnlyNotifiers = <String>{};

void main() {
  group('presentation asks through a use case', () {
    test('nothing in presentation names a repository contract', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != askingLayer) {
          continue;
        }
        // Composition wiring knows both sides by definition — that is what
        // the layer graph already says about a *_di.dart.
        if (source.isWiring) {
          continue;
        }
        for (final String import in source.imports) {
          if (!import.startsWith('$selfPackage$contractFolder')) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A repository contract is called by a use case, which is the one '
            'name the operation has. Reached from a screen it becomes that '
            'screen\'s private arrangement, and the next screen needing it '
            'writes its own.',
      );
    });

    test('every notifier calls at least one use case', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != askingLayer || source.isWiring) {
          continue;
        }
        if (!source.name.endsWith(notifierSuffix)) {
          continue;
        }
        if (stateOnlyNotifiers.contains(source.path)) {
          continue;
        }
        final bool asks = source.imports.any(
          (final String import) =>
              import.startsWith('$selfPackage$useCaseFolder'),
        );
        if (asks) {
          continue;
        }
        breaks.add(source.path);
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A notifier is where an operation is run and its result becomes '
            'state. One that calls no use case is either holding view state '
            '— and belongs in stateOnlyNotifiers, with that written down — '
            'or is reaching for the domain some other way.',
      );
    });
  });
}
