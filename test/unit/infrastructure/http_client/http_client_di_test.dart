import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test("dioProvider builds a Dio configured with the app's base URL", () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final Dio dio = container.read(dioProvider);

    expect(dio.options.baseUrl, 'https://data-api.binance.vision');
    expect(dio.interceptors, isNotEmpty);
    expect(dioProvider.overrideWithValue(dio), isNotNull);

    final bool Function(int?) validateStatus = dio.options.validateStatus;
    expect(validateStatus(200), isTrue);
    expect(validateStatus(404), isFalse);
  });

  test('httpClientProvider builds an HttpClientDioImpl using the real Dio', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final HttpClientInterface httpClient = container.read(httpClientProvider);

    expect(httpClient, isA<HttpClientDioImpl>());
    expect(httpClientProvider.overrideWithValue(httpClient), isNotNull);
  });
}
