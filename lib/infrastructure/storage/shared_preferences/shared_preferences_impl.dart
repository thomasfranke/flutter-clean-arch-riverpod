import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of the [StorageInterface] using
/// `shared_preferences` package.
class SharedPreferencesImpl implements StorageInterface {
  /// Constructor that takes a [SharedPreferences] instance.
  SharedPreferencesImpl(this._prefs);
  final SharedPreferences _prefs;

  /// Static method to create the instance asynchronously.
  static Future<SharedPreferencesImpl> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return SharedPreferencesImpl(prefs);
  }

  /// --- Setters ---p
  @override
  Future<Either<StorageFailure, Unit>> setString({
    required final String key,
    required final String value,
  }) async {
    try {
      await _prefs.setString(key, value);
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  @override
  Future<Either<StorageFailure, Unit>> setBool({
    required final String key,
    required final bool value,
  }) async {
    try {
      await _prefs.setBool(key, value);
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  @override
  Future<Either<StorageFailure, Unit>> setInt({
    required final String key,
    required final int value,
  }) async {
    try {
      await _prefs.setInt(key, value);
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  @override
  Future<Either<StorageFailure, Unit>> setDouble({
    required final String key,
    required final double value,
  }) async {
    try {
      await _prefs.setDouble(key, value);
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  /// --- Getters ---
  @override
  Either<StorageFailure, String?> getString({required final String key}) {
    try {
      final String? value = _prefs.getString(key);
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.read());
    }
  }

  @override
  Either<StorageFailure, bool?> getBool({required final String key}) {
    try {
      final bool? value = _prefs.getBool(key);
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.read());
    }
  }

  @override
  Either<StorageFailure, int?> getInt({required final String key}) {
    try {
      final int? value = _prefs.getInt(key);
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.read());
    }
  }

  @override
  Either<StorageFailure, double?> getDouble({required final String key}) {
    try {
      final double? value = _prefs.getDouble(key);
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.read());
    }
  }

  /// --- List ---
  @override
  Future<Either<StorageFailure, List<String>>> setList({
    required final String key,
    required final List<String> value,
  }) async {
    try {
      await _prefs.setStringList(key, value);
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  @override
  Either<StorageFailure, List<String>> getList({required final String key}) {
    try {
      final List<String> value = _prefs.getStringList(key) ?? <String>[];
      return right(value);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.read());
    }
  }

  @override
  Future<Either<StorageFailure, List<String>>> addToList({
    required final String key,
    required final String value,
  }) async {
    try {
      final List<String> currentList = List<String>.from(
        _prefs.getStringList(key) ?? <String>[],
      );

      if (!currentList.contains(value)) {
        currentList.add(value);
        await _prefs.setStringList(key, currentList);
      }

      return right(currentList);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  @override
  Future<Either<StorageFailure, List<String>>> removeFromList({
    required final String key,
    required final String value,
  }) async {
    try {
      final List<String> currentList = List<String>.from(
        _prefs.getStringList(key) ?? <String>[],
      )..remove(value);

      await _prefs.setStringList(key, currentList);
      return right(currentList);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.write());
    }
  }

  /// --- Remove ---
  @override
  Future<Either<StorageFailure, Unit>> remove({
    required final String key,
  }) async {
    try {
      await _prefs.remove(key);
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.remove());
    }
  }

  @override
  Future<Either<StorageFailure, Unit>> clear() async {
    try {
      await _prefs.clear();
      return right(unit);
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const StorageFailure.clear());
    }
  }
}
