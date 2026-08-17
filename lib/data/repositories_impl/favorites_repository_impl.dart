import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';

/// Repository implementation for managing favorite cryptocurrencies, using
/// [FavoritesDatasource] to persist data and converting symbols to
/// [FavoriteEntity]
/// entities.
class FavoritesRepositoryImpl implements FavoritesRepository {
  /// Creates a [FavoritesRepositoryImpl] with the required
  /// [FavoritesDatasource].
  const FavoritesRepositoryImpl({required this.datasource});

  /// The datasource used to persist favorites.
  final FavoritesDatasource datasource;

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async {
    final Either<Failure, List<String>> result = datasource.getFavorites();

    return result.map(
      (final List<String> symbols) =>
          symbols.map((final String s) => FavoriteEntity(symbol: s)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<FavoriteEntity>>> addFavorite(
    final String symbol,
  ) async {
    final Either<Failure, List<String>> result = await datasource.addFavorite(
      symbol,
    );

    return result.map(
      (final List<String> symbols) =>
          symbols.map((final String s) => FavoriteEntity(symbol: s)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<FavoriteEntity>>> removeFavorite(
    final String symbol,
  ) async {
    final Either<Failure, List<String>> result = await datasource
        .removeFavorite(symbol);

    return result.map(
      (final List<String> symbols) =>
          symbols.map((final String s) => FavoriteEntity(symbol: s)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<FavoriteEntity>>> toggleFavorite(
    final String symbol,
  ) async {
    final Either<Failure, List<String>> result = await datasource
        .toggleFavorite(symbol);

    return result.map(
      (final List<String> symbols) =>
          symbols.map((final String s) => FavoriteEntity(symbol: s)).toList(),
    );
  }
}
