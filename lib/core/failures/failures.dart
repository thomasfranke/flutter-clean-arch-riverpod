import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Domain failures that can be returned by repositories.
@freezed
sealed class Failure with _$Failure implements Exception {
  /// -- Domain Failures --

  /// -- Infra Failures --
  /// - Api Client:
  const factory Failure.apiClient([final String? e]) = ApiClientDomainFailure;
  const factory Failure.apiNotFound([final String? e]) =
      ApiClientNotFoundDomainFailure;
  const factory Failure.apiNetwork([final String? e]) = ApiNetworkDomainFailure;
  const factory Failure.apiServer([final String? e]) = ApiServerDomainFailure;

  /// - Parse:
  const factory Failure.parse() = ParseDomainFailure;

  /// - Storage:
  const factory Failure.storage() = SharedPreferencesDomainFailure;

  /// -- Default Failures --
  /// - Unexpected
  const factory Failure.unexpected([final String? e]) = UnexpectedDomainFailure;
}
