import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';

/// Use case for fetching the current user preferences.
class GetPreferencesUseCase {
  /// Creates a [GetPreferencesUseCase] with the required
  /// [PreferencesRepository].
  const GetPreferencesUseCase({required this.repository});

  /// The repository used to retrieve user preferences.
  final PreferencesRepository repository;

  /// Executes the use case, returning either a [Failure]
  /// or a [PreferencesEntity] entity.
  Future<Either<Failure, PreferencesEntity>> call() =>
      repository.getPreferences();
}
