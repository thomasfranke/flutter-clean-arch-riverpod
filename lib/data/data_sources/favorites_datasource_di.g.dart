// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_datasource_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a Riverpod provider for the [FavoritesDatasource].

@ProviderFor(favoritesDatasource)
final favoritesDatasourceProvider = FavoritesDatasourceProvider._();

/// Provides a Riverpod provider for the [FavoritesDatasource].

final class FavoritesDatasourceProvider
    extends
        $FunctionalProvider<
          FavoritesDatasource,
          FavoritesDatasource,
          FavoritesDatasource
        >
    with $Provider<FavoritesDatasource> {
  /// Provides a Riverpod provider for the [FavoritesDatasource].
  FavoritesDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesDatasourceHash();

  @$internal
  @override
  $ProviderElement<FavoritesDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesDatasource create(Ref ref) {
    return favoritesDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesDatasource>(value),
    );
  }
}

String _$favoritesDatasourceHash() =>
    r'a25b4a085bd2881356709139bc213078bd763a30';
