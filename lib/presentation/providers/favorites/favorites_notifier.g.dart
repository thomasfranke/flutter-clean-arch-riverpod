// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing the state of favorite cryptocurrencies.
///
/// Responsible only for loading and toggling favorites from storage.
/// Does not interact with the API — crypto quote data is managed separately
/// by CryptoQuoteNotifier.

@ProviderFor(FavoritesNotifier)
final favoritesProvider = FavoritesNotifierProvider._();

/// Notifier for managing the state of favorite cryptocurrencies.
///
/// Responsible only for loading and toggling favorites from storage.
/// Does not interact with the API — crypto quote data is managed separately
/// by CryptoQuoteNotifier.
final class FavoritesNotifierProvider
    extends $NotifierProvider<FavoritesNotifier, FavoritesState> {
  /// Notifier for managing the state of favorite cryptocurrencies.
  ///
  /// Responsible only for loading and toggling favorites from storage.
  /// Does not interact with the API — crypto quote data is managed separately
  /// by CryptoQuoteNotifier.
  FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  @$internal
  @override
  FavoritesNotifier create() => FavoritesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesState>(value),
    );
  }
}

String _$favoritesNotifierHash() => r'171a1ce63b0a8e92fe2e674740e6e9771d0dadc1';

/// Notifier for managing the state of favorite cryptocurrencies.
///
/// Responsible only for loading and toggling favorites from storage.
/// Does not interact with the API — crypto quote data is managed separately
/// by CryptoQuoteNotifier.

abstract class _$FavoritesNotifier extends $Notifier<FavoritesState> {
  FavoritesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FavoritesState, FavoritesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FavoritesState, FavoritesState>,
              FavoritesState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
