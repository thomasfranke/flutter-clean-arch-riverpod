// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_datasource_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a Riverpod provider for the [PreferencesDatasource].

@ProviderFor(preferencesDatasource)
final preferencesDatasourceProvider = PreferencesDatasourceProvider._();

/// Provides a Riverpod provider for the [PreferencesDatasource].

final class PreferencesDatasourceProvider
    extends
        $FunctionalProvider<
          PreferencesDatasource,
          PreferencesDatasource,
          PreferencesDatasource
        >
    with $Provider<PreferencesDatasource> {
  /// Provides a Riverpod provider for the [PreferencesDatasource].
  PreferencesDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesDatasourceHash();

  @$internal
  @override
  $ProviderElement<PreferencesDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferencesDatasource create(Ref ref) {
    return preferencesDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesDatasource>(value),
    );
  }
}

String _$preferencesDatasourceHash() =>
    r'59417fe4ee845321328a3d4e3ae6700b17f82d05';
