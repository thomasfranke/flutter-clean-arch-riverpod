import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The real favorites chain, wired the same way `favorites_di.dart` wires
/// it in the app.
typedef _FavoritesStack = ({
  ToggleFavoriteUseCase toggleFavorite,
  GetFavoritesUseCase getFavorites,
});

/// Builds the real favorites chain (use case -> repository -> datasource ->
/// SharedPreferencesImpl) on top of the shared_preferences plugin's own
/// mock platform channel. Only the platform channel is faked; every class
/// in `lib/` between it and the use cases is the real implementation.
Future<_FavoritesStack> _buildStack() async {
  final SharedPreferencesImpl storage = await SharedPreferencesImpl.create();
  final FavoritesDatasource datasource = FavoritesDatasource(storage: storage);
  final FavoritesRepositoryImpl repository = FavoritesRepositoryImpl(
    datasource: datasource,
  );

  return (
    toggleFavorite: ToggleFavoriteUseCase(repository: repository),
    getFavorites: GetFavoritesUseCase(repository: repository),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Favorites integration flow', () {
    test(
      'get_favorites on empty storage returns an empty list, not a Failure',
      () async {
        final _FavoritesStack stack = await _buildStack();

        final Either<Failure, List<FavoriteEntity>> result = await stack
            .getFavorites();

        expect(result.isRight(), isTrue);
        expect(result.getOrElse(() => <FavoriteEntity>[]), isEmpty);
      },
    );

    test('toggle_favorite adds a symbol that is not yet a favorite', () async {
      final _FavoritesStack stack = await _buildStack();

      final Either<Failure, List<FavoriteEntity>> result = await stack
          .toggleFavorite('BTCUSDT');

      expect(
        result
            .getOrElse(() => <FavoriteEntity>[])
            .map((final FavoriteEntity e) => e.symbol),
        contains('BTCUSDT'),
      );
    });

    test(
      'toggle_favorite removes a symbol that is already a favorite',
      () async {
        final _FavoritesStack stack = await _buildStack();

        await stack.toggleFavorite('BTCUSDT');
        final Either<Failure, List<FavoriteEntity>> result = await stack
            .toggleFavorite('BTCUSDT');

        expect(
          result
              .getOrElse(() => <FavoriteEntity>[])
              .map((final FavoriteEntity e) => e.symbol),
          isNot(contains('BTCUSDT')),
        );
      },
    );

    test(
      'toggling one symbol does not disturb other persisted favorites',
      () async {
        final _FavoritesStack stack = await _buildStack();

        await stack.toggleFavorite('BTCUSDT');
        await stack.toggleFavorite('ETHUSDT');
        await stack.toggleFavorite('ETHUSDT');

        final Either<Failure, List<FavoriteEntity>> result = await stack
            .getFavorites();

        final List<String> symbols = result
            .getOrElse(() => <FavoriteEntity>[])
            .map((final FavoriteEntity e) => e.symbol)
            .toList();

        expect(symbols, <String>['BTCUSDT']);
      },
    );

    test(
      'favorites persist across a fresh object graph, proving state lives '
      'in storage rather than in the use case/repository/datasource chain',
      () async {
        final _FavoritesStack stack1 = await _buildStack();
        await stack1.toggleFavorite('BTCUSDT');

        final _FavoritesStack stack2 = await _buildStack();
        final Either<Failure, List<FavoriteEntity>> result = await stack2
            .getFavorites();

        expect(
          result
              .getOrElse(() => <FavoriteEntity>[])
              .map((final FavoriteEntity e) => e.symbol),
          contains('BTCUSDT'),
        );
      },
    );
  });
}
