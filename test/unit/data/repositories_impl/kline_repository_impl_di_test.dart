import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('klineRepositoryProvider builds a KlineRepositoryImpl using the real '
      'datasource', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final KlineRepository repository = container.read(klineRepositoryProvider);

    expect(repository, isA<KlineRepositoryImpl>());
    expect(klineRepositoryProvider.overrideWithValue(repository), isNotNull);
  });
}
