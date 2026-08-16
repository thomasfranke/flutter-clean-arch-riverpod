import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
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
        localeResult.fold(
          (StorageFailure failure) => failure.toDomainFailure(),
          (_) => const Failure.storage(),
        ),
      );
    }

    final Either<StorageFailure, bool?> darkModeResult = storage.getBool(
      key: 'pref_dark_mode',
    );

    if (darkModeResult.isLeft()) {
      return Left<Failure, PreferencesDAO>(
        darkModeResult.fold(
          (StorageFailure failure) => failure.toDomainFailure(),
          (_) => const Failure.storage(),
        ),
      );
    }

    final Either<StorageFailure, double?> fontScaleResult = storage.getDouble(
      key: 'pref_font_scale',
    );

    if (fontScaleResult.isLeft()) {
      return Left<Failure, PreferencesDAO>(
        fontScaleResult.fold(
          (StorageFailure failure) => failure.toDomainFailure(),
          (_) => const Failure.storage(),
        ),
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

  /// Saves user preferences to storage using the provided
  /// [PreferencesDAO].
  Future<Either<Failure, Unit>> savePreferences(
    final PreferencesDAO dao,
  ) async {
    final List<Either<StorageFailure, Unit>> results =
        await Future.wait(<Future<Either<StorageFailure, Unit>>>[
          storage.setString(
            key: 'pref_locale',
            value: dao.locale ?? PreferencesEntity.defaults().locale,
          ),
          storage.setBool(
            key: 'pref_dark_mode',
            value: dao.darkMode ?? PreferencesEntity.defaults().darkMode,
          ),
          storage.setDouble(
            key: 'pref_font_scale',
            value: dao.fontScale ?? PreferencesEntity.defaults().fontScale,
          ),
        ]);

    final Left<StorageFailure, Unit>? failure = results
        .whereType<Left<StorageFailure, Unit>>()
        .firstOrNull;

    if (failure != null) {
      return Left<Failure, Unit>(failure.value.toDomainFailure());
    }

    return const Right<Failure, Unit>(unit);
  }
}
