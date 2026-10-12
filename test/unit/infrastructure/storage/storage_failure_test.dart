import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StorageFailure', () {
    test('should be an Exception, so a caught one is still a failure', () {
      expect(const StorageFailure.read(), isA<Exception>());
    });

    test('should name a distinct type for every operation', () {
      // One case per thing storage can be asked to do. The repository maps
      // all five onto Failure.storage today, and keeps the distinction
      // because the layer below is the last one that still has it.
      expect(const StorageFailure.write(), isA<StorageWriteFailure>());
      expect(const StorageFailure.read(), isA<StorageReadFailure>());
      expect(const StorageFailure.remove(), isA<StorageRemoveFailure>());
      expect(const StorageFailure.clear(), isA<StorageClearFailure>());
      expect(
        const StorageFailure.unexpected(),
        isA<StorageUnexpectedFailure>(),
      );
    });

    test('should tell two operations apart', () {
      expect(const StorageFailure.read(), isNot(const StorageFailure.write()));
    });

    test('should be equal to another of the same operation', () {
      expect(const StorageFailure.read(), const StorageFailure.read());
      expect(
        const StorageFailure.read().hashCode,
        const StorageFailure.read().hashCode,
      );
    });

    test('should carry no message, by design', () {
      // Unlike HttpClientFailure there is nothing to carry: SharedPreferences
      // answers with a bool, so a failed write reports that it failed and
      // nothing more.
      expect(const StorageFailure.write(), isA<StorageWriteFailure>());
    });
  });
}
