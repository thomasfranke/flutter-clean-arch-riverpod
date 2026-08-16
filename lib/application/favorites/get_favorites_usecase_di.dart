import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_favorites_usecase_di.g.dart';

/// Provides the [GetFavoritesUseCase].
@riverpod
GetFavoritesUseCase getFavoritesUseCase(final Ref ref) =>
    GetFavoritesUseCase(repository: ref.watch(favoritesRepositoryProvider));
