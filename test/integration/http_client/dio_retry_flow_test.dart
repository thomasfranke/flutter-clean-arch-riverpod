import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/dio/dio_interceptor_retry.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';
import 'package:flutter_test/flutter_test.dart';

/// A local HTTP server that returns the queued status codes in order (200
/// once the queue is drained), used to exercise the real
/// [HttpClientDioInterceptor] retry logic end to end — no fakes anywhere in
/// this file, unlike the other integration tests that fake the HTTP
/// boundary via `FakeHttpClientInterface`.
class _ScriptedServer {
  _ScriptedServer._(this._server, this._responses);

  final HttpServer _server;
  final List<int> _responses;

  /// Total number of requests the server has received.
  int requestCount = 0;

  static Future<_ScriptedServer> start(final List<int> statusSequence) async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final _ScriptedServer scripted = _ScriptedServer._(
      server,
      List<int>.from(statusSequence),
    );

    server.listen((final HttpRequest request) async {
      scripted.requestCount++;
      final int status = scripted._responses.isNotEmpty
          ? scripted._responses.removeAt(0)
          : 200;

      request.response.statusCode = status;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(<String, dynamic>{'status': status}));
      await request.response.close();
    });

    return scripted;
  }

  Uri get baseUrl => Uri(
    scheme: 'http',
    host: _server.address.address,
    port: _server.port,
  );

  Future<void> close() => _server.close(force: true);
}

/// A real [HttpClientDioImpl] wired with the real [HttpClientDioInterceptor]
/// against [server], matching how `http_client_di.dart` wires them in the
/// app — only the base URL is redirected to the local test server.
HttpClientInterface _buildRealClient(final _ScriptedServer server) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: server.baseUrl.toString(),
      validateStatus: (final int? status) =>
          status != null && status >= 200 && status < 300,
    ),
  );
  dio.interceptors.add(HttpClientDioInterceptor(dio: dio));
  return HttpClientDioImpl(dio: dio);
}

void main() {
  group('Dio retry interceptor integration flow (real HTTP, no fakes)', () {
    test(
      'a transient 5xx is retried and the eventual 200 is returned to the '
      'caller',
      () async {
        final _ScriptedServer server = await _ScriptedServer.start(
          <int>[500, 200],
        );
        addTearDown(server.close);
        final HttpClientInterface client = _buildRealClient(server);

        final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
            await client.request(
              apiRoute: const ApiRoute('/ping', HttpMethod.get),
            );

        expect(result.isRight(), isTrue);
        expect(server.requestCount, 2);
      },
    );

    test(
      'a persistent 5xx exhausts retries (1 initial + 2 retries) and '
      'surfaces as Failure.apiServer',
      () async {
        final _ScriptedServer server = await _ScriptedServer.start(
          <int>[500, 500, 500],
        );
        addTearDown(server.close);
        final HttpClientInterface client = _buildRealClient(server);

        final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
            await client.request(
              apiRoute: const ApiRoute('/ping', HttpMethod.get),
            );

        expect(
          result.leftMap((final HttpClientFailure f) => f.toDomainFailure()),
          const Left<Failure, HttpClientResponse<dynamic>>(
            Failure.apiServer(),
          ),
        );
        expect(server.requestCount, 3);
      },
    );

    test(
      'a 4xx is not retried at all and surfaces as Failure.apiClient after '
      'a single request',
      () async {
        final _ScriptedServer server = await _ScriptedServer.start(
          <int>[404],
        );
        addTearDown(server.close);
        final HttpClientInterface client = _buildRealClient(server);

        final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
            await client.request(
              apiRoute: const ApiRoute('/ping', HttpMethod.get),
            );

        expect(
          result.leftMap((final HttpClientFailure f) => f.toDomainFailure()),
          const Left<Failure, HttpClientResponse<dynamic>>(
            Failure.apiClient(),
          ),
        );
        expect(server.requestCount, 1);
      },
    );
  });
}
