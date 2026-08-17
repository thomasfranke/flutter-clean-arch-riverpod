import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase_di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('getKlinesUseCaseProvider builds a GetKlinesUseCase using the real '
      'repository', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(getKlinesUseCaseProvider), isA<GetKlinesUseCase>());
  });
}
