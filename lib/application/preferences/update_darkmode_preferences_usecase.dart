import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';

/// Use case for updating the dark mode preference.
///
/// Persists only the dark mode flag, independently of the other preferences.
class UpdateDarkModeUseCase {
  /// Creates an [UpdateDarkModeUseCase] with the
  /// required [PreferencesRepository].
  const UpdateDarkModeUseCase({required this.repository});

  /// The repository used to persist the dark mode preference.
  final PreferencesRepository repository;

  /// Executes the use case, returning either a [Failure] or [Unit] on success.
  Future<Either<Failure, Unit>> call(final bool darkMode) =>
      repository.saveDarkMode(darkMode);
}
