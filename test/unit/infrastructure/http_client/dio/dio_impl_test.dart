import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late HttpClientDioImpl sut;

  final RequestOptions tRequestOptions = RequestOptions(path: '/quotes');

  setUp(() {
    dio = MockDio();
    sut = HttpClientDioImpl(dio: dio);
  });

  DioException tDioException(
    final DioExceptionType type, {
    final Response<dynamic>? response,
    final Object? error,
  }) => DioException(
    requestOptions: tRequestOptions,
    type: type,
    response: response,
    error: error,
  );

  group('handleException', () {
    test('badResponse with status >= 500 maps to HttpClientFailure.server', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 503,
        ),
      );

      expect(sut.handleException(e), isA<HttpClientServerFailure>());
    });

    test('badResponse with status >= 400 maps to HttpClientFailure.client', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 404,
        ),
      );

      expect(sut.handleException(e), isA<HttpClientClientFailure>());
    });

    test('badResponse with an error message in the body is extracted and '
        'propagated', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 404,
          data: <String, dynamic>{'message': 'symbol not found'},
        ),
      );

      final HttpClientFailure failure = sut.handleException(e);

      expect(
        (failure as HttpClientClientFailure).errorMessage,
        'symbol not found',
      );
    });

    test('badResponse with status outside known ranges maps to '
        'HttpClientFailure.unknown', () {
      final DioException e = tDioException(
        DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 302,
        ),
      );

      expect(sut.handleException(e), isA<HttpClientUnknownFailure>());
    });

    for (final DioExceptionType type in <DioExceptionType>[
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      test('$type maps to HttpClientFailure.network', () {
        expect(
          sut.handleException(tDioException(type)),
          isA<HttpClientNetworkFailure>(),
        );
      });
    }

    test('connectionError maps to HttpClientFailure.network', () {
      final DioException e = tDioException(DioExceptionType.connectionError);

      expect(sut.handleException(e), isA<HttpClientNetworkFailure>());
    });

    test('connectionError with SocketException also maps to '
        'HttpClientFailure.network', () {
      final DioException e = tDioException(
        DioExceptionType.connectionError,
        error: const SocketException('no network'),
      );

      expect(sut.handleException(e), isA<HttpClientNetworkFailure>());
    });

    test('badCertificate maps to HttpClientFailure.network (client '
        'connectivity/security failure, not a server error)', () {
      final DioException e = tDioException(DioExceptionType.badCertificate);

      expect(sut.handleException(e), isA<HttpClientNetworkFailure>());
    });

    test('cancel maps to HttpClientFailure.cancelled', () {
      final DioException e = tDioException(DioExceptionType.cancel);

      expect(sut.handleException(e), isA<HttpClientCancelledFailure>());
    });

    test('unknown with SocketException maps to HttpClientFailure.network', () {
      final DioException e = tDioException(
        DioExceptionType.unknown,
        error: const SocketException('connection failure'),
      );

      expect(sut.handleException(e), isA<HttpClientNetworkFailure>());
    });

    test(
      'unknown without SocketException maps to HttpClientFailure.unknown',
      () {
        final DioException e = tDioException(
          DioExceptionType.unknown,
          error: Exception('some error'),
        );

        expect(sut.handleException(e), isA<HttpClientUnknownFailure>());
      },
    );
  });

  group('handleBadResponse', () {
    test('status 500 maps to HttpClientFailure.server', () {
      final HttpClientFailure failure = sut.handleBadResponse(
        e: null,
        statusCode: 500,
      );

      expect(failure, isA<HttpClientServerFailure>());
    });

    test('status 400 maps to HttpClientFailure.client', () {
      final HttpClientFailure failure = sut.handleBadResponse(
        e: null,
        statusCode: 400,
      );

      expect(failure, isA<HttpClientClientFailure>());
    });

    test('status 399 maps to HttpClientFailure.unknown', () {
      final HttpClientFailure failure = sut.handleBadResponse(
        e: null,
        statusCode: 399,
      );

      expect(failure, isA<HttpClientUnknownFailure>());
    });

    test('propagates the received errorMessage', () {
      final HttpClientFailure failure = sut.handleBadResponse(
        e: null,
        statusCode: 404,
        errorMessage: 'symbol not found',
      );

      expect(
        (failure as HttpClientClientFailure).errorMessage,
        'symbol not found',
      );
    });
  });

  group('request', () {
    const ApiRoute tRoute = ApiRoute('/api/v3/ticker/24hr', HttpMethod.get);

    test('on success, wraps the Dio Response in HttpClientResponse', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 200,
          data: <String, dynamic>{'symbol': 'BTCUSDT'},
        ),
      );

      final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
          await sut.request(apiRoute: tRoute);

      expect(result.isRight(), isTrue);
      final HttpClientResponse<dynamic> response = result.getOrElse(
        () => throw StateError('expected Right'),
      );
      expect(response.statusCode, 200);
      expect(response.data, <String, dynamic>{'symbol': 'BTCUSDT'});
    });

    test("invokes onProgress from Dio's onReceiveProgress, ignoring "
        'callbacks with total == 0', () async {
      double? capturedProgress;
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((final Invocation invocation) async {
        final void Function(int, int)? onReceiveProgress =
            invocation.namedArguments[#onReceiveProgress]
                as void Function(int, int)?;
        onReceiveProgress?.call(10, 0);
        onReceiveProgress?.call(50, 100);
        return Response<dynamic>(
          requestOptions: tRequestOptions,
          statusCode: 200,
        );
      });

      await sut.request(
        apiRoute: tRoute,
        onProgress: (final double progress) => capturedProgress = progress,
      );

      expect(capturedProgress, 0.5);
    });

    test(
      'sends POST/PUT/PATCH/DELETE requests to the correct method',
      () async {
        for (final (HttpMethod method, String label) in <(HttpMethod, String)>[
          (HttpMethod.post, 'post'),
          (HttpMethod.put, 'put'),
          (HttpMethod.patch, 'patch'),
          (HttpMethod.delete, 'delete'),
        ]) {
          final ApiRoute route = ApiRoute('/orders', method);
          final Response<dynamic> tResponse = Response<dynamic>(
            requestOptions: tRequestOptions,
            statusCode: 200,
            data: label,
          );

          switch (method) {
            case HttpMethod.post:
              when(
                () => dio.post<dynamic>(
                  any(),
                  data: any(named: 'data'),
                  queryParameters: any(named: 'queryParameters'),
                ),
              ).thenAnswer((_) async => tResponse);
            case HttpMethod.put:
              when(
                () => dio.put<dynamic>(
                  any(),
                  data: any(named: 'data'),
                  queryParameters: any(named: 'queryParameters'),
                ),
              ).thenAnswer((_) async => tResponse);
            case HttpMethod.patch:
              when(
                () => dio.patch<dynamic>(
                  any(),
                  data: any(named: 'data'),
                  queryParameters: any(named: 'queryParameters'),
                ),
              ).thenAnswer((_) async => tResponse);
            case HttpMethod.delete:
              when(
                () => dio.delete<dynamic>(
                  any(),
                  data: any(named: 'data'),
                  queryParameters: any(named: 'queryParameters'),
                ),
              ).thenAnswer((_) async => tResponse);
            case HttpMethod.get:
              break;
          }

          final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
              await sut.request(apiRoute: route, data: <String, dynamic>{});

          expect(
            result.getOrElse(() => throw StateError('expected Right')).data,
            label,
          );
        }
      },
    );

    test('on DioException, returns Left with the mapped failure', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenThrow(tDioException(DioExceptionType.connectionTimeout));

      final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
          await sut.request(apiRoute: tRoute);

      expect(result.isLeft(), isTrue);
      expect(
        result.fold((final HttpClientFailure f) => f, (_) => null),
        isA<HttpClientNetworkFailure>(),
      );
    });

    test(
      'on a generic exception, returns Left with HttpClientFailure.unknown',
      () async {
        when(
          () => dio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).thenThrow(Exception('boom'));

        final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
            await sut.request(apiRoute: tRoute);

        expect(result.isLeft(), isTrue);
        expect(
          result.fold((final HttpClientFailure f) => f, (_) => null),
          isA<HttpClientUnknownFailure>(),
        );
      },
    );
  });

  group('close', () {
    test('delegates to the underlying Dio', () {
      when(() => dio.close()).thenReturn(null);

      sut.close();

      verify(() => dio.close()).called(1);
    });
  });
}
