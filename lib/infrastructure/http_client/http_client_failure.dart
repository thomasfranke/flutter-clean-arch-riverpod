import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_client_failure.freezed.dart';

/// Abstract class for HTTP Client Failures.
@freezed
sealed class HttpClientFailure with _$HttpClientFailure implements Exception {
  const factory HttpClientFailure.network({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientNetworkFailure;
  const factory HttpClientFailure.client({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientClientFailure;
  const factory HttpClientFailure.server({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientServerFailure;
  const factory HttpClientFailure.unknown({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientUnknownFailure;
  const factory HttpClientFailure.parse() = HttpClientParseFailure;
  const factory HttpClientFailure.notFound({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientNotFoundFailure;
  const factory HttpClientFailure.cancelled({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = HttpClientCancelledFailure;
}

/// Maps an [HttpClientFailure] from the infrastructure layer
/// to a [Failure] in the domain layer.
extension HttpClientFailureMapper on HttpClientFailure {
  /// Converts infrastructure failure into a domain failure.
  Failure toDomainFailure() => switch (this) {
    /// Network-related failures (no response from server)
    HttpClientNetworkFailure(:final String? errorMessage) => Failure.apiNetwork(
      errorMessage,
    ),
    HttpClientCancelledFailure(:final String? errorMessage) =>
      Failure.apiNetwork(errorMessage),

    /// Server-related failures (valid HTTP response but indicates an error)
    HttpClientClientFailure(:final String? errorMessage) => Failure.apiClient(
      errorMessage,
    ),

    HttpClientNotFoundFailure(:final String? errorMessage) =>
      Failure.apiNotFound(errorMessage),

    /// Server errors (server processed request but failed)
    HttpClientServerFailure(:final String? errorMessage) => Failure.apiServer(
      errorMessage,
    ),
    HttpClientParseFailure() => const Failure.parse(),
    HttpClientUnknownFailure(:final String? errorMessage) => Failure.apiServer(
      errorMessage,
    ),
  };
}
