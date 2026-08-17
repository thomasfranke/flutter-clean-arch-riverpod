import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';

/// Repository interface for managing user preferences, defining the contract
/// for retrieving and saving user settings such as locale, dark mode, and
/// font scale.
abstract interface class PreferencesRepository {
  /// Retrieves the user preferences, returning either a [Failure] or a
  /// [PreferencesEntity] entity.
  Future<Either<Failure, PreferencesEntity>> getPreferences();

  /// Saves only the locale preference, returning either a [Failure] or a
  /// [Unit] to indicate success.
  Future<Either<Failure, Unit>> saveLocale(String locale);

  /// Saves only the dark mode preference, returning either a [Failure] or a
  /// [Unit] to indicate success.
  Future<Either<Failure, Unit>> saveDarkMode(bool darkMode);

  /// Saves only the font scale preference, returning either a [Failure] or a
  /// [Unit] to indicate success.
  Future<Either<Failure, Unit>> saveFontScale(double fontScale);
}
