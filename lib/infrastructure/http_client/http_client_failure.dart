import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_client_failure.freezed.dart';

/// Abstract class for HTTP Client Failures.
///
/// Carries primitives only. It crosses into `data/` through
/// `HttpClientInterface`, so a Dio type here is Dio in every datasource.
@freezed
sealed class HttpClientFailure with _$HttpClientFailure implements Exception {
  const factory HttpClientFailure.network({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientNetworkFailure;
  const factory HttpClientFailure.client({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientClientFailure;
  const factory HttpClientFailure.server({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientServerFailure;
  const factory HttpClientFailure.unknown({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientUnknownFailure;
  const factory HttpClientFailure.parse() = HttpClientParseFailure;
  const factory HttpClientFailure.notFound({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientNotFoundFailure;
  const factory HttpClientFailure.cancelled({
    final String? error,
    final String? errorMessage,
    final int? statusCode,
  }) = HttpClientCancelledFailure;
}
