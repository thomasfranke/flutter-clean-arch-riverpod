import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response_value_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpClientResponse', () {
    test('should hold the body it was given, at the type it was given', () {
      const HttpClientResponse<List<int>> response =
          HttpClientResponse<List<int>>(data: <int>[1, 2, 3], statusCode: 200);

      expect(response.data, <int>[1, 2, 3]);
      expect(response.statusCode, 200);
    });

    test('should accept a response with no status code', () {
      // Not every transport reports one — a cancelled request has a body of
      // nothing and no code — and the datasources read `data` either way.
      const HttpClientResponse<String> response = HttpClientResponse<String>(
        data: '',
        statusCode: null,
      );

      expect(response.statusCode, isNull);
      expect(response.data, '');
    });

    test('should carry the type it was built with, not dynamic', () {
      const HttpClientResponse<Map<String, int>> response =
          HttpClientResponse<Map<String, int>>(
            data: <String, int>{'count': 1},
            statusCode: 200,
          );

      expect(response.data, isA<Map<String, int>>());
    });
  });
}
