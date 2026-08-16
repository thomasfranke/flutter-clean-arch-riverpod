import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_entity.freezed.dart';

/// Domain entity representing user preferences, including locale, dark mode,
/// and font scale, used within the application to encapsulate user settings.
@freezed
abstract class PreferencesEntity with _$PreferencesEntity {
  /// Creates a [PreferencesEntity] instance with the given parameters.
  const factory PreferencesEntity({
    required final String locale,
    required final bool darkMode,
    required final double fontScale,
  }) = _PreferencesEntity;

  /// Factory method to create a [PreferencesEntity] instance
  /// with default values.
  factory PreferencesEntity.defaults() =>
      const PreferencesEntity(locale: 'pt', darkMode: false, fontScale: 1);
}
