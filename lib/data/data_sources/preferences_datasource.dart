import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';

/// A datasource for managing user preferences using shared preferences.
///
/// It resolves data and nothing else: it knows the three keys and how they
/// compose into a [PreferencesDAO]. The [StorageFailure] it returns is
/// translated by the repository, not here.
class PreferencesDatasource {
  /// Creates a [PreferencesDatasource] instance.
  const PreferencesDatasource({required this.storage});

  /// The storage interface for accessing stored preferences.
  final StorageInterface storage;

  /// Retrieves user preferences from storage and returns a
  /// [PreferencesDAO] wrapped in an [Either] for error handling.
  ///
  /// The first key that fails decides the result: a half-read preferences
  /// record is not a record, so there is nothing useful to return.
  Either<StorageFailure, PreferencesDAO> getPreferences() => storage
      .getString(key: 'pref_locale')
      .flatMap(
        (final String? locale) => storage
            .getBool(key: 'pref_dark_mode')
            .flatMap(
              (final bool? darkMode) => storage
                  .getDouble(key: 'pref_font_scale')
                  .map(
                    (final double? fontScale) => PreferencesDAO(
                      locale: locale,
                      darkMode: darkMode,
                      fontScale: fontScale,
                    ),
                  ),
            ),
      );

  /// Saves only the locale preference to storage.
  Future<Either<StorageFailure, Unit>> saveLocale(final String locale) =>
      storage.setString(key: 'pref_locale', value: locale);

  /// Saves only the dark mode preference to storage.
  Future<Either<StorageFailure, Unit>> saveDarkMode(final bool darkMode) =>
      storage.setBool(key: 'pref_dark_mode', value: darkMode);

  /// Saves only the font scale preference to storage.
  Future<Either<StorageFailure, Unit>> saveFontScale(final double fontScale) =>
      storage.setDouble(key: 'pref_font_scale', value: fontScale);
}
