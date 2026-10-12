import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/failure_mappers.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';

/// Named rather than repeated inline, because all four methods below end
/// with it: the storage failure the datasource reports is only a domain
/// [Failure] once it has crossed this class.
Failure _toDomainFailure(final StorageFailure failure) =>
    failure.toDomainFailure();

/// Repository implementation for managing user preferences, using
/// [PreferencesDatasource] to persist data and converting it to domain
/// entities.
class PreferencesRepositoryImpl implements PreferencesRepository {
  /// Creates a [PreferencesRepositoryImpl] instance.
  const PreferencesRepositoryImpl({required this.datasource});

  /// The datasource for accessing stored preferences.
  final PreferencesDatasource datasource;

  @override
  Future<Either<Failure, PreferencesEntity>> getPreferences() async =>
      datasource
          .getPreferences()
          .leftMap(_toDomainFailure)
          .map((final PreferencesDAO dao) => dao.toEntity());

  @override
  Future<Either<Failure, Unit>> saveLocale(final String locale) async =>
      (await datasource.saveLocale(locale)).leftMap(_toDomainFailure);

  @override
  Future<Either<Failure, Unit>> saveDarkMode(final bool darkMode) async =>
      (await datasource.saveDarkMode(darkMode)).leftMap(_toDomainFailure);

  @override
  Future<Either<Failure, Unit>> saveFontScale(final double fontScale) async =>
      (await datasource.saveFontScale(fontScale)).leftMap(_toDomainFailure);
}
