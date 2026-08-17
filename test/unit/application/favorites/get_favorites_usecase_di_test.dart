import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('getFavoritesUseCaseProvider builds a GetFavoritesUseCase using the '
      'real repository', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final StorageInterface storage = await SharedPreferencesImpl.create();

    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[storageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    expect(
      container.read(getFavoritesUseCaseProvider),
      isA<GetFavoritesUseCase>(),
    );
  });
}
