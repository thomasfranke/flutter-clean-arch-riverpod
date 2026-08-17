import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_route.freezed.dart';

/// Defines an API route with a path and HTTP method.
@freezed
abstract class ApiRoute with _$ApiRoute {
  /// Creates an [ApiRoute] instance.
  const factory ApiRoute(
    /// Endpoint path relative to the API base URL.
    final String path,

    /// HTTP method used by this route.
    final HttpMethod method,
  ) = _ApiRoute;
}
