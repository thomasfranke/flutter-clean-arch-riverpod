// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_quotes_datasource_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [CryptoQuotesDatasource].

@ProviderFor(cryptoQuoteDatasource)
final cryptoQuoteDatasourceProvider = CryptoQuoteDatasourceProvider._();

/// Riverpod provider for the [CryptoQuotesDatasource].

final class CryptoQuoteDatasourceProvider
    extends
        $FunctionalProvider<
          CryptoQuotesDatasource,
          CryptoQuotesDatasource,
          CryptoQuotesDatasource
        >
    with $Provider<CryptoQuotesDatasource> {
  /// Riverpod provider for the [CryptoQuotesDatasource].
  CryptoQuoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoQuoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoQuoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<CryptoQuotesDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CryptoQuotesDatasource create(Ref ref) {
    return cryptoQuoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoQuotesDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoQuotesDatasource>(value),
    );
  }
}

String _$cryptoQuoteDatasourceHash() =>
    r'6e25e59f56f1973d2cfed1e4eecf6a752a269e20';
