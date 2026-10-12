// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_repository_impl_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [KlineRepositoryInterface] implementation.

@ProviderFor(klineRepository)
final klineRepositoryProvider = KlineRepositoryProvider._();

/// Provides the [KlineRepositoryInterface] implementation.

final class KlineRepositoryProvider
    extends
        $FunctionalProvider<
          KlineRepositoryInterface,
          KlineRepositoryInterface,
          KlineRepositoryInterface
        >
    with $Provider<KlineRepositoryInterface> {
  /// Provides the [KlineRepositoryInterface] implementation.
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
  $ProviderElement<KlineRepositoryInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KlineRepositoryInterface create(Ref ref) {
    return klineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KlineRepositoryInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KlineRepositoryInterface>(value),
    );
  }
}

String _$klineRepositoryHash() => r'e088dbbdc9a75197b10be3bda6a12379444a2aec';
