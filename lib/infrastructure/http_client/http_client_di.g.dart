// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_client_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the HTTP client implementation backed by Dio.

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

/// Provides the HTTP client implementation backed by Dio.

final class HttpClientProvider
    extends
        $FunctionalProvider<
          HttpClientInterface,
          HttpClientInterface,
          HttpClientInterface
        >
    with $Provider<HttpClientInterface> {
  /// Provides the HTTP client implementation backed by Dio.
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<HttpClientInterface> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HttpClientInterface create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClientInterface value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClientInterface>(value),
    );
  }
}

String _$httpClientHash() => r'3c16ffbc2c86e70d0661af3c2cce05f1733526ec';

/// Creates and configures the main Dio instance used for all HTTP requests.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Creates and configures the main Dio instance used for all HTTP requests.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Creates and configures the main Dio instance used for all HTTP requests.
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

String _$dioHash() => r'eede3a329dd11c324f6d1efae5f379a4da735901';
