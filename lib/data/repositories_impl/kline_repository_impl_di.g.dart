// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_repository_impl_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [KlineRepository] implementation.

@ProviderFor(klineRepository)
final klineRepositoryProvider = KlineRepositoryProvider._();

/// Provides the [KlineRepository] implementation.

final class KlineRepositoryProvider
    extends
        $FunctionalProvider<KlineRepository, KlineRepository, KlineRepository>
    with $Provider<KlineRepository> {
  /// Provides the [KlineRepository] implementation.
  KlineRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'klineRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$klineRepositoryHash();

  @$internal
  @override
  $ProviderElement<KlineRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KlineRepository create(Ref ref) {
    return klineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KlineRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KlineRepository>(value),
    );
  }
}

String _$klineRepositoryHash() => r'a9e189529fffdc30de7ce4cb17518828f01af9c5';
