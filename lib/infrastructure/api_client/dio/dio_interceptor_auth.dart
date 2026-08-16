import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/dio/dio_interceptor_fn.dart';

/// Interceptor responsible for handling authentication errors (401),
/// refreshing tokens and triggering logout when refresh fails.
class ApiClientDioAuthInterceptor extends Interceptor {
  /// Creates an instance of [ApiClientDioAuthInterceptor].
  ApiClientDioAuthInterceptor({
    required this.dio,
    required this.refreshToken,
    required this.logout,
  });

  /// Dio instance used to retry the original request.
  final Dio dio;

  /// Function that attempts to refresh the token.
  /// Returns true if refresh succeeds, false otherwise.
  final RefreshTokenFn refreshToken;

  /// Function that performs logout when refresh fails.
  final LogoutFn logout;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = <_QueuedRequest>[];

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final int? statusCode = err.response?.statusCode;

    if (statusCode != 401) {
      return handler.next(err);
    }

    final RequestOptions requestOptions = err.requestOptions;

    log(
      'Auth Interceptor | 401 received for ${requestOptions.path}',
      name: 'APICLIENT',
    );

    if (requestOptions.extra['skipAuthRefresh'] == true) {
      log(
        'Auth Interceptor | skipAuthRefresh flag detected. Logging out.',
        name: 'APICLIENT',
      );
      await logout();
      return handler.reject(err);
    }

    /// Avoid infinite retry loop
    if (requestOptions.extra['retried'] == true) {
      log(
        'Auth Interceptor | Request already retried. Logging out.',
        name: 'APICLIENT',
      );
      await logout();
      return handler.reject(err);
    }

    /// If a refresh is already in progress, queue the request
    if (_isRefreshing) {
      log(
        'Auth Interceptor | Refresh in progress. Queueing request.',
        name: 'APICLIENT',
      );

      _queue.add(_QueuedRequest(requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      log('Auth Interceptor | Attempting token refresh.', name: 'APICLIENT');
      final bool refreshed = await refreshToken();

      if (!refreshed) {
        log(
          'Auth Interceptor | Token refresh expired. Logging out.',
          name: 'APICLIENT',
        );
        await logout();

        for (final _QueuedRequest queued in _queue) {
          queued.handler.reject(err);
        }
        _queue.clear();

        return handler.reject(err);
      }

      log(
        'Token refresh succeeded. Retrying request.',
        name: 'APICLIENT | Auth Interceptor',
      );
      final Response<dynamic> response = await _retry(requestOptions);
      handler.resolve(response);

      for (final _QueuedRequest queued in _queue) {
        try {
          final Response<dynamic> queuedResponse = await _retry(
            queued.requestOptions,
          );
          queued.handler.resolve(queuedResponse);
        } on Object catch (e, st) {
          debugPrint('Error: $e');
          debugPrintStack(stackTrace: st);
          queued.handler.reject(err);
        }
      }

      _queue.clear();
    } on Object catch (e, st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      log('Auth Interceptor | Refresh failed. Logging out.', name: 'APICLIENT');

      await logout();

      for (final _QueuedRequest queued in _queue) {
        queued.handler.reject(err);
      }
      _queue.clear();

      handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Retries the original request with the new token.
  Future<Response<dynamic>> _retry(final RequestOptions requestOptions) =>
      dio.fetch(
        requestOptions.copyWith(
          extra: <String, dynamic>{...requestOptions.extra, 'retried': true},
        ),
      );
}

class _QueuedRequest {
  _QueuedRequest(this.requestOptions, this.handler);

  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
}
