// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_preferences_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [GetPreferencesUseCase].

@ProviderFor(getPreferencesUseCase)
final getPreferencesUseCaseProvider = GetPreferencesUseCaseProvider._();

/// Riverpod provider for the [GetPreferencesUseCase].

final class GetPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          GetPreferencesUseCase,
          GetPreferencesUseCase,
          GetPreferencesUseCase
        >
    with $Provider<GetPreferencesUseCase> {
  /// Riverpod provider for the [GetPreferencesUseCase].
  GetPreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPreferencesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPreferencesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPreferencesUseCase create(Ref ref) {
    return getPreferencesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPreferencesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPreferencesUseCase>(value),
    );
  }
}

String _$getPreferencesUseCaseHash() =>
    r'7651d0020814213de6ba155a70abdf0abd8cf746';
