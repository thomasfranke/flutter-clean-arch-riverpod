import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_interceptor_retry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(Response<dynamic>(requestOptions: RequestOptions()));
  });

  late MockDio dio;
  late MockErrorInterceptorHandler handler;
  late HttpClientDioInterceptor sut;

  // Only used to build [Response] fixtures below; never mutated.
  final RequestOptions tRequestOptions = RequestOptions(path: '/quotes');

  setUp(() {
    dio = MockDio();
    handler = MockErrorInterceptorHandler();
    sut = HttpClientDioInterceptor(dio: dio);
  });

  // `onError` mutates `requestOptions.extra['retry_attempt']` in place, so
  // each call must get its own [RequestOptions] instance — sharing one
  // across tests would leak retry-attempt state between them.
  DioException tDioException(
    final DioExceptionType type, {
    final Response<dynamic>? response,
  }) => DioException(
    requestOptions: RequestOptions(path: '/quotes'),
    type: type,
    response: response,
  );

  group('maxRetriesFn', () {
    test('returns 2 when status >= 500', () {
      final DioException e = tDioException(
        DioExceptionType.connectionError,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 503,
        ),
      );

      expect(sut.maxRetriesFn(err: e), 2);
    });

    test('returns 0 when status is between 400 and 499', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 404,
        ),
      );

      expect(sut.maxRetriesFn(err: e), 0);
    });

    test('returns 1 when there is no status code (e.g. timeout)', () {
      final DioException e = tDioException(DioExceptionType.connectionTimeout);

      expect(sut.maxRetriesFn(err: e), 1);
    });
  });

  group('shouldRetryFn', () {
    test('returns true for connectionTimeout within the attempt limit', () {
      final DioException e = tDioException(DioExceptionType.connectionTimeout);

      expect(sut.shouldRetryFn(err: e, attempt: 0, maxRetries: 1), isTrue);
    });

    test('returns false when attempt has already reached maxRetries', () {
      final DioException e = tDioException(DioExceptionType.connectionTimeout);

      expect(sut.shouldRetryFn(err: e, attempt: 1, maxRetries: 1), isFalse);
    });

    test('returns false for a 4xx error even within the limit', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 404,
        ),
      );

      expect(sut.shouldRetryFn(err: e, attempt: 0, maxRetries: 2), isFalse);
    });

    test('returns true for a 5xx error within the limit', () {
      final DioException e = tDioException(
        DioExceptionType.connectionError,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 500,
        ),
      );

      expect(sut.shouldRetryFn(err: e, attempt: 0, maxRetries: 2), isTrue);
    });

    test('returns false for cancel, even within the limit', () {
      final DioException e = tDioException(DioExceptionType.cancel);

      expect(sut.shouldRetryFn(err: e, attempt: 0, maxRetries: 2), isFalse);
    });
  });

  group('onError', () {
    test('when it should not retry, delegates to handler.next with the '
        'original error and does not call dio.fetch', () async {
      final DioException err = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 404,
        ),
      );
      when(() => handler.next(any())).thenReturn(null);

      await sut.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => dio.fetch<dynamic>(any()));
    });

    test(
      'when the retry succeeds, resolves the handler with the new response',
      () async {
        final DioException err = tDioException(
          DioExceptionType.connectionTimeout,
        );
        final Response<dynamic> retriedResponse = Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 200,
        );
        when(
          () => dio.fetch<dynamic>(any()),
        ).thenAnswer((_) async => retriedResponse);
        when(() => handler.resolve(any())).thenReturn(null);

        await sut.onError(err, handler);

        verify(() => handler.resolve(retriedResponse)).called(1);
      },
    );

    test('when the retry throws a new DioException, delegates to handler.next '
        'with the new exception', () async {
      final DioException err = tDioException(
        DioExceptionType.connectionTimeout,
      );
      final DioException retryError = tDioException(DioExceptionType.unknown);
      when(
        () => dio.fetch<dynamic>(any()),
      ).thenAnswer((_) async => throw retryError);
      when(() => handler.next(any())).thenReturn(null);

      await sut.onError(err, handler);

      verify(() => handler.next(retryError)).called(1);
    });

    test('when the retry throws a generic error, delegates to handler.next '
        'with the original error', () async {
      final DioException err = tDioException(
        DioExceptionType.connectionTimeout,
      );
      when(() => dio.fetch<dynamic>(any())).thenThrow(Exception('boom'));
      when(() => handler.next(any())).thenReturn(null);

      await sut.onError(err, handler);

      verify(() => handler.next(err)).called(1);
    });
  });
}
