import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_quote_state.freezed.dart';

/// Represents the state of the crypto quote feature, including loading,
/// success, and failure states.
@freezed
sealed class CryptoQuoteState with _$CryptoQuoteState {
  const factory CryptoQuoteState.initial() = CryptoQuoteStateInitial;
  const factory CryptoQuoteState.loading() = CryptoQuoteStateLoading;
  const factory CryptoQuoteState.success(final List<CryptoQuoteEntity> quotes) =
      CryptoQuoteStateSuccess;
  const factory CryptoQuoteState.failure(final Failure failure) =
      CryptoQuoteStateFailure;
}
