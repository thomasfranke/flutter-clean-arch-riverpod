import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';

/// Use case for updating the locale preference.
///
/// Persists only the locale, independently of the other preferences.
class UpdateLocaleUseCase {
  /// Creates an [UpdateLocaleUseCase] with the
  /// required [PreferencesRepository].
  const UpdateLocaleUseCase({required this.repository});

  /// The repository used to persist the locale preference.
  final PreferencesRepository repository;

  /// Executes the use case, returning either a [Failure] or [Unit] on success.
  Future<Either<Failure, Unit>> call(final String locale) =>
      repository.saveLocale(locale);
}
