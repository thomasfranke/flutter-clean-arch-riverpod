// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_quote_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing the state of crypto quotes, including fetching and
/// error handling.

@ProviderFor(CryptoQuoteNotifier)
final cryptoQuoteProvider = CryptoQuoteNotifierProvider._();

/// Notifier for managing the state of crypto quotes, including fetching and
/// error handling.
final class CryptoQuoteNotifierProvider
    extends $NotifierProvider<CryptoQuoteNotifier, CryptoQuoteState> {
  /// Notifier for managing the state of crypto quotes, including fetching and
  /// error handling.
  CryptoQuoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoQuoteNotifierHash();

  @$internal
  @override
  CryptoQuoteNotifier create() => CryptoQuoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoQuoteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoQuoteState>(value),
    );
  }
}

String _$cryptoQuoteNotifierHash() =>
    r'69bf45f70edc77a18d8f99c24a9fbb639ea89639';

/// Notifier for managing the state of crypto quotes, including fetching and
/// error handling.

abstract class _$CryptoQuoteNotifier extends $Notifier<CryptoQuoteState> {
  CryptoQuoteState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CryptoQuoteState, CryptoQuoteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CryptoQuoteState, CryptoQuoteState>,
              CryptoQuoteState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
