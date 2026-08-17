import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('preferencesRepositoryProvider builds a PreferencesRepositoryImpl using '
      'the real datasource', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final StorageInterface storage = await SharedPreferencesImpl.create();

    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[storageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final PreferencesRepository repository = container.read(
      preferencesRepositoryProvider,
    );

    expect(repository, isA<PreferencesRepositoryImpl>());
    expect(
      preferencesRepositoryProvider.overrideWithValue(repository),
      isNotNull,
    );
  });
}
