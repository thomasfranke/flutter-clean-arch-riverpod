import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesDatasource extends Mock implements FavoritesDatasource {}

void main() {
  group('FavoritesRepositoryImpl', () {
    late _MockFavoritesDatasource datasource;
    late FavoritesRepositoryImpl sut;

    setUp(() {
      datasource = _MockFavoritesDatasource();
      sut = FavoritesRepositoryImpl(datasource: datasource);
    });

    test('should convert list of strings into FavoriteEntity', () async {
      when(() => datasource.getFavorites()).thenReturn(
        const Right<StorageFailure, List<String>>(<String>[
          'BTCUSDT',
          'ETHUSDT',
        ]),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .getFavorites();

      expect(result.isRight(), isTrue);
      final List<FavoriteEntity> entities = result.getOrElse(
        () => <FavoriteEntity>[],
      );
      expect(entities, hasLength(2));
      expect(entities[0].symbol, 'BTCUSDT');
      expect(entities[1].symbol, 'ETHUSDT');
    });

    test('should return an empty list when there are no favorites', () async {
      when(
        () => datasource.getFavorites(),
      ).thenReturn(const Right<StorageFailure, List<String>>(<String>[]));

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .getFavorites();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => <FavoriteEntity>[]), isEmpty);
    });

    test('should translate a read failure from getFavorites', () async {
      when(() => datasource.getFavorites()).thenReturn(
        const Left<StorageFailure, List<String>>(StorageFailure.read()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .getFavorites();

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });

    test('should convert the addFavorite result into FavoriteEntity', () async {
      when(() => datasource.addFavorite('BTCUSDT')).thenAnswer(
        (_) async =>
            const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .addFavorite('BTCUSDT');

      expect(result.isRight(), isTrue);
      final List<FavoriteEntity> entities = result.getOrElse(
        () => <FavoriteEntity>[],
      );
      expect(entities, hasLength(1));
      expect(entities[0].symbol, 'BTCUSDT');
    });

    test('should translate a write failure from addFavorite', () async {
      when(() => datasource.addFavorite(any())).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .addFavorite('BTCUSDT');

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });

    test(
      'should convert the removeFavorite result into FavoriteEntity',
      () async {
        when(() => datasource.removeFavorite('BTCUSDT')).thenAnswer(
          (_) async =>
              const Right<StorageFailure, List<String>>(<String>['ETHUSDT']),
        );

        final Either<Failure, List<FavoriteEntity>> result = await sut
            .removeFavorite('BTCUSDT');

        expect(result.isRight(), isTrue);
        final List<FavoriteEntity> entities = result.getOrElse(
          () => <FavoriteEntity>[],
        );
        expect(entities, hasLength(1));
        expect(entities[0].symbol, 'ETHUSDT');
      },
    );

    test('should translate a write failure from removeFavorite', () async {
      when(() => datasource.removeFavorite(any())).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .removeFavorite('BTCUSDT');

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });

    test(
      'should convert the toggleFavorite result into FavoriteEntity',
      () async {
        when(() => datasource.toggleFavorite('BTCUSDT')).thenAnswer(
          (_) async =>
              const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
        );

        final Either<Failure, List<FavoriteEntity>> result = await sut
            .toggleFavorite('BTCUSDT');

        expect(result.isRight(), isTrue);
        final List<FavoriteEntity> entities = result.getOrElse(
          () => <FavoriteEntity>[],
        );
        expect(entities, hasLength(1));
        expect(entities[0].symbol, 'BTCUSDT');
      },
    );

    test('should translate a write failure from toggleFavorite', () async {
      when(() => datasource.toggleFavorite(any())).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .toggleFavorite('BTCUSDT');

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });
  });
}
