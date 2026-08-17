import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('favoritesDatasourceProvider builds a FavoritesDatasource using the '
      'real StorageInterface', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final StorageInterface storage = await SharedPreferencesImpl.create();

    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[storageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final FavoritesDatasource datasource = container.read(
      favoritesDatasourceProvider,
    );

    expect(datasource, isA<FavoritesDatasource>());
    expect(
      favoritesDatasourceProvider.overrideWithValue(datasource),
      isNotNull,
    );
  });
}
