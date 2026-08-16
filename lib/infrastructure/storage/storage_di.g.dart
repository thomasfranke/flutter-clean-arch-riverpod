// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [StorageInterface] implementation.
/// Storage provider that needs to be overridden in the main app.
/// Used for testing purposes.

@ProviderFor(storage)
final storageProvider = StorageProvider._();

/// Provides the [StorageInterface] implementation.
/// Storage provider that needs to be overridden in the main app.
/// Used for testing purposes.

final class StorageProvider
    extends
        $FunctionalProvider<
          StorageInterface,
          StorageInterface,
          StorageInterface
        >
    with $Provider<StorageInterface> {
  /// Provides the [StorageInterface] implementation.
  /// Storage provider that needs to be overridden in the main app.
  /// Used for testing purposes.
  StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $ProviderElement<StorageInterface> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StorageInterface create(Ref ref) {
    return storage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorageInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorageInterface>(value),
    );
  }
}

String _$storageHash() => r'b3cc455dff5ddb5cd742d7a114367ed58f54d9f4';
