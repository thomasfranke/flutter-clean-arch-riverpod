import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';

/// Key used to store the favorites list in the storage.
const String _favoritesKey = 'favorites';

/// Datasource for managing favorite cryptocurrencies using [StorageInterface].
///
/// It owns the storage key and nothing else. The [StorageFailure] it returns
/// reaches the repository untranslated, which is where it becomes a domain
/// failure.
class FavoritesDatasource {
  /// Creates a [FavoritesDatasource] with the required [StorageInterface].
  const FavoritesDatasource({required this.storage});

  /// The storage interface used to persist favorites.
  final StorageInterface storage;

  /// Retrieves the list of favorite symbols from storage, returning either a
  /// [StorageFailure] or a list of symbol strings.
  Either<StorageFailure, List<String>> getFavorites() =>
      storage.getList(key: _favoritesKey);

  /// Adds a symbol to the favorites list in storage, returning either a
  /// [StorageFailure] or the updated list of symbol strings.
  Future<Either<StorageFailure, List<String>>> addFavorite(
    final String symbol,
  ) => storage.addToList(key: _favoritesKey, value: symbol);

  /// Removes a symbol from the favorites list in storage, returning either a
  /// [StorageFailure] or the updated list of symbol strings.
  Future<Either<StorageFailure, List<String>>> removeFavorite(
    final String symbol,
  ) => storage.removeFromList(key: _favoritesKey, value: symbol);

  /// Atomically toggles a symbol's favorite status in storage, returning
  /// either a [StorageFailure] or the updated list of symbol strings.
  Future<Either<StorageFailure, List<String>>> toggleFavorite(
    final String symbol,
  ) => storage.toggleInList(key: _favoritesKey, value: symbol);
}
