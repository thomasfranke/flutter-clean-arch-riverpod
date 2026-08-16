import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/core/constants/app_config.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_constants.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/dio/dio_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/dio/dio_interceptor_retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_di.g.dart';

/// Provides the API client implementation backed by Dio.
@Riverpod(keepAlive: true)
ApiClientInterface apiClient(final Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  return ApiClientDioImpl(dio: dio);
}

/// Creates and configures the main Dio instance used for all API requests.
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(
        seconds: ApiClientConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(
        seconds: ApiClientConstants.receiveTimeout,
      ),
      sendTimeout: const Duration(seconds: ApiClientConstants.sendTimeout),
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (final int? status) =>
          status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.add(ApiClientDioInterceptor(dio: dio));

  return dio;
}
