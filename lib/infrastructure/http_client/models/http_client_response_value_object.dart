/// Framework-agnostic HTTP response, decoupling consumers of
/// `HttpClientInterface` from the concrete HTTP client implementation (e.g.
/// `dio`).
class HttpClientResponse<T> {
  /// Creates an [HttpClientResponse].
  const HttpClientResponse({required this.data, required this.statusCode});

  /// The deserialized response body.
  final T data;

  /// The HTTP status code of the response, if available.
  final int? statusCode;
}
