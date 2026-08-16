// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_fontscale_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [UpdateFontScaleUseCase].

@ProviderFor(updateFontScaleUseCase)
final updateFontScaleUseCaseProvider = UpdateFontScaleUseCaseProvider._();

/// Riverpod provider for the [UpdateFontScaleUseCase].

final class UpdateFontScaleUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateFontScaleUseCase,
          UpdateFontScaleUseCase,
          UpdateFontScaleUseCase
        >
    with $Provider<UpdateFontScaleUseCase> {
  /// Riverpod provider for the [UpdateFontScaleUseCase].
  UpdateFontScaleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateFontScaleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateFontScaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateFontScaleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateFontScaleUseCase create(Ref ref) {
    return updateFontScaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateFontScaleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateFontScaleUseCase>(value),
    );
  }
}

String _$updateFontScaleUseCaseHash() =>
    r'7b2abaa77e8f11eed3b84c500fe55d58ecabf159';
