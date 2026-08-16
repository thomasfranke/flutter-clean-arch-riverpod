// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_klines_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [GetKlinesUseCase].

@ProviderFor(getKlinesUseCase)
final getKlinesUseCaseProvider = GetKlinesUseCaseProvider._();

/// Provides the [GetKlinesUseCase].

final class GetKlinesUseCaseProvider
    extends
        $FunctionalProvider<
          GetKlinesUseCase,
          GetKlinesUseCase,
          GetKlinesUseCase
        >
    with $Provider<GetKlinesUseCase> {
  /// Provides the [GetKlinesUseCase].
  GetKlinesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getKlinesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getKlinesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetKlinesUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetKlinesUseCase create(Ref ref) {
    return getKlinesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetKlinesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetKlinesUseCase>(value),
    );
  }
}

String _$getKlinesUseCaseHash() => r'0543eece1b9c955ddca0b671e45d24b8ce986c91';
