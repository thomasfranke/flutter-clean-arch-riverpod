// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_quotes_datasource_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [CryptoQuoteDatasource].

@ProviderFor(cryptoQuoteDatasource)
final cryptoQuoteDatasourceProvider = CryptoQuoteDatasourceProvider._();

/// Riverpod provider for the [CryptoQuoteDatasource].

final class CryptoQuoteDatasourceProvider
    extends
        $FunctionalProvider<
          CryptoQuoteDatasource,
          CryptoQuoteDatasource,
          CryptoQuoteDatasource
        >
    with $Provider<CryptoQuoteDatasource> {
  /// Riverpod provider for the [CryptoQuoteDatasource].
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
  $ProviderElement<CryptoQuoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CryptoQuoteDatasource create(Ref ref) {
    return cryptoQuoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoQuoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoQuoteDatasource>(value),
    );
  }
}

String _$cryptoQuoteDatasourceHash() =>
    r'dc37dbd0d45ca3cecc48975ad6d67707d0ae2bab';
