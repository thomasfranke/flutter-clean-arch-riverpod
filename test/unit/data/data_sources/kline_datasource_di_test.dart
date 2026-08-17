import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource_di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('klineDatasourceProvider builds a KlineDatasource using the real '
      'HttpClient', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final KlineDatasource datasource = container.read(klineDatasourceProvider);

    expect(datasource, isA<KlineDatasource>());
    expect(klineDatasourceProvider.overrideWithValue(datasource), isNotNull);
  });
}
