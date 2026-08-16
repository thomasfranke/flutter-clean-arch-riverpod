import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_dao.freezed.dart';

/// Data Access Object (DAO) for user preferences, responsible for retrieving
/// and storing user settings such as locale, dark mode, and font scale
/// using [SharedPreferences].
@freezed
abstract class PreferencesDAO with _$PreferencesDAO {
  /// Creates a [PreferencesDAO] instance with the given parameters.
  const factory PreferencesDAO({
    required final String? locale,
    required final bool? darkMode,
    required final double? fontScale,
  }) = _PreferencesDAO;
}

/// Extension method to convert [PreferencesDAO] to the domain
/// entity [PreferencesEntity].
extension PreferencesDAOMapper on PreferencesDAO {
  /// Converts the [PreferencesDAO] instance to a [PreferencesEntity] entity,
  /// providing default values for any null fields based
  /// on [PreferencesEntity.defaults].
  PreferencesEntity toEntity() => PreferencesEntity(
    locale: locale ?? PreferencesEntity.defaults().locale,
    darkMode: darkMode ?? PreferencesEntity.defaults().darkMode,
    fontScale: fontScale ?? PreferencesEntity.defaults().fontScale,
  );
}
