import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository implementation for managing user preferences, using
/// [SharedPreferences] to persist data and converting it to domain
/// entities.
class PreferencesRepositoryImpl implements PreferencesRepository {
  /// Creates a [PreferencesRepositoryImpl] instance.
  const PreferencesRepositoryImpl({required this.datasource});

  /// The datasource for accessing stored preferences.
  final PreferencesDatasource datasource;

  @override
  Future<Either<Failure, PreferencesEntity>> getPreferences() async {
    final Either<Failure, PreferencesDAO> result = datasource.getPreferences();
    return result.map((PreferencesDAO dao) => dao.toEntity());
  }

  @override
  Future<Either<Failure, Unit>> savePreferences(
    final PreferencesEntity preferences,
  ) async {
    final PreferencesDAO dao = PreferencesDAO(
      locale: preferences.locale,
      darkMode: preferences.darkMode,
      fontScale: preferences.fontScale,
    );
    return datasource.savePreferences(dao);
  }
}
