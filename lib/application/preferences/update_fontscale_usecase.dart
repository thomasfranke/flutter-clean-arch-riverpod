import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';

/// Use case for updating the font scale preference.
///
/// Persists only the font scale, independently of the other preferences.
class UpdateFontScaleUseCase {
  /// Creates an [UpdateFontScaleUseCase] with the
  /// required [PreferencesRepository].
  const UpdateFontScaleUseCase({required this.repository});

  /// The repository used to persist the font scale preference.
  final PreferencesRepository repository;

  /// Executes the use case, returning either a [Failure] or [Unit] on success.
  Future<Either<Failure, Unit>> call(final double fontScale) =>
      repository.saveFontScale(fontScale);
}
