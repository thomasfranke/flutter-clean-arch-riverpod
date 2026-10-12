import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/failure_mappers.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';

/// Turns what the datasource resolved into what the domain contract promises:
/// a [StorageFailure] becomes a [Failure], a symbol becomes a
/// [FavoriteEntity].
///
/// All four methods of this repository end the same way, so the translation
/// is written once here rather than four times below.
Either<Failure, List<FavoriteEntity>> _toDomain(
  final Either<StorageFailure, List<String>> result,
) => result
    .leftMap((final StorageFailure failure) => failure.toDomainFailure())
    .map(
      (final List<String> symbols) => symbols
          .map((final String symbol) => FavoriteEntity(symbol: symbol))
          .toList(),
    );

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
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async =>
      _toDomain(datasource.getFavorites());

  @override
  Future<Either<Failure, List<FavoriteEntity>>> addFavorite(
    final String symbol,
  ) async => _toDomain(await datasource.addFavorite(symbol));

  @override
  Future<Either<Failure, List<FavoriteEntity>>> removeFavorite(
    final String symbol,
  ) async => _toDomain(await datasource.removeFavorite(symbol));

  @override
  Future<Either<Failure, List<FavoriteEntity>>> toggleFavorite(
    final String symbol,
  ) async => _toDomain(await datasource.toggleFavorite(symbol));
}
