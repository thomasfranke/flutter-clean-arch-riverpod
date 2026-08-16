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
          CryptoQuoteRepository,
          CryptoQuoteRepository,
          CryptoQuoteRepository
        >
    with $Provider<CryptoQuoteRepository> {
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
  $ProviderElement<CryptoQuoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CryptoQuoteRepository create(Ref ref) {
    return cryptoQuotesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoQuoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoQuoteRepository>(value),
    );
  }
}

String _$cryptoQuotesRepositoryHash() =>
    r'a8a12b96219804df729ef4caf4e68e30eeada787';
