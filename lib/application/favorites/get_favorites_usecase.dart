import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';

/// Use case for fetching the list of favorite cryptocurrencies.
class GetFavoritesUseCase {
  /// Creates a [GetFavoritesUseCase] with the required [FavoritesRepository].
  const GetFavoritesUseCase({required this.repository});

  /// The repository used to retrieve favorites.
  final FavoritesRepository repository;

  /// Executes the use case, returning either a [Failure] or a list of
  /// [FavoriteEntity] entities.
  Future<Either<Failure, List<FavoriteEntity>>> call() =>
      repository.getFavorites();
}
