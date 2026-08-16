import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/save_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';

/// Use case for updating the font scale preference.
///
/// Fetches the current preferences, applies the font scale update, and persists
/// the result.
class UpdateFontScaleUseCase {
  /// Creates an [UpdateFontScaleUseCase] with the required use cases.
  const UpdateFontScaleUseCase({
    required this.getPreferences,
    required this.savePreferences,
  });

  /// The use case for fetching the current preferences.
  final GetPreferencesUseCase getPreferences;

  /// The use case for persisting the updated preferences.
  final SavePreferencesUseCase savePreferences;

  /// Executes the use case, returning either a [Failure] or [Unit] on success.
  Future<Either<Failure, Unit>> call(final double fontScale) async {
    final Either<Failure, PreferencesEntity> result = await getPreferences();

    return result.fold(
      Left.new,
      (final PreferencesEntity current) =>
          savePreferences(current.copyWith(fontScale: fontScale)),
    );
  }
}
