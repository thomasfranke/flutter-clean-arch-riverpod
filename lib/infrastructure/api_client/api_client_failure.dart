import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_client_failure.freezed.dart';

/// Abstract class for Api Client Failures.
@freezed
sealed class ApiClientFailure with _$ApiClientFailure implements Exception {
  const factory ApiClientFailure.network({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientNetworkFailure;
  const factory ApiClientFailure.client({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientClientFailure;
  const factory ApiClientFailure.server({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientServerFailure;
  const factory ApiClientFailure.unknown({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientUnknownFailure;
  const factory ApiClientFailure.parse() = ApiClientParseFailure;
  const factory ApiClientFailure.notFound({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientNotFoundFailure;
  const factory ApiClientFailure.cancelled({
    final String? error,
    final String? errorMessage,
    final Response<dynamic>? response,
    final int? statusCode,
  }) = ApiClientCancelledFailure;
}

/// Maps an [ApiClientFailure] from the infrastructure layer
/// to a [Failure] in the domain layer.
extension ApiClientFailureMapper on ApiClientFailure {
  /// Converts infrastructure failure into a domain failure.
  Failure toDomainFailure() => switch (this) {
    /// Network-related failures (no response from server)
    ApiClientNetworkFailure(:final String? errorMessage) => Failure.apiNetwork(
      errorMessage,
    ),
    ApiClientCancelledFailure(:final String? errorMessage) =>
      Failure.apiNetwork(errorMessage),

    /// Server-related failures (valid HTTP response but indicates an error)
    ApiClientClientFailure(:final String? errorMessage) => Failure.apiClient(
      errorMessage,
    ),

    ApiClientNotFoundFailure(:final String? errorMessage) =>
      Failure.apiNotFound(errorMessage),

    /// Server errors (server processed request but failed)
    ApiClientServerFailure(:final String? errorMessage) => Failure.apiServer(
      errorMessage,
    ),
    ApiClientParseFailure() => const Failure.parse(),
    ApiClientUnknownFailure(:final String? errorMessage) => Failure.apiServer(
      errorMessage,
    ),
  };
}
