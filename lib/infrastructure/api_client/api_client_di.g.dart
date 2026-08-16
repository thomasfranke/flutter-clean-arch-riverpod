// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the API client implementation backed by Dio.

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// Provides the API client implementation backed by Dio.

final class ApiClientProvider
    extends
        $FunctionalProvider<
          ApiClientInterface,
          ApiClientInterface,
          ApiClientInterface
        >
    with $Provider<ApiClientInterface> {
  /// Provides the API client implementation backed by Dio.
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClientInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApiClientInterface create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClientInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClientInterface>(value),
    );
  }
}

String _$apiClientHash() => r'0a09358f64915e3e1759f2162d9aa756117c5951';

/// Creates and configures the main Dio instance used for all API requests.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Creates and configures the main Dio instance used for all API requests.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Creates and configures the main Dio instance used for all API requests.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'559f47873af68032faab5df08559e7f00ca93f66';
