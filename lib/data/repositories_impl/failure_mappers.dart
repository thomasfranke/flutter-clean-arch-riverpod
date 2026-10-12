import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';

// The translation from infrastructure's failures to the domain's lives in
// `data/`, beside the repositories that call it, not in `infrastructure/`
// beside the failures it reads. Written there, it made `infrastructure/`
// import the domain's vocabulary — the one thing the layer below a
// repository is not obliged to know.

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

/// Maps an [StorageFailure] from the infrastructure layer
/// to a [Failure] in the domain layer.
extension StorageFailureMapper on StorageFailure {
  /// Converts infrastructure failure into a domain failure.
  Failure toDomainFailure() => switch (this) {
    StorageWriteFailure() => const Failure.storage(),
    StorageReadFailure() => const Failure.storage(),
    StorageRemoveFailure() => const Failure.storage(),
    StorageClearFailure() => const Failure.storage(),
    StorageUnexpectedFailure() => const Failure.storage(),
  };
}
