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
