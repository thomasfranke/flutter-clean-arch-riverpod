import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_repository_impl_di.g.dart';

/// Riverpod provider for the [FavoritesRepositoryImpl].
@riverpod
FavoritesRepository favoritesRepository(Ref ref) =>
    FavoritesRepositoryImpl(datasource: ref.watch(favoritesDatasourceProvider));
