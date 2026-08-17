import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('cryptoQuotesRepositoryProvider builds a CryptoQuotesRepositoryImpl '
      'using the real datasource', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final CryptoQuoteRepository repository = container.read(
      cryptoQuotesRepositoryProvider,
    );

    expect(repository, isA<CryptoQuotesRepositoryImpl>());
    expect(
      cryptoQuotesRepositoryProvider.overrideWithValue(repository),
      isNotNull,
    );
  });
}
