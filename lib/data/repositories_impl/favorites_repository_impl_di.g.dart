// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_repository_impl_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [FavoritesRepositoryImpl].

@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = FavoritesRepositoryProvider._();

/// Riverpod provider for the [FavoritesRepositoryImpl].

final class FavoritesRepositoryProvider
    extends
        $FunctionalProvider<
          FavoritesRepositoryInterface,
          FavoritesRepositoryInterface,
          FavoritesRepositoryInterface
        >
    with $Provider<FavoritesRepositoryInterface> {
  /// Riverpod provider for the [FavoritesRepositoryImpl].
  FavoritesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoritesRepositoryInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesRepositoryInterface create(Ref ref) {
    return favoritesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesRepositoryInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesRepositoryInterface>(value),
    );
  }
}

String _$favoritesRepositoryHash() =>
    r'f85c9dbfb1cbe26c786c97a4e751185343e9efe1';
