import 'dart:async';

import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
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

  /// Loads the list of favorites, returning the [Failure] if the read
  /// failed.
  ///
  /// The state becomes `failure` only when nothing was loaded before; a
  /// failed reload keeps the favorites already held.
  Future<Failure?> loadFavorites() async {
    final GetFavoritesUseCase useCase = ref.read(getFavoritesUseCaseProvider);
    final Either<Failure, List<FavoriteEntity>> result = await useCase.call();

    if (!ref.mounted) {
      return result.fold((final Failure failure) => failure, (_) => null);
    }
    return result.fold(
      (final Failure failure) {
        if (state is! FavoritesStateSuccess) {
          state = FavoritesState.failure(failure);
        }
        return failure;
      },
      (final List<FavoriteEntity> favorites) {
        state = FavoritesState.success(favorites);
        return null;
      },
    );
  }

  /// Toggles the favorite status of the given [symbol], returning the
  /// [Failure] if it was not saved.
  ///
  /// A failed toggle leaves the list as it was. Replacing it with the failure
  /// would empty every star on screen over one symbol that did not save.
  Future<Failure?> toggleFavorite(final String symbol) async {
    final ToggleFavoriteUseCase useCase = ref.read(
      toggleFavoriteUseCaseProvider,
    );
    final Either<Failure, List<FavoriteEntity>> result = await useCase.call(
      symbol,
    );

    if (!ref.mounted) {
      return result.fold((final Failure failure) => failure, (_) => null);
    }
    return result.fold((final Failure failure) => failure, (
      final List<FavoriteEntity> favorites,
    ) {
      state = FavoritesState.success(favorites);
      return null;
    });
  }

  /// Returns whether the given [symbol] is currently a favorite.
  bool isFavorite(final String symbol) => switch (state) {
    FavoritesStateSuccess(:final List<FavoriteEntity> favorites) =>
      favorites.any((final FavoriteEntity f) => f.symbol == symbol),
    _ => false,
  };
}
