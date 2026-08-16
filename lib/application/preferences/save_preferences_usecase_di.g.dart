// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_preferences_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [SavePreferencesUseCase].

@ProviderFor(savePreferencesUseCase)
final savePreferencesUseCaseProvider = SavePreferencesUseCaseProvider._();

/// Riverpod provider for the [SavePreferencesUseCase].

final class SavePreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          SavePreferencesUseCase,
          SavePreferencesUseCase,
          SavePreferencesUseCase
        >
    with $Provider<SavePreferencesUseCase> {
  /// Riverpod provider for the [SavePreferencesUseCase].
  SavePreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savePreferencesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savePreferencesUseCaseHash();

  @$internal
  @override
  $ProviderElement<SavePreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavePreferencesUseCase create(Ref ref) {
    return savePreferencesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavePreferencesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavePreferencesUseCase>(value),
    );
  }
}

String _$savePreferencesUseCaseHash() =>
    r'69ff3a5897bfd5ed6dd5049fad3e2a685b12511d';
