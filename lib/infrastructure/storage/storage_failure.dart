import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_failure.freezed.dart';

/// Abstract class for Storage failures.
@freezed
sealed class StorageFailure with _$StorageFailure implements Exception {
  const factory StorageFailure.write() = StorageWriteFailure;

  const factory StorageFailure.read() = StorageReadFailure;

  const factory StorageFailure.remove() = StorageRemoveFailure;

  const factory StorageFailure.clear() = StorageClearFailure;

  const factory StorageFailure.unexpected() = StorageUnexpectedFailure;
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
