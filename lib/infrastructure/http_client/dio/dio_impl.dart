import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';

/// Implementation of [HttpClientInterface] using
/// `dio` package.
class HttpClientDioImpl implements HttpClientInterface {
  /// Creates an instance of [HttpClientDioImpl].
  HttpClientDioImpl({required this.dio});

  /// Dio instance used to perform HTTP requests.
  final Dio dio;

  @override
  Future<Either<HttpClientFailure, HttpClientResponse<dynamic>>> request({
    required final ApiRoute apiRoute,
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final void Function(double progress)? onProgress,
  }) async {
    try {
      late final Response<dynamic> response;

      log(
        'Request | ${apiRoute.method} ->  ${apiRoute.path}',
        name: 'APICLIENT',
      );

      switch (apiRoute.method) {
        case HttpMethod.get:
          response = await dio.get(
            apiRoute.path,
            queryParameters: queryParameters,
            onReceiveProgress: (final int received, final int total) {
              if (onProgress != null && total != 0) {
                final double progress = received / total;
                onProgress(progress.clamp(0.0, 1.0));
              }
            },
          );
        case HttpMethod.post:
          response = await dio.post(
            apiRoute.path,
            data: data,
            queryParameters: queryParameters,
          );

        case HttpMethod.put:
          response = await dio.put(
            apiRoute.path,
            data: data,
            queryParameters: queryParameters,
          );

        case HttpMethod.patch:
          response = await dio.patch(
            apiRoute.path,
            data: data,
            queryParameters: queryParameters,
          );

        case HttpMethod.delete:
          response = await dio.delete(
            apiRoute.path,
            data: data,
            queryParameters: queryParameters,
          );
      }
      log(
        'Request | ${apiRoute.method} -> ${apiRoute.path} | Success',
        name: 'APICLIENT',
      );
      return right(
        HttpClientResponse<dynamic>(
          data: response.data,
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e, st) {
      log('Error: $e', name: 'HttpClientDioImpl', error: e, stackTrace: st);
      log(
        '''Request | ${apiRoute.method} -> ${apiRoute.path} | DioException''',
        name: 'APICLIENT',
      );

      return left(handleException(e));
    } on Object catch (e, st) {
      log('Error: $e', name: 'HttpClientDioImpl', error: e, stackTrace: st);
      log(
        '''Request | ${apiRoute.method} -> ${apiRoute.path} | Unknown Failure''',
        name: 'APICLIENT',
      );
      return left(const HttpClientFailure.unknown());
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
  /// corresponding [HttpClientFailure].
  HttpClientFailure handleException(final DioException e) {
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
        return HttpClientFailure.network(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        if (e.error is SocketException) {
          return HttpClientFailure.network(
            error: e.toString(),
            statusCode: e.response?.statusCode ?? 0,
          );
        }
        return HttpClientFailure.network(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.cancel:
        return HttpClientFailure.cancelled(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return HttpClientFailure.network(
            error: e.toString(),
            statusCode: e.response?.statusCode ?? 0,
          );
        }
        return HttpClientFailure.unknown(
          error: e.toString(),
          statusCode: e.response?.statusCode ?? 0,
        );
    }
  }

  /// Maps an HTTP status code and message to a specific [HttpClientFailure].
  HttpClientFailure handleBadResponse({
    required final DioException? e,
    required final int statusCode,
    final String? errorMessage,
  }) {
    switch (statusCode) {
      case >= 500:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - HttpClientFailure.server''',
          name: 'APICLIENT',
        );
        return HttpClientFailure.server(
          error: e.toString(),
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
      case >= 400:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - HttpClientFailure.client''',
          name: 'APICLIENT',
        );
        return HttpClientFailure.client(
          error: e.toString(),
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
      default:
        log(
          '''Dio Exception | Handle Bad Response - Code: $statusCode - HttpClientFailure.unknown''',
          name: 'APICLIENT',
        );
        return HttpClientFailure.unknown(
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
