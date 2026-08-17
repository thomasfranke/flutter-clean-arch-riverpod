import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource_di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('cryptoQuoteDatasourceProvider builds a CryptoQuoteDatasource using the '
      'real HttpClient', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final CryptoQuoteDatasource datasource = container.read(
      cryptoQuoteDatasourceProvider,
    );

    expect(datasource, isA<CryptoQuoteDatasource>());
    expect(
      cryptoQuoteDatasourceProvider.overrideWithValue(datasource),
      isNotNull,
    );
  });
}
