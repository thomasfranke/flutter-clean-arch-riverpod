import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';

/// A programmable double of [HttpClientInterface] — the true external
/// boundary between `data/data_sources` and the network. Everything from
/// the datasources up to the use cases stays the real implementation; only
/// this network edge is faked, mirroring how the storage-flow integration
/// tests fake `shared_preferences`'s platform channel instead of the
/// `StorageInterface` contract itself.
class FakeHttpClientInterface implements HttpClientInterface {
  final List<Either<HttpClientFailure, HttpClientResponse<dynamic>>>
  _responses = <Either<HttpClientFailure, HttpClientResponse<dynamic>>>[];

  /// Every [ApiRoute] passed to [request], in call order.
  final List<ApiRoute> requestedRoutes = <ApiRoute>[];

  /// Every query parameter map passed to [request], aligned by index with
  /// [requestedRoutes].
  final List<Map<String, dynamic>?> requestedQueryParameters =
      <Map<String, dynamic>?>[];

  /// Queues a successful response with the given [data] and [statusCode]
  /// for the next call to [request].
  void enqueueSuccess(final dynamic data, {final int statusCode = 200}) {
    _responses.add(
      Right<HttpClientFailure, HttpClientResponse<dynamic>>(
        HttpClientResponse<dynamic>(data: data, statusCode: statusCode),
      ),
    );
  }

  /// Queues a [failure] for the next call to [request].
  void enqueueFailure(final HttpClientFailure failure) {
    _responses.add(
      Left<HttpClientFailure, HttpClientResponse<dynamic>>(failure),
    );
  }

  @override
  Future<Either<HttpClientFailure, HttpClientResponse<dynamic>>> request({
    required final ApiRoute apiRoute,
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final void Function(double progress)? onProgress,
  }) async {
    requestedRoutes.add(apiRoute);
    requestedQueryParameters.add(queryParameters);

    if (_responses.isEmpty) {
      throw StateError(
        'FakeHttpClientInterface: no response queued for '
        '${apiRoute.method} ${apiRoute.path}',
      );
    }

    return _responses.removeAt(0);
  }

  @override
  void close() {}
}
