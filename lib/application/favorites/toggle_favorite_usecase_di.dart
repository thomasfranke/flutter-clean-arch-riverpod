import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toggle_favorite_usecase_di.g.dart';

/// Provides the [ToggleFavoriteUseCase].
@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(final Ref ref) =>
    ToggleFavoriteUseCase(repository: ref.watch(favoritesRepositoryProvider));
