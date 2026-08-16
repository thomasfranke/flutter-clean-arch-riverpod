import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kline_state.freezed.dart';

/// Represents the state of the kline feature, including loading, success,
/// and failure states.
@freezed
sealed class KlineState with _$KlineState {
  const factory KlineState.initial() = KlineStateInitial;
  const factory KlineState.loading() = KlineStateLoading;
  const factory KlineState.success(final List<Kline> klines) =
      KlineStateSuccess;
  const factory KlineState.failure(final Failure failure) = KlineStateFailure;
}
