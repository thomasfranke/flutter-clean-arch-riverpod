import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('storageProvider throws UnimplementedError when not overridden, since '
      "it must be provided by the app's bootstrap", () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(storageProvider),
      throwsA(
        predicate<Object>(
          (final Object e) => e.toString().contains('UnimplementedError'),
        ),
      ),
    );
  });

  test(
    'storageProvider uses the implementation provided via override',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final StorageInterface storage = await SharedPreferencesImpl.create();

      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[storageProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      expect(container.read(storageProvider), same(storage));
    },
  );
}
