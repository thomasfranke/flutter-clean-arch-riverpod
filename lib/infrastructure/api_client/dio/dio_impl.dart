import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/models/http_methods.dart';

/// Implementation of [ApiClientInterface] using
/// `dio` package.
class ApiClientDioImpl implements ApiClientInterface {
  /// Creates an instance of [ApiClientDioImpl].
  ApiClientDioImpl({required this.dio});

  /// Dio instance used to perform HTTP requests.
  final Dio dio;

  @override
  void setHeader({required final String key, required final String value}) {
    log('Set header: $key', name: 'APICLIENT');
    dio.options.headers[key] = value;
  }

  @override
  void removeHeader({required final String key}) {
    log('Remove header: $key', name: 'APICLIENT');
    dio.options.headers.remove(key);
  }

  @override
  Future<Either<ApiClientFailure, Response<dynamic>>> request({
    required final ApiRoute apiRoute,
    final String? customBaseUrl,
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final void Function(double progress)? onProgress,
  }) async {
    try {
      late final Response<dynamic> response;

      final String endpoint = customBaseUrl != null
          ? Uri.parse(customBaseUrl).resolve(apiRoute.path).toString()
          : apiRoute.path;

      log('Request | ${apiRoute.method} ->  $endpoint', name: 'APICLIENT');

      switch (apiRoute.method) {
        case HttpMethod.get:
          response = await dio.get(
            endpoint,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onReceiveProgress: (final int received, final int total) {
              if (onProgress != null && total != 0) {
                final double progress = received / total;
                onProgress(progress.clamp(0.0, 1.0));
              }
            },
          );
        case HttpMethod.post:
          response = await dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );

        case HttpMethod.put:
          response = await dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );

        case HttpMethod.patch:
          response = await dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );

        case HttpMethod.delete:
          response = await dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );
      }
      log(
        'Request | ${apiRoute.method} -> ${apiRoute.path} | Success',
        name: 'APICLIENT',
      );
      return right(response);
    } on DioException catch (e, st) {
      /// Only log and report DioExceptions that are not 401 Unauthorized, as
      /// 401s are expected to occur and handled in the app's authentication\
      /// flow.
      if (e.response?.statusCode != 401) {
        debugPrint('Error: $e');
        debugPrintStack(stackTrace: st);
        log(
          '''Request | ${apiRoute.method} -> ${apiRoute.path} | DioException''',
          name: 'APICLIENT',
        );
      }

      return left(handleException(e));
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      log(
        '''Request | ${apiRoute.method} -> ${apiRoute.path} | Unknown Failure''',
        name: 'APICLIENT',
      );
      return left(const ApiClientFailure.unknown());
    }
  }

  @override
  Future<Either<ApiClientFailure, Response<dynamic>>> download({
    required final String urlPath,
    required final String savePath,
    final ProgressCallback? onReceiveProgress,
    final CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> result = await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return right(result);
    } on DioException catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(handleException(e));
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const ApiClientFailure.unknown());
    }
  }

  @override
  Future<Either<ApiClientFailure, Response<dynamic>>> upload({
    required final String path,
    required final String filePath,
    final Map<String, dynamic>? data,
    final String fieldName = 'file',
    final ProgressCallback? onSendProgress,
    final CancelToken? cancelToken,
  }) async {
    try {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      final Response<dynamic> result = await dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return right(result);
    } on DioException catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(handleException(e));
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return left(const ApiClientFailure.unknown());
    }
  }

  /// Extracts and logs a readable error message from a Dio response.
  String? getBadResponseMessage(final DioException e) {
    final dynamic data = e.response?.data;

    final Map<String, dynamic>? mapData = data is Map<String, dynamic>
        ? data
        : null;

    final String? errorMessage = mapData?['message'] as String?;

    if (errorMessage != null && errorMessage.isNotEmpty) {
      log(
        'Dio Exception | Bad Response backend message received: $errorMessage',
        name: 'APICLIENT',
      );
    } else {
      log(
        'Dio Exception | Bad Response without backend message: $errorMessage',
        name: 'APICLIENT',
      );
    }

    return errorMessage;
  }

  /// Handles a [DioException] and maps it to a
  /// corresponding [ApiClientFailure].
  ApiClientFailure handleException(final DioException e) {
    log('Dio Exception | ${e.type}', name: 'APICLIENT');
    switch (e.type) {
      case DioExceptionType.badResponse:
        final String? errorMessage = getBadResponseMessage(e);
        return handleBadResponse(
          e: e,
          statusCode: e.response?.statusCode ?? 0,
          errorMessage: errorMessage,
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiClientFailure.network(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return ApiClientFailure.network(
            error: e.toString(),
            statusCode: e.response?.statusCode ?? 0,
          );
        }
        return ApiClientFailure.network(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.badCertificate:
        return ApiClientFailure.server(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.cancel:
        return ApiClientFailure.cancelled(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return ApiClientFailure.network(
            error: e.toString(),
            statusCode: e.response?.statusCode ?? 0,
          );
        }
        return ApiClientFailure.unknown(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );
    }
  }

  /// Maps an HTTP status code and message to a specific [ApiClientFailure].
  ApiClientFailure handleBadResponse({
    required final DioException? e,
    required final int statusCode,
    final String? errorMessage,
  }) {
    switch (statusCode) {
      case >= 500:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - ApiClientFailure.server''',
          name: 'APICLIENT',
        );
        return ApiClientFailure.server(
          error: e.toString(),
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
      case >= 400:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - ApiClientFailure.client''',
          name: 'APICLIENT',
        );
        return ApiClientFailure.client(
          error: e.toString(),
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
      default:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - ApiClientFailure.unknown''',
          name: 'APICLIENT',
        );
        return ApiClientFailure.unknown(
          error: e.toString(),
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
    }
  }

  @override
  void close() {
    dio.close();
  }
}
