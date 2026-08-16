// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_crypto_quotes_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [GetCryptoQuotesUseCase].

@ProviderFor(getCryptoQuotesUseCase)
final getCryptoQuotesUseCaseProvider = GetCryptoQuotesUseCaseProvider._();

/// Riverpod provider for the [GetCryptoQuotesUseCase].

final class GetCryptoQuotesUseCaseProvider
    extends
        $FunctionalProvider<
          GetCryptoQuotesUseCase,
          GetCryptoQuotesUseCase,
          GetCryptoQuotesUseCase
        >
    with $Provider<GetCryptoQuotesUseCase> {
  /// Riverpod provider for the [GetCryptoQuotesUseCase].
  GetCryptoQuotesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCryptoQuotesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCryptoQuotesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCryptoQuotesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCryptoQuotesUseCase create(Ref ref) {
    return getCryptoQuotesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCryptoQuotesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCryptoQuotesUseCase>(value),
    );
  }
}

String _$getCryptoQuotesUseCaseHash() =>
    r'da79bcec1c7fbf8369025a75579ca6b542989116';
