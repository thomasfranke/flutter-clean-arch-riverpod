import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpClientFailure', () {
    test('should be an Exception, so a caught one is still a failure', () {
      expect(const HttpClientFailure.parse(), isA<Exception>());
    });

    test('should name a distinct type for every case', () {
      // The repository switches over these to mint a domain Failure, and the
      // switch stays exhaustive only because the cases are these.
      expect(
        const HttpClientFailure.network(),
        isA<HttpClientNetworkFailure>(),
      );
      expect(const HttpClientFailure.client(), isA<HttpClientClientFailure>());
      expect(const HttpClientFailure.server(), isA<HttpClientServerFailure>());
      expect(
        const HttpClientFailure.unknown(),
        isA<HttpClientUnknownFailure>(),
      );
      expect(const HttpClientFailure.parse(), isA<HttpClientParseFailure>());
      expect(
        const HttpClientFailure.notFound(),
        isA<HttpClientNotFoundFailure>(),
      );
      expect(
        const HttpClientFailure.cancelled(),
        isA<HttpClientCancelledFailure>(),
      );
    });

    test('should carry primitives only, so no Dio type crosses upward', () {
      // The fields are what `complete_wrappers` asserts about from the
      // outside: a `Response` here would be Dio in every datasource.
      const HttpClientServerFailure failure = HttpClientServerFailure(
        error: 'DioExceptionType.badResponse',
        errorMessage: 'Internal Server Error',
        statusCode: 500,
      );

      expect(failure, isA<HttpClientFailure>());
      expect(failure.error, 'DioExceptionType.badResponse');
      expect(failure.errorMessage, 'Internal Server Error');
      expect(failure.statusCode, 500);
    });

    test('should be equal to another of the same case and fields', () {
      expect(
        const HttpClientFailure.notFound(statusCode: 404),
        const HttpClientFailure.notFound(statusCode: 404),
      );
      expect(
        const HttpClientFailure.notFound(statusCode: 404),
        isNot(const HttpClientFailure.notFound(statusCode: 410)),
      );
    });

    test('should tell two cases apart even with no fields', () {
      expect(
        const HttpClientFailure.parse(),
        isNot(const HttpClientFailure.network()),
      );
    });
  });
}
