import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';

/// Use case for toggling a cryptocurrency as favorite.
///
/// Fetches the current favorites list, then adds or removes the given symbol
/// based on whether it is already a favorite.
class ToggleFavoriteUseCase {
  /// Creates a [ToggleFavoriteUseCase] with the required [FavoritesRepository].
  const ToggleFavoriteUseCase({required this.repository});

  /// The repository used to manage favorites.
  final FavoritesRepository repository;

  /// Executes the use case, returning either a [Failure] or the updated list
  /// of [FavoriteEntity] entities.
  Future<Either<Failure, List<FavoriteEntity>>> call(
    final String symbol,
  ) async {
    final Either<Failure, List<FavoriteEntity>> result = await repository
        .getFavorites();

    return result.fold(Left.new, (final List<FavoriteEntity> favorites) {
      final bool isFavorite = favorites.any(
        (final FavoriteEntity f) => f.symbol == symbol,
      );

      return isFavorite
          ? repository.removeFavorite(symbol)
          : repository.addFavorite(symbol);
    });
  }
}
