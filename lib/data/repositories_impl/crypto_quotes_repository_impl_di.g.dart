// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_quotes_repository_impl_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [CryptoQuotesRepositoryImpl], allowing it to be
/// easily injected and used throughout the application.

@ProviderFor(cryptoQuotesRepository)
final cryptoQuotesRepositoryProvider = CryptoQuotesRepositoryProvider._();

/// Riverpod provider for the [CryptoQuotesRepositoryImpl], allowing it to be
/// easily injected and used throughout the application.

final class CryptoQuotesRepositoryProvider
    extends
        $FunctionalProvider<
          CryptoQuotesRepositoryInterface,
          CryptoQuotesRepositoryInterface,
          CryptoQuotesRepositoryInterface
        >
    with $Provider<CryptoQuotesRepositoryInterface> {
  /// Riverpod provider for the [CryptoQuotesRepositoryImpl], allowing it to be
  /// easily injected and used throughout the application.
  CryptoQuotesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoQuotesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoQuotesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CryptoQuotesRepositoryInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CryptoQuotesRepositoryInterface create(Ref ref) {
    return cryptoQuotesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoQuotesRepositoryInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoQuotesRepositoryInterface>(
        value,
      ),
    );
  }
}

String _$cryptoQuotesRepositoryHash() =>
    r'abeb37f73db53a1f6857891e43c94e19ab0b8441';
