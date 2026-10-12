import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/entity_list.dart';
import 'package:flutter_test/flutter_test.dart';

/// Converts the strings that are numbers, refuses the rest.
int? _parse(final String raw) => int.tryParse(raw);

void main() {
  group('toEntities', () {
    test('keeps every row that converts', () {
      expect(
        toEntities(<String>['1', '2'], _parse, source: 'test'),
        isA<Right<Failure, List<int>>>().having(
          (final Right<Failure, List<int>> r) => r.getOrElse(() => <int>[]),
          'value',
          <int>[1, 2],
        ),
      );
    });

    test('drops the rows that do not convert, keeping the rest', () {
      final Either<Failure, List<int>> result = toEntities(
        <String>['1', 'x', '3'],
        _parse,
        source: 'test',
      );

      expect(result.getOrElse(() => <int>[]), <int>[1, 3]);
    });

    test('is Failure.parse when rows arrived and none converted', () {
      expect(
        toEntities(<String>['x', 'y'], _parse, source: 'test'),
        const Left<Failure, List<int>>(Failure.parse()),
      );
    });

    test('is an empty list, not a failure, when no rows arrived', () {
      expect(
        toEntities(
          <String>[],
          _parse,
          source: 'test',
        ).getOrElse(() => <int>[-1]),
        isEmpty,
      );
    });
  });

  group('toEntity', () {
    test('is the entity when the row converts', () {
      expect(toEntity('7', _parse), const Right<Failure, int>(7));
    });

    test('is Failure.parse when the row does not convert', () {
      expect(toEntity('x', _parse), const Left<Failure, int>(Failure.parse()));
    });
  });
}
