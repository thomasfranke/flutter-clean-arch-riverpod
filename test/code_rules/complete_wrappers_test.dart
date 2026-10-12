// Every wrapper under `infrastructure/` is a complete one.
//
// A wrapper is three files: the contract the layers above call, the failure
// it answers with, and the implementation that holds the package. Miss the
// failure and the exception escapes as an exception; miss the contract and
// the package's types cross the boundary; miss the implementation and there
// is nothing to swap.
//
// The point is the next wrapper rather than the two that exist. Whoever adds
// `secure_storage/` learns here, not in review, that it has no failure type.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The layer whose folders are each one wrapper.
const String wrapperLayer = 'lib/infrastructure';

/// What the contract a wrapper offers upwards is called.
const String contractSuffix = '_interface.dart';

/// What the failure a wrapper answers with is called.
const String failureSuffix = '_failure.dart';

/// What an implementation of a contract is called.
const String implementationSuffix = '_impl.dart';

/// Folders under [wrapperLayer] that are not wrappers.
///
/// `models/` holds the value types a contract speaks in — a route, a
/// response, a method — which belong to the wrapper above them rather than
/// being one. It is named here because the alternative is a rule that cannot
/// tell a wrapper from a folder of plain data.
const Set<String> notWrappers = <String>{'models'};

void main() {
  group('every infrastructure wrapper is complete', () {
    test('there is at least one, or this rule guards nothing', () {
      expect(
        _wrappers(),
        isNotEmpty,
        reason: 'No wrapper folders under $wrapperLayer.',
      );
    });

    test('each one declares a contract, a failure and an implementation', () {
      final List<String> breaks = <String>[];

      for (final String wrapper in _wrappers()) {
        final List<Source> held = _sourcesOf(wrapper);
        final String name = wrapper.split('/').last;
        final Set<String> paths = <String>{
          for (final Source source in held) source.path,
        };

        if (!paths.contains('$wrapper/$name$contractSuffix')) {
          breaks.add('$wrapper has no $name$contractSuffix');
        }
        if (!paths.contains('$wrapper/$name$failureSuffix')) {
          breaks.add('$wrapper has no $name$failureSuffix');
        }
        if (!paths.any((final String p) => p.endsWith(implementationSuffix))) {
          breaks.add('$wrapper has no *$implementationSuffix');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A wrapper is a contract, a failure and an implementation. '
            'Whichever of the three is missing, something the layers above '
            'rely on is being provided by accident.',
      );
    });

    test('neither the contract nor the failure names the package', () {
      final List<String> breaks = <String>[];

      for (final String wrapper in _wrappers()) {
        final List<Source> held = _sourcesOf(wrapper);

        for (final Source source in held) {
          if (!_crossesUpwards(source)) {
            continue;
          }
          final String? named = _wrappedPackageIn(source);
          if (named == null) {
            continue;
          }
          breaks.add('${source.path} names $named');
        }

        if (held.every((final Source s) => _wrappedPackageIn(s) == null)) {
          breaks.add(
            '$wrapper wraps nothing: no file in it names a package in '
            'wrappedPackages',
          );
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'The contract and the failure are what the layers above hold, so '
            'the package has to stop below them. The files between — the '
            'implementation and whatever it is built from — may name it '
            'freely; that is what the folder is for.',
      );
    });
  });
}

/// Whether [source] is one of the two files a wrapper hands upwards.
///
/// The implementation and its parts are not: `dio_interceptor_retry.dart`
/// extends Dio's own `Interceptor`, which is exactly the kind of thing a
/// folder named after a package is allowed to do.
bool _crossesUpwards(final Source source) =>
    source.path.endsWith(contractSuffix) || source.path.endsWith(failureSuffix);

/// The wrapped package [source] imports, if it imports one.
String? _wrappedPackageIn(final Source source) {
  for (final String import in source.imports) {
    for (final String wrapped in wrappedPackages) {
      if (import.startsWith(wrapped)) {
        return wrapped;
      }
    }
  }
  return null;
}

/// The wrapper folders: every direct child of [wrapperLayer] that is one.
List<String> _wrappers() => <String>[
  for (final FileSystemEntity entity in Directory(wrapperLayer).listSync())
    if (entity is Directory &&
        !notWrappers.contains(
          entity.path.replaceAll(r'\', '/').split('/').last,
        ))
      entity.path.replaceAll(r'\', '/'),
];

/// Every source under [wrapper], at any depth.
List<Source> _sourcesOf(final String wrapper) => <Source>[
  for (final Source source in libSources())
    if (source.path.startsWith('$wrapper/')) source,
];
