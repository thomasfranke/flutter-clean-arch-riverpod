// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_repository_impl_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [PreferencesRepositoryImpl].

@ProviderFor(preferencesRepository)
final preferencesRepositoryProvider = PreferencesRepositoryProvider._();

/// Riverpod provider for the [PreferencesRepositoryImpl].

final class PreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          PreferencesRepositoryInterface,
          PreferencesRepositoryInterface,
          PreferencesRepositoryInterface
        >
    with $Provider<PreferencesRepositoryInterface> {
  /// Riverpod provider for the [PreferencesRepositoryImpl].
  PreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesRepositoryHash();

  @$internal
  @override
  $ProviderElement<PreferencesRepositoryInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferencesRepositoryInterface create(Ref ref) {
    return preferencesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesRepositoryInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesRepositoryInterface>(
        value,
      ),
    );
  }
}

String _$preferencesRepositoryHash() =>
    r'95c2e5c451eef0c8dc1b97c9a9e14e280a15bb06';
