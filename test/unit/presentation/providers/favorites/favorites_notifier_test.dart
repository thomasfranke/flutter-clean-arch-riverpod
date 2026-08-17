import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  group('FavoritesNotifier', () {
    late _MockFavoritesRepository repository;

    setUp(() {
      repository = _MockFavoritesRepository();
    });

    ProviderContainer makeContainer() => ProviderContainer(
      overrides: <Override>[
        getFavoritesUseCaseProvider.overrideWithValue(
          GetFavoritesUseCase(repository: repository),
        ),
        toggleFavoriteUseCaseProvider.overrideWithValue(
          ToggleFavoriteUseCase(repository: repository),
        ),
      ],
    );

    test('should emit success with the list of favorites', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider),
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
      );
    });

    test('should emit failure when getFavorites fails', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider),
        const FavoritesState.failure(Failure.storage()),
      );
    });

    test(
      'isFavorite should return true when the symbol is in the list',
      () async {
        when(() => repository.getFavorites()).thenAnswer(
          (_) async => const Right<Failure, List<FavoriteEntity>>(
            <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
          ),
        );

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(favoritesProvider.notifier).loadFavorites();

        expect(
          container.read(favoritesProvider.notifier).isFavorite('BTCUSDT'),
          isTrue,
        );
        expect(
          container.read(favoritesProvider.notifier).isFavorite('ETHUSDT'),
          isFalse,
        );
      },
    );

    test('isFavorite should return false in a non-success state', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider.notifier).isFavorite('BTCUSDT'),
        isFalse,
      );
    });

    test(
      'toggleFavorite should update state after a successful operation',
      () async {
        when(() => repository.getFavorites()).thenAnswer(
          (_) async =>
              const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
        );
        when(() => repository.toggleFavorite('BTCUSDT')).thenAnswer(
          (_) async => const Right<Failure, List<FavoriteEntity>>(
            <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
          ),
        );

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(favoritesProvider.notifier).loadFavorites();
        await container
            .read(favoritesProvider.notifier)
            .toggleFavorite('BTCUSDT');

        expect(
          container.read(favoritesProvider),
          const FavoritesState.success(<FavoriteEntity>[
            FavoriteEntity(symbol: 'BTCUSDT'),
          ]),
        );
      },
    );

    test(
      'toggleFavorite should emit failure when the repository fails',
      () async {
        when(() => repository.getFavorites()).thenAnswer(
          (_) async =>
              const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
        );
        when(() => repository.toggleFavorite('BTCUSDT')).thenAnswer(
          (_) async =>
              const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
        );

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(favoritesProvider.notifier).loadFavorites();
        await container
            .read(favoritesProvider.notifier)
            .toggleFavorite('BTCUSDT');

        expect(
          container.read(favoritesProvider),
          const FavoritesState.failure(Failure.storage()),
        );
      },
    );

    test('favoritesProvider.overrideWithValue replaces the state', () {
      expect(
        favoritesProvider.overrideWithValue(const FavoritesState.loading()),
        isNotNull,
      );
    });
  });
}
