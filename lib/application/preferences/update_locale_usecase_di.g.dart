// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_locale_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the [UpdateLocaleUseCase].

@ProviderFor(updateLocaleUseCase)
final updateLocaleUseCaseProvider = UpdateLocaleUseCaseProvider._();

/// Riverpod provider for the [UpdateLocaleUseCase].

final class UpdateLocaleUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateLocaleUseCase,
          UpdateLocaleUseCase,
          UpdateLocaleUseCase
        >
    with $Provider<UpdateLocaleUseCase> {
  /// Riverpod provider for the [UpdateLocaleUseCase].
  UpdateLocaleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateLocaleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateLocaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateLocaleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateLocaleUseCase create(Ref ref) {
    return updateLocaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateLocaleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateLocaleUseCase>(value),
    );
  }
}

String _$updateLocaleUseCaseHash() =>
    r'39f4e48ad06dcfb24feeb6df6ab0c7c1a8fdb0cd';
