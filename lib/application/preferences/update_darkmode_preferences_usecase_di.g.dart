// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_darkmode_preferences_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [UpdateDarkModeUseCase].

@ProviderFor(updateDarkModeUseCase)
final updateDarkModeUseCaseProvider = UpdateDarkModeUseCaseProvider._();

/// Riverpod provider for the [UpdateDarkModeUseCase].

final class UpdateDarkModeUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateDarkModeUseCase,
          UpdateDarkModeUseCase,
          UpdateDarkModeUseCase
        >
    with $Provider<UpdateDarkModeUseCase> {
  /// Riverpod provider for the [UpdateDarkModeUseCase].
  UpdateDarkModeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateDarkModeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateDarkModeUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateDarkModeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateDarkModeUseCase create(Ref ref) {
    return updateDarkModeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateDarkModeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateDarkModeUseCase>(value),
    );
  }
}

String _$updateDarkModeUseCaseHash() =>
    r'7ee162d89208e77b6c388d05efa2c01b8f7de0e0';
