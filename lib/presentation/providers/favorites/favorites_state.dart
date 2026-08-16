import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_state.freezed.dart';

/// Represents the state of the favorites feature, including loading,
/// success, and failure states.
@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesStateInitial;
  const factory FavoritesState.loading() = FavoritesStateLoading;
  const factory FavoritesState.success(final List<FavoriteEntity> favorites) =
      FavoritesStateSuccess;
  const factory FavoritesState.failure(final Failure failure) =
      FavoritesStateFailure;
}
