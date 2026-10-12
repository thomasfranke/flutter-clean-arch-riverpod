import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpClientConstants', () {
    test('should give every timeout a positive number of seconds', () {
      // The value matters less than the fact that there is one: a timeout of
      // zero is a request that never gives up, which on a phone on a train
      // is a screen that spins for ever.
      expect(HttpClientConstants.connectionTimeout, greaterThan(0));
      expect(HttpClientConstants.receiveTimeout, greaterThan(0));
      expect(HttpClientConstants.sendTimeout, greaterThan(0));
    });

    test('should hold the thirty seconds the Dio client is built with', () {
      expect(HttpClientConstants.connectionTimeout, 30);
      expect(HttpClientConstants.receiveTimeout, 30);
      expect(HttpClientConstants.sendTimeout, 30);
    });
  });
}
