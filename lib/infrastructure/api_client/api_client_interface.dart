import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/models/api_route.dart';

/// Abstract interface for HTTP client.
abstract interface class ApiClientInterface {
  /// Request.
  Future<Either<ApiClientFailure, Response<dynamic>>> request({
    required final ApiRoute apiRoute,
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final String customBaseUrl,
    final void Function(double progress)? onProgress,
  });

  /// File upload.
  Future<Either<ApiClientFailure, Response<dynamic>>> upload({
    required final String path,
    required final String filePath,
    final Map<String, dynamic>? data,
    final String fieldName = 'file',
    final ProgressCallback? onSendProgress,
    final CancelToken? cancelToken,
  });

  /// File download.
  Future<Either<ApiClientFailure, Response<dynamic>>> download({
    required final String urlPath,
    required final String savePath,
    final ProgressCallback? onReceiveProgress,
    final CancelToken? cancelToken,
  });

  /// Set custom header.
  void setHeader({required final String key, required final String value});

  /// Removes custom header.
  void removeHeader({required final String key});

  /// Close the Dio client.
  void close();
}
