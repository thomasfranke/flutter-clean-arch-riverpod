import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_quotes_repository_impl_di.g.dart';

/// Riverpod provider for the [CryptoQuotesRepositoryImpl], allowing it to be
/// easily injected and used throughout the application.
@riverpod
CryptoQuoteRepository cryptoQuotesRepository(final Ref ref) =>
    CryptoQuotesRepositoryImpl(
      datasource: ref.watch(cryptoQuoteDatasourceProvider),
    );
