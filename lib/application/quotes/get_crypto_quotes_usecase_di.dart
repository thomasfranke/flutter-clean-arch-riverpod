import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_crypto_quotes_usecase_di.g.dart';

/// Riverpod provider for the [GetCryptoQuotesUseCase].
@riverpod
GetCryptoQuotesUseCase getCryptoQuotesUseCase(Ref ref) =>
    GetCryptoQuotesUseCase(
      repository: ref.watch(cryptoQuotesRepositoryProvider),
    );
