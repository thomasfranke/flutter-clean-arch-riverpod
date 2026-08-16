import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_datasource_di.g.dart';

/// Provides a Riverpod provider for the [FavoritesDatasource].
@riverpod
FavoritesDatasource favoritesDatasource(final Ref ref) =>
    FavoritesDatasource(storage: ref.watch(storageProvider));
