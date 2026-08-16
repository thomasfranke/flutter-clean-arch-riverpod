import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';

/// Interface for Storage operations.
abstract class StorageInterface {
  /// -- Setters --
  /// - Set a String value for the given key.
  Future<Either<StorageFailure, Unit>> setString({
    required final String key,
    required final String value,
  });

  /// - Set a boolean value for the given key.
  Future<Either<StorageFailure, Unit>> setBool({
    required final String key,
    required final bool value,
  });

  /// - Set an integer value for the given key.
  Future<Either<StorageFailure, Unit>> setInt({
    required final String key,
    required final int value,
  });

  /// - Set a double value for the given key.
  Future<Either<StorageFailure, Unit>> setDouble({
    required final String key,
    required final double value,
  });

  /// --- Getters ---
  /// - Get a String value for the given key.
  Either<StorageFailure, String?> getString({required final String key});

  /// - Get a boolean value for the given key.
  Either<StorageFailure, bool?> getBool({required final String key});

  /// - Get an integer value for the given key.
  Either<StorageFailure, int?> getInt({required final String key});

  /// - Get a double value for the given key.
  Either<StorageFailure, double?> getDouble({required final String key});

  /// --- List ---
  /// - Set a list of strings for the given key.
  Future<Either<StorageFailure, List<String>>> setList({
    required final String key,
    required final List<String> value,
  });

  /// - Get a list of strings for the given key.
  Either<StorageFailure, List<String>> getList({required final String key});

  /// - Add or remove items from a list:
  Future<Either<StorageFailure, List<String>>> addToList({
    required final String key,
    required final String value,
  });

  /// - Remove an item from a list:
  Future<Either<StorageFailure, List<String>>> removeFromList({
    required final String key,
    required final String value,
  });

  /// --- Remove ---
  /// - Remove the value for the given key.
  Future<Either<StorageFailure, Unit>> remove({required final String key});

  /// - Remove all stored preferences.
  Future<Either<StorageFailure, Unit>> clear();
}
