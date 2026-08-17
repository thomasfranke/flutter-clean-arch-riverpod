import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/core/constants/app_config.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_interceptor_retry.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_constants.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_di.g.dart';

/// Provides the HTTP client implementation backed by Dio.
@Riverpod(keepAlive: true)
HttpClientInterface httpClient(final Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  return HttpClientDioImpl(dio: dio);
}

/// Creates and configures the main Dio instance used for all HTTP requests.
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(
        seconds: HttpClientConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(
        seconds: HttpClientConstants.receiveTimeout,
      ),
      sendTimeout: const Duration(seconds: HttpClientConstants.sendTimeout),
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (final int? status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.add(HttpClientDioInterceptor(dio: dio));

  return dio;
}
