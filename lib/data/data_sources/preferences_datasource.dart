import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';

/// A datasource for managing user preferences using shared preferences.
class PreferencesDatasource {
  /// Creates a [PreferencesDatasource] instance.
  const PreferencesDatasource({required this.storage});

  /// The storage interface for accessing stored preferences.
  final StorageInterface storage;

  /// Retrieves user preferences from storage and returns a
  /// [PreferencesDAO] wrapped in an [Either] for error handling.
  Either<Failure, PreferencesDAO> getPreferences() {
    final Either<StorageFailure, String?> localeResult = storage.getString(
      key: 'pref_locale',
    );

    if (localeResult.isLeft()) {
      return Left<Failure, PreferencesDAO>(
        (localeResult as Left<StorageFailure, String?>).value.toDomainFailure(),
      );
    }

    final Either<StorageFailure, bool?> darkModeResult = storage.getBool(
      key: 'pref_dark_mode',
    );

    if (darkModeResult.isLeft()) {
      return Left<Failure, PreferencesDAO>(
        (darkModeResult as Left<StorageFailure, bool?>).value.toDomainFailure(),
      );
    }

    final Either<StorageFailure, double?> fontScaleResult = storage.getDouble(
      key: 'pref_font_scale',
    );

    if (fontScaleResult.isLeft()) {
      return Left<Failure, PreferencesDAO>(
        (fontScaleResult as Left<StorageFailure, double?>).value
            .toDomainFailure(),
      );
    }

    return Right<Failure, PreferencesDAO>(
      PreferencesDAO(
        locale: localeResult.fold((_) => null, (String? value) => value),
        darkMode: darkModeResult.fold((_) => null, (bool? value) => value),
        fontScale: fontScaleResult.fold((_) => null, (double? value) => value),
      ),
    );
  }

  /// Saves only the locale preference to storage.
  Future<Either<Failure, Unit>> saveLocale(final String locale) async {
    final Either<StorageFailure, Unit> result = await storage.setString(
      key: 'pref_locale',
      value: locale,
    );
    return result.leftMap(
      (final StorageFailure failure) => failure.toDomainFailure(),
    );
  }

  /// Saves only the dark mode preference to storage.
  Future<Either<Failure, Unit>> saveDarkMode(final bool darkMode) async {
    final Either<StorageFailure, Unit> result = await storage.setBool(
      key: 'pref_dark_mode',
      value: darkMode,
    );
    return result.leftMap(
      (final StorageFailure failure) => failure.toDomainFailure(),
    );
  }

  /// Saves only the font scale preference to storage.
  Future<Either<Failure, Unit>> saveFontScale(final double fontScale) async {
    final Either<StorageFailure, Unit> result = await storage.setDouble(
      key: 'pref_font_scale',
      value: fontScale,
    );
    return result.leftMap(
      (final StorageFailure failure) => failure.toDomainFailure(),
    );
  }
}
