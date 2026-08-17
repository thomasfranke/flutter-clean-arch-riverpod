import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StorageFailureMapper.toDomainFailure', () {
    for (final StorageFailure failure in <StorageFailure>[
      const StorageFailure.write(),
      const StorageFailure.read(),
      const StorageFailure.remove(),
      const StorageFailure.clear(),
      const StorageFailure.unexpected(),
    ]) {
      test('$failure maps to Failure.storage', () {
        expect(failure.toDomainFailure(), const Failure.storage());
      });
    }
  });
}
