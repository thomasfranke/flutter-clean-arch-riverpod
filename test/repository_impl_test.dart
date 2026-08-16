import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesDatasource extends Mock implements FavoritesDatasource {}

class _MockPreferencesDatasource extends Mock
    implements PreferencesDatasource {}

void main() {
  group('FavoritesRepositoryImpl', () {
    late _MockFavoritesDatasource datasource;
    late FavoritesRepositoryImpl sut;

    setUp(() {
      datasource = _MockFavoritesDatasource();
      sut = FavoritesRepositoryImpl(datasource: datasource);
    });

    test('deve converter lista de strings para FavoriteEntity', () async {
      when(() => datasource.getFavorites()).thenReturn(
        const Right<Failure, List<String>>(<String>['BTCUSDT', 'ETHUSDT']),
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

    test('deve retornar lista vazia quando não há favoritos', () async {
      when(
        () => datasource.getFavorites(),
      ).thenReturn(const Right<Failure, List<String>>(<String>[]));

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .getFavorites();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => <FavoriteEntity>[]), isEmpty);
    });

    test('deve propagar Failure de getFavorites', () async {
      when(
        () => datasource.getFavorites(),
      ).thenReturn(const Left<Failure, List<String>>(Failure.storage()));

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .getFavorites();

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });

    test(
      'deve converter resultado de addFavorite para FavoriteEntity',
      () async {
        when(() => datasource.addFavorite('BTCUSDT')).thenAnswer(
          (_) async => const Right<Failure, List<String>>(<String>['BTCUSDT']),
        );

        final Either<Failure, List<FavoriteEntity>> result = await sut
            .addFavorite('BTCUSDT');

        expect(result.isRight(), isTrue);
        final List<FavoriteEntity> entities = result.getOrElse(
          () => <FavoriteEntity>[],
        );
        expect(entities, hasLength(1));
        expect(entities[0].symbol, 'BTCUSDT');
      },
    );

    test('deve propagar Failure de addFavorite', () async {
      when(() => datasource.addFavorite(any())).thenAnswer(
        (_) async => const Left<Failure, List<String>>(Failure.storage()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut
          .addFavorite('BTCUSDT');

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });

    test(
      'deve converter resultado de removeFavorite para FavoriteEntity',
      () async {
        when(() => datasource.removeFavorite('BTCUSDT')).thenAnswer(
          (_) async => const Right<Failure, List<String>>(<String>['ETHUSDT']),
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
  });

  group('PreferencesRepositoryImpl', () {
    late _MockPreferencesDatasource datasource;
    late PreferencesRepositoryImpl sut;

    final PreferencesEntity tPreferences = PreferencesEntity.defaults();
    final PreferencesDAO tDAO = PreferencesDAO(
      locale: tPreferences.locale,
      darkMode: tPreferences.darkMode,
      fontScale: tPreferences.fontScale,
    );

    setUp(() {
      datasource = _MockPreferencesDatasource();
      sut = PreferencesRepositoryImpl(datasource: datasource);
      registerFallbackValue(tDAO);
    });

    test('deve converter DAO para PreferencesEntity', () async {
      when(
        () => datasource.getPreferences(),
      ).thenReturn(Right<Failure, PreferencesDAO>(tDAO));

      final Either<Failure, PreferencesEntity> result = await sut
          .getPreferences();

      expect(result, Right<Failure, PreferencesEntity>(tPreferences));
    });

    test('deve propagar Failure de getPreferences', () async {
      when(
        () => datasource.getPreferences(),
      ).thenReturn(const Left<Failure, PreferencesDAO>(Failure.storage()));

      final Either<Failure, PreferencesEntity> result = await sut
          .getPreferences();

      expect(result, const Left<Failure, PreferencesEntity>(Failure.storage()));
    });

    test('deve converter PreferencesEntity para DAO ao salvar', () async {
      when(
        () => datasource.savePreferences(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      await sut.savePreferences(tPreferences);

      final PreferencesDAO captured =
          verify(() => datasource.savePreferences(captureAny())).captured.first
              as PreferencesDAO;

      expect(captured.locale, tPreferences.locale);
      expect(captured.darkMode, tPreferences.darkMode);
      expect(captured.fontScale, tPreferences.fontScale);
    });

    test('deve propagar Failure de savePreferences', () async {
      when(
        () => datasource.savePreferences(any()),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final Either<Failure, Unit> result = await sut.savePreferences(
        tPreferences,
      );

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
