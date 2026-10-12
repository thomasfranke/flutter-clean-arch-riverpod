import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements StorageInterface {}

void main() {
  late _MockStorage storage;
  late FavoritesDatasource sut;

  setUp(() {
    storage = _MockStorage();
    sut = FavoritesDatasource(storage: storage);
  });

  group('getFavorites', () {
    test('should return the list of symbols from the "favorites" key', () {
      when(() => storage.getList(key: 'favorites')).thenReturn(
        const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
      );

      final Either<StorageFailure, List<String>> result = sut.getFavorites();

      expect(
        result,
        const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
      );
    });

    test('should hand the StorageFailure back untranslated', () {
      when(() => storage.getList(key: 'favorites')).thenReturn(
        const Left<StorageFailure, List<String>>(StorageFailure.read()),
      );

      final Either<StorageFailure, List<String>> result = sut.getFavorites();

      expect(
        result,
        const Left<StorageFailure, List<String>>(StorageFailure.read()),
      );
    });
  });

  group('addFavorite', () {
    test(
      'should delegate to storage.addToList with the "favorites" key',
      () async {
        when(
          () => storage.addToList(key: 'favorites', value: 'BTCUSDT'),
        ).thenAnswer(
          (_) async =>
              const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
        );

        final Either<StorageFailure, List<String>> result = await sut
            .addFavorite('BTCUSDT');

        expect(
          result,
          const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
        );
        verify(
          () => storage.addToList(key: 'favorites', value: 'BTCUSDT'),
        ).called(1);
      },
    );

    test('should hand the StorageFailure back untranslated', () async {
      when(
        () => storage.addToList(key: 'favorites', value: 'BTCUSDT'),
      ).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<StorageFailure, List<String>> result = await sut.addFavorite(
        'BTCUSDT',
      );

      expect(
        result,
        const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );
    });
  });

  group('removeFavorite', () {
    test(
      'should delegate to storage.removeFromList with the "favorites" key',
      () async {
        when(
          () => storage.removeFromList(key: 'favorites', value: 'BTCUSDT'),
        ).thenAnswer(
          (_) async => const Right<StorageFailure, List<String>>(<String>[]),
        );

        final Either<StorageFailure, List<String>> result = await sut
            .removeFavorite('BTCUSDT');

        expect(result, const Right<StorageFailure, List<String>>(<String>[]));
        verify(
          () => storage.removeFromList(key: 'favorites', value: 'BTCUSDT'),
        ).called(1);
      },
    );

    test('should hand the StorageFailure back untranslated', () async {
      when(
        () => storage.removeFromList(key: 'favorites', value: 'BTCUSDT'),
      ).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<StorageFailure, List<String>> result = await sut
          .removeFavorite('BTCUSDT');

      expect(
        result,
        const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );
    });
  });

  group('toggleFavorite', () {
    test(
      'should delegate to storage.toggleInList with the "favorites" key',
      () async {
        when(
          () => storage.toggleInList(key: 'favorites', value: 'BTCUSDT'),
        ).thenAnswer(
          (_) async =>
              const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
        );

        final Either<StorageFailure, List<String>> result = await sut
            .toggleFavorite('BTCUSDT');

        expect(
          result,
          const Right<StorageFailure, List<String>>(<String>['BTCUSDT']),
        );
        verify(
          () => storage.toggleInList(key: 'favorites', value: 'BTCUSDT'),
        ).called(1);
      },
    );

    test('should hand the StorageFailure back untranslated', () async {
      when(
        () => storage.toggleInList(key: 'favorites', value: 'BTCUSDT'),
      ).thenAnswer(
        (_) async =>
            const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );

      final Either<StorageFailure, List<String>> result = await sut
          .toggleFavorite('BTCUSDT');

      expect(
        result,
        const Left<StorageFailure, List<String>>(StorageFailure.write()),
      );
    });
  });
}
