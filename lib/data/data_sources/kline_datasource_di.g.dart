// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_datasource_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a Riverpod provider for the [KlineDatasource].

@ProviderFor(klineDatasource)
final klineDatasourceProvider = KlineDatasourceProvider._();

/// Provides a Riverpod provider for the [KlineDatasource].

final class KlineDatasourceProvider
    extends
        $FunctionalProvider<KlineDatasource, KlineDatasource, KlineDatasource>
    with $Provider<KlineDatasource> {
  /// Provides a Riverpod provider for the [KlineDatasource].
  KlineDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'klineDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$klineDatasourceHash();

  @$internal
  @override
  $ProviderElement<KlineDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KlineDatasource create(Ref ref) {
    return klineDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KlineDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KlineDatasource>(value),
    );
  }
}

String _$klineDatasourceHash() => r'9fadb25828824fc0928b678733f53aa354168721';
