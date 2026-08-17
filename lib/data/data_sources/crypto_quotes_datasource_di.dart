import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_quotes_datasource_di.g.dart';

/// Riverpod provider for the [CryptoQuoteDatasource].
@riverpod
CryptoQuoteDatasource cryptoQuoteDatasource(final Ref ref) =>
    CryptoQuoteDatasource(httpClient: ref.watch(httpClientProvider));
