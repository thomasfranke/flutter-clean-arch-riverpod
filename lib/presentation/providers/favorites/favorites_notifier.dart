import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_notifier.g.dart';

/// Notifier for managing the state of favorite cryptocurrencies.
///
/// Responsible only for loading and toggling favorites from storage.
/// Does not interact with the API — crypto quote data is managed separately
/// by CryptoQuoteNotifier.
@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  FavoritesState build() {
    unawaited(loadFavorites());
    return const FavoritesState.loading();
  }

  /// Loads the list of favorites and updates the state accordingly.
  Future<void> loadFavorites() async {
    state = const FavoritesState.loading();

    final GetFavoritesUseCase useCase = ref.read(getFavoritesUseCaseProvider);
    final Either<Failure, List<FavoriteEntity>> result = await useCase.call();

    state = result.fold(FavoritesState.failure, FavoritesState.success);
  }

  /// Toggles the favorite status of the given [symbol] and updates the state.
  Future<void> toggleFavorite(final String symbol) async {
    final ToggleFavoriteUseCase useCase = ref.read(
      toggleFavoriteUseCaseProvider,
    );
    final Either<Failure, List<FavoriteEntity>> result = await useCase.call(
      symbol,
    );

    result.fold(
      (final Failure failure) => state = FavoritesState.failure(failure),
      (final List<FavoriteEntity> favorites) =>
          state = FavoritesState.success(favorites),
    );
  }

  /// Returns whether the given [symbol] is currently a favorite.
  bool isFavorite(final String symbol) => switch (state) {
    FavoritesStateSuccess(:final List<FavoriteEntity> favorites) =>
      favorites.any((final FavoriteEntity f) => f.symbol == symbol),
    _ => false,
  };
}
