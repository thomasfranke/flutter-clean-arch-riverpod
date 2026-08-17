import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';

/// Abstract interface for HTTP client. Deliberately framework-agnostic: no
/// method here should expose types from a specific HTTP client package (e.g.
/// `dio`), so consumers in the data layer don't need to depend on it.
abstract interface class HttpClientInterface {
  /// Request.
  Future<Either<HttpClientFailure, HttpClientResponse<dynamic>>> request({
    required final ApiRoute apiRoute,
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final void Function(double progress)? onProgress,
  });

  /// Close the HTTP client.
  void close();
}
