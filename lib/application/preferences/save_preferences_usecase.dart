import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';

/// Use case for persisting user preferences.
class SavePreferencesUseCase {
  /// Creates a [SavePreferencesUseCase] with the
  /// required [PreferencesRepository].
  const SavePreferencesUseCase({required this.repository});

  /// The repository used to persist user preferences.
  final PreferencesRepository repository;

  /// Executes the use case, returning either a [Failure] or [Unit] on success.
  Future<Either<Failure, Unit>> call(final PreferencesEntity preferences) =>
      repository.savePreferences(preferences);
}
