// A feature's Riverpod wiring is three things, or it is broken.
//
// Each folder under `presentation/providers/` is one feature, and holds the
// same three: the state it publishes, the notifier that produces it, and the
// provider `riverpod_generator` writes from the notifier's annotation. Miss
// the state and the notifier publishes something nobody can switch over;
// miss the annotation and the provider is never generated, so the notifier
// compiles and is unreachable.
//
// The four cases are part of the shape, not a detail of it: every screen in
// this app is a `switch` over `initial`, `loading`, `success`, `failure`, and
// a state missing one is a screen with a branch it cannot write.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where one folder is one feature.
const String providerFolder = 'lib/presentation/providers';

/// What the notifier of a feature is called.
const String notifierSuffix = '_notifier';

/// What the state of a feature is called.
const String stateSuffix = '_state';

/// The annotation that makes `riverpod_generator` write the provider.
const String annotation = '@riverpod';

/// The cases every feature state declares, in the order a screen reads them.
///
/// `initial` before anything is asked, `loading` while it is in flight, then
/// one of the two answers. A state missing one of these is a screen with an
/// unwritable branch — or, worse, a `switch` that silently falls through.
const List<String> stateCases = <String>[
  'initial',
  'loading',
  'success',
  'failure',
];

void main() {
  group('every feature has a state, a notifier and a provider', () {
    test('there are features to check', () {
      expect(
        _features(),
        isNotEmpty,
        reason: 'No feature folders under $providerFolder.',
      );
    });

    test(
      'each feature holds one notifier and one state, both named for it',
      () {
        final List<String> breaks = <String>[];

        for (final String feature in _features()) {
          final String name = feature.split('/').last;
          final Set<String> held = <String>{
            for (final Source source in _sourcesOf(feature)) source.name,
          };

          for (final String suffix in <String>[notifierSuffix, stateSuffix]) {
            if (held.contains('$name$suffix')) {
              continue;
            }
            final Iterable<String> wrongly = held.where(
              (final String each) => each.endsWith(suffix),
            );
            breaks.add(
              wrongly.isEmpty
                  ? '$feature has no $name$suffix.dart'
                  : '$feature holds ${wrongly.join(', ')} '
                        'where the folder asks for $name$suffix',
            );
          }
        }

        expect(
          breaks,
          isEmpty,
          reason:
              'A feature is a folder, and the files in it are named after it. '
              'One spelling for the folder and another for its files is two '
              'names for one feature.',
        );
      },
    );

    test('every notifier is annotated, generated and extends its own base', () {
      final List<String> breaks = <String>[];

      for (final Source source in _notifiers()) {
        final String declared = source.declaredType ?? '';
        final String text = source.codeLines.join('\n');

        if (!text.contains(annotation)) {
          breaks.add(
            '${source.path} is not $annotation, so no provider '
            'is generated for it',
          );
        }
        if (!text.contains('extends _\$$declared')) {
          breaks.add('${source.path} does not extend _\$$declared');
        }
        if (!text.contains("part '${source.name}.g.dart';")) {
          breaks.add(
            '${source.path} declares no part for its generated '
            'provider',
          );
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'The annotation, the part directive and the generated base class '
            'are one mechanism: any of the three missing and the provider '
            'either is not written or is not reachable.',
      );
    });

    test('every notifier builds the state its feature declares', () {
      final List<String> breaks = <String>[];

      for (final Source source in _notifiers()) {
        final String expected = _stateTypeOf(source);
        final bool builds = source.codeLines.any(
          (final String line) => line.contains('$expected build('),
        );
        if (builds) {
          continue;
        }
        breaks.add('${source.path} does not build a $expected');
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A notifier publishes the state beside it. Building anything '
            'else leaves that state declared and unused, and the screens '
            'reading something the folder does not describe.',
      );
    });

    test('every state declares the same four cases', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (!source.path.startsWith('$providerFolder/') ||
            !source.name.endsWith(stateSuffix)) {
          continue;
        }
        final String declared = source.declaredType ?? '';
        final String text = source.codeLines.join('\n');

        if (!text.contains('@freezed')) {
          breaks.add('${source.path} is not @freezed');
        }
        for (final String each in stateCases) {
          if (text.contains('$declared.$each(')) {
            continue;
          }
          breaks.add('${source.path} declares no $declared.$each()');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Every screen in this app is a switch over the four. A state '
            'missing one is a branch a screen cannot write.',
      );
    });
  });
}

/// The feature folders: every direct child of [providerFolder].
List<String> _features() => <String>[
  for (final FileSystemEntity entity in Directory(providerFolder).listSync())
    if (entity is Directory) entity.path.replaceAll(r'\', '/'),
];

/// Every source under [feature].
List<Source> _sourcesOf(final String feature) => <Source>[
  for (final Source source in libSources())
    if (source.path.startsWith('$feature/')) source,
];

/// Every notifier under [providerFolder].
List<Source> _notifiers() => <Source>[
  for (final Source source in libSources())
    if (source.path.startsWith('$providerFolder/') &&
        source.name.endsWith(notifierSuffix))
      source,
];

/// The state type [notifier] is expected to build, from its own name.
String _stateTypeOf(final Source notifier) {
  final String declared = notifier.declaredType ?? '';
  return declared.endsWith('Notifier')
      ? '${declared.substring(0, declared.length - 'Notifier'.length)}State'
      : '${declared}State';
}
