import 'dart:developer';

import 'package:dio/dio.dart';

/// Custom `Dio` interceptor for handling API errors.
class HttpClientDioInterceptor extends Interceptor {
  /// Creates an [HttpClientDioInterceptor] with the given [dio] instance.
  HttpClientDioInterceptor({required this.dio});

  /// The `Dio` instance used for making and managing HTTP requests.
  final Dio dio;

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    log('Interceptor Error | Error received.', name: 'APICLIENT');
    final int maxRetries = maxRetriesFn(err: err);

    int attempt = err.requestOptions.extra['retry_attempt'] ?? 0;

    log(
      'Interceptor Error | Retry attempts tried: $attempt/$maxRetries.',
      name: 'APICLIENT',
    );

    final bool shouldRetry = shouldRetryFn(
      err: err,
      attempt: attempt,
      maxRetries: maxRetries,
    );

    if (shouldRetry) {
      attempt++;

      log(
        'Interceptor Error | Trying again, attempt $attempt.',
        name: 'APICLIENT',
      );
      err.requestOptions.extra['retry_attempt'] = attempt;

      final Duration delay = const Duration(milliseconds: 300) * attempt;
      await Future<dynamic>.delayed(delay);

      log(
        '''Interceptor Error | Trying again in ${delay.inMilliseconds} milliseconds.''',
        name: 'APICLIENT',
      );
      try {
        final Response<dynamic> response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e, st) {
        log(
          'Retry failed with DioException: $e',
          name: 'HttpClientDioInterceptor',
          error: e,
          stackTrace: st,
        );
        return handler.next(e);
      } on Object catch (e, st) {
        log(
          'Error: $e',
          name: 'HttpClientDioInterceptor',
          error: e,
          stackTrace: st,
        );
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Determines the maximum number of retries allowed for the given error.
  int maxRetriesFn({required final DioException err}) {
    if (err.response?.statusCode != null && err.response!.statusCode! >= 500) {
      log(
        '''Interceptor Error | Max Retries: Error 5xx (${err.response!.statusCode}) -> 2.''',
        name: 'APICLIENT',
      );
      return 2;
    }

    if (err.response?.statusCode != null && err.response!.statusCode! >= 400) {
      log(
        '''Interceptor Error | Max Retries: Error 4xx (${err.response!.statusCode}) -> 0.''',
        name: 'APICLIENT',
      );
      return 0;
    }

    log('Interceptor Error | Max Retries -> 1.', name: 'APICLIENT');
    return 1;
  }

  /// Checks whether the request should be retried based on error and attempts.
  bool shouldRetryFn({
    required final DioException err,
    required final int attempt,
    required final int maxRetries,
  }) {
    final bool shouldRetry =
        (attempt < maxRetries) &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            (err.response?.statusCode != null &&
                err.response!.statusCode! >= 500));

    log('Interceptor Error | Should retry? $shouldRetry', name: 'APICLIENT');

    return shouldRetry;
  }
}
