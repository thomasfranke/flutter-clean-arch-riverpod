import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';

/// Repository interface for managing favorite cryptocurrencies, defining the
/// contract for retrieving, adding, and removing favorites.
abstract interface class FavoritesRepository {
  /// Retrieves the list of favorite cryptocurrencies, returning either a
  /// [Failure] or a list of [FavoriteEntity] entities.
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();

  /// Adds a cryptocurrency to the favorites list by [symbol], returning either
  /// a [Failure] or the updated list of [FavoriteEntity] entities.
  Future<Either<Failure, List<FavoriteEntity>>> addFavorite(
    final String symbol,
  );

  /// Removes a cryptocurrency from the favorites list by [symbol], returning
  /// either a [Failure] or the updated list of [FavoriteEntity] entities.
  Future<Either<Failure, List<FavoriteEntity>>> removeFavorite(
    final String symbol,
  );

  /// Atomically toggles a cryptocurrency's favorite status by [symbol],
  /// returning either a [Failure] or the updated list of [FavoriteEntity]
  /// entities.
  Future<Either<Failure, List<FavoriteEntity>>> toggleFavorite(
    final String symbol,
  );
}
