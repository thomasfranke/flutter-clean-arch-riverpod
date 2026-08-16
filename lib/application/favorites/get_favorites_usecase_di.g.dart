// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_favorites_usecase_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [GetFavoritesUseCase].

@ProviderFor(getFavoritesUseCase)
final getFavoritesUseCaseProvider = GetFavoritesUseCaseProvider._();

/// Provides the [GetFavoritesUseCase].

final class GetFavoritesUseCaseProvider
    extends
        $FunctionalProvider<
          GetFavoritesUseCase,
          GetFavoritesUseCase,
          GetFavoritesUseCase
        >
    with $Provider<GetFavoritesUseCase> {
  /// Provides the [GetFavoritesUseCase].
  GetFavoritesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFavoritesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFavoritesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetFavoritesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetFavoritesUseCase create(Ref ref) {
    return getFavoritesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetFavoritesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetFavoritesUseCase>(value),
    );
  }
}

String _$getFavoritesUseCaseHash() =>
    r'841293fe8a2502ec88958e380f84cf88eda7aee8';
