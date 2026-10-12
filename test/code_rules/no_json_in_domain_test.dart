// The domain does not know it is ever serialized.
//
// An entity is the shape the app reasons in; a DTO is the shape a particular
// endpoint happens to send. Give the entity a `fromJson` and the two become
// one, and then the domain changes whenever the API does — which is the
// dependency the whole arrangement is built to avoid.
//
// It also costs the DTO its job. `CryptoQuoteDTO.toEntity()` returns `null`
// for a row it cannot read, and the repository drops it and counts it; an
// entity parsing itself has nowhere to put that decision.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The layer that reasons, and never parses.
const String reasoningLayer = 'domain';

/// The names serialization is written with.
const List<String> serialization = <String>[
  'fromJson',
  'toJson',
  'JsonSerializable',
  'JsonKey',
];

/// The package that writes it.
const String serializationPackage = 'package:json_annotation/';

void main() {
  group('the domain is not serialized', () {
    test('no entity or contract names a JSON conversion', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != reasoningLayer) {
          continue;
        }
        for (final String name in serialization) {
          if (!source.codeLines.any(
            (final String line) => line.contains(name),
          )) {
            continue;
          }
          breaks.add('${source.path} names $name');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Parsing belongs to a DTO in data/data_objects, which is also '
            'where a row that cannot be read becomes null instead of an '
            'entity full of zeros.',
      );
    });

    test('the domain does not depend on a serialization package', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != reasoningLayer) {
          continue;
        }
        for (final String import in source.imports) {
          if (!import.startsWith(serializationPackage)) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'The annotation would arrive before the method does. A domain '
            'that depends on how it is encoded is a domain with a wire '
            'format in it.',
      );
    });
  });
}
