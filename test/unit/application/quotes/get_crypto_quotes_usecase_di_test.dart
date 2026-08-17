import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase_di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('getCryptoQuotesUseCaseProvider builds a GetCryptoQuotesUseCase using '
      'the real repository', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(getCryptoQuotesUseCaseProvider),
      isA<GetCryptoQuotesUseCase>(),
    );
  });
}
