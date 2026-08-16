import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_state.freezed.dart';

/// State class for managing user preferences, including loading, success, and
/// failure states.
@freezed
sealed class PreferencesState with _$PreferencesState {
  const factory PreferencesState.initial() = PreferencesStateInitial;
  const factory PreferencesState.loading() = PreferencesStateLoading;
  const factory PreferencesState.success(PreferencesEntity preferences) =
      PreferencesStateSuccess;
  const factory PreferencesState.failure(Failure failure) =
      PreferencesStateFailure;
}
