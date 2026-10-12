// A screen reads state, so it is a consumer.
//
// Every screen in this app draws from a notifier: the four cases of a
// `*_state.dart`, watched. A `StatelessWidget` cannot watch — it has no
// `ref` — so a screen written as one either takes its data as a constructor
// argument from whoever built it, or reaches for state some other way.
//
// The first is the real risk: it compiles, it draws, and the screen is now
// reachable only from the one place that happens to hold the data. A route
// cannot push it, because a route has no data to give.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// What marks a file as a screen.
const String screenSuffix = '_screen';

/// The widget classes that can watch a provider.
const List<String> consumerBases = <String>[
  'ConsumerWidget',
  'ConsumerStatefulWidget',
];

void main() {
  group('a screen can read state', () {
    test('there are screens to check', () {
      expect(
        _screens(),
        isNotEmpty,
        reason: 'No *$screenSuffix.dart under lib/ — nothing to check.',
      );
    });

    test('each one is a consumer', () {
      final List<String> breaks = <String>[];

      for (final Source source in _screens()) {
        final String? declared = source.declaredType;
        final bool consumes = source.codeLines.any(
          (final String line) =>
              line.contains('class $declared') &&
              consumerBases.any(
                (final String base) => line.contains('extends $base'),
              ),
        );
        if (consumes) {
          continue;
        }
        breaks.add('${source.path}: $declared cannot watch a provider');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Make it a ConsumerWidget. A screen that takes its data as a '
            'constructor argument can only be reached from whoever holds the '
            'data, which is not what a route can do.',
      );
    });
  });
}

/// Every screen under `lib/`.
List<Source> _screens() => <Source>[
  for (final Source source in libSources())
    if (source.name.endsWith(screenSuffix) && !source.isWiring) source,
];
