import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpClientFailureMapper.toDomainFailure', () {
    test('network maps to Failure.apiNetwork', () {
      const HttpClientFailure failure = HttpClientFailure.network(
        errorMessage: 'no connection',
      );

      expect(
        failure.toDomainFailure(),
        const Failure.apiNetwork('no connection'),
      );
    });

    test('cancelled maps to Failure.apiNetwork', () {
      const HttpClientFailure failure = HttpClientFailure.cancelled(
        errorMessage: 'cancelled',
      );

      expect(failure.toDomainFailure(), const Failure.apiNetwork('cancelled'));
    });

    test('client maps to Failure.apiClient', () {
      const HttpClientFailure failure = HttpClientFailure.client(
        errorMessage: 'bad request',
      );

      expect(failure.toDomainFailure(), const Failure.apiClient('bad request'));
    });

    test('notFound maps to Failure.apiNotFound', () {
      const HttpClientFailure failure = HttpClientFailure.notFound(
        errorMessage: 'not found',
      );

      expect(failure.toDomainFailure(), const Failure.apiNotFound('not found'));
    });

    test('server maps to Failure.apiServer', () {
      const HttpClientFailure failure = HttpClientFailure.server(
        errorMessage: 'internal error',
      );

      expect(
        failure.toDomainFailure(),
        const Failure.apiServer('internal error'),
      );
    });

    test('parse maps to Failure.parse', () {
      const HttpClientFailure failure = HttpClientFailure.parse();

      expect(failure.toDomainFailure(), const Failure.parse());
    });

    test('unknown maps to Failure.apiServer', () {
      const HttpClientFailure failure = HttpClientFailure.unknown(
        errorMessage: 'unknown error',
      );

      expect(
        failure.toDomainFailure(),
        const Failure.apiServer('unknown error'),
      );
    });
  });
}
