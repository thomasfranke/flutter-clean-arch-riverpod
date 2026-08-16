import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';

/// Key used to store the favorites list in the storage.
const String _favoritesKey = 'favorites';

/// Datasource for managing favorite cryptocurrencies using [StorageInterface].
class FavoritesDatasource {
  /// Creates a [FavoritesDatasource] with the required [StorageInterface].
  const FavoritesDatasource({required this.storage});

  /// The storage interface used to persist favorites.
  final StorageInterface storage;

  /// Retrieves the list of favorite symbols from storage, returning either a
  /// [Failure] or a list of symbol strings.
  Either<Failure, List<String>> getFavorites() {
    final Either<StorageFailure, List<String>> result = storage.getList(
      key: _favoritesKey,
    );

    return result.fold(
      (final StorageFailure failure) =>
          Left<Failure, List<String>>(failure.toDomainFailure()),
      Right<Failure, List<String>>.new,
    );
  }

  /// Adds a symbol to the favorites list in storage, returning either a
  /// [Failure] or the updated list of symbol strings.
  Future<Either<Failure, List<String>>> addFavorite(final String symbol) async {
    final Either<StorageFailure, List<String>> result = await storage.addToList(
      key: _favoritesKey,
      value: symbol,
    );

    return result.fold(
      (final StorageFailure failure) =>
          Left<Failure, List<String>>(failure.toDomainFailure()),
      Right<Failure, List<String>>.new,
    );
  }

  /// Removes a symbol from the favorites list in storage, returning either a
  /// [Failure] or the updated list of symbol strings.
  Future<Either<Failure, List<String>>> removeFavorite(
    final String symbol,
  ) async {
    final Either<StorageFailure, List<String>> result = await storage
        .removeFromList(key: _favoritesKey, value: symbol);

    return result.fold(
      (final StorageFailure failure) =>
          Left<Failure, List<String>>(failure.toDomainFailure()),
      Right<Failure, List<String>>.new,
    );
  }
}
