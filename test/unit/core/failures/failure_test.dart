import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('should be an Exception, so a caught one is still a failure', () {
      expect(const Failure.parse(), isA<Exception>());
    });

    test('should name a distinct type for every case', () {
      // Spelled out rather than read back: every screen and the failure
      // mapper switch over these, and a `sealed` switch only stays
      // exhaustive because the cases are the ones listed here.
      expect(const Failure.apiNetwork(), isA<ApiNetworkDomainFailure>());
      expect(const Failure.apiServer(), isA<ApiServerDomainFailure>());
      expect(const Failure.apiClient(), isA<ApiClientDomainFailure>());
      expect(
        const Failure.apiNotFound(),
        isA<ApiClientNotFoundDomainFailure>(),
      );
      expect(const Failure.parse(), isA<ParseDomainFailure>());
      expect(const Failure.storage(), isA<SharedPreferencesDomainFailure>());
      expect(const Failure.unexpected(), isA<UnexpectedDomainFailure>());
    });

    test('should keep the technical message it was given', () {
      // The message never reaches a screen — the failure mapper reads the
      // type, not the text — but it is what a log is read for.
      const Failure failure = Failure.apiServer('503 Service Unavailable');

      expect((failure as ApiServerDomainFailure).e, '503 Service Unavailable');
    });

    test('should be equal to another of the same case and message', () {
      expect(
        const Failure.apiNetwork('socket closed'),
        const Failure.apiNetwork('socket closed'),
      );
      expect(
        const Failure.apiNetwork('socket closed'),
        isNot(const Failure.apiNetwork('timed out')),
      );
    });

    test('should tell two cases apart even with no message', () {
      expect(const Failure.parse(), isNot(const Failure.storage()));
    });
  });
}
