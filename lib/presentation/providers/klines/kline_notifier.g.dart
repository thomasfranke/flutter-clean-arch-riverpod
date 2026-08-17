// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing the state of kline (candlestick) data for a given
/// symbol, including fetching and interval switching.

@ProviderFor(KlineNotifier)
final klineProvider = KlineNotifierFamily._();

/// Notifier for managing the state of kline (candlestick) data for a given
/// symbol, including fetching and interval switching.
final class KlineNotifierProvider
    extends $NotifierProvider<KlineNotifier, KlineState> {
  /// Notifier for managing the state of kline (candlestick) data for a given
  /// symbol, including fetching and interval switching.
  KlineNotifierProvider._({
    required KlineNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'klineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$klineNotifierHash();

  @override
  String toString() {
    return r'klineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  KlineNotifier create() => KlineNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KlineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KlineState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KlineNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$klineNotifierHash() => r'9250b2b3ba01c4f1aaebec47605d52a233b48a9f';

/// Notifier for managing the state of kline (candlestick) data for a given
/// symbol, including fetching and interval switching.

final class KlineNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          KlineNotifier,
          KlineState,
          KlineState,
          KlineState,
          String
        > {
  KlineNotifierFamily._()
    : super(
        retry: null,
        name: r'klineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Notifier for managing the state of kline (candlestick) data for a given
  /// symbol, including fetching and interval switching.

  KlineNotifierProvider call(String symbol) =>
      KlineNotifierProvider._(argument: symbol, from: this);

  @override
  String toString() => r'klineProvider';
}

/// Notifier for managing the state of kline (candlestick) data for a given
/// symbol, including fetching and interval switching.

abstract class _$KlineNotifier extends $Notifier<KlineState> {
  late final _$args = ref.$arg as String;
  String get symbol => _$args;

  KlineState build(String symbol);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<KlineState, KlineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KlineState, KlineState>,
              KlineState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
