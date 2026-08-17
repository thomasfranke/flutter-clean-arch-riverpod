import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_quote_notifier.g.dart';

/// Notifier for managing the state of crypto quotes, including fetching and
/// error handling.
@riverpod
class CryptoQuoteNotifier extends _$CryptoQuoteNotifier {
  @override
  CryptoQuoteState build() {
    unawaited(fetchQuotes());
    return const CryptoQuoteState.loading();
  }

  /// Fetches crypto quotes and updates the state accordingly.
  Future<void> fetchQuotes() async {
    final GetCryptoQuotesUseCase useCase = ref.read(
      getCryptoQuotesUseCaseProvider,
    );
    final Either<Failure, List<CryptoQuoteEntity>> result = await useCase
        .call();

    if (!ref.mounted) {
      return;
    }
    state = result.fold(CryptoQuoteState.failure, CryptoQuoteState.success);
  }
}
