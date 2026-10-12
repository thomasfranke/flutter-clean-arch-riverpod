import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_method_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpMethod', () {
    test('should name the five verbs the client can send', () {
      // Spelled out rather than read back from the enum, which would make
      // the test agree with whatever it found: a verb removed by accident
      // fails here, and a request built with it stops compiling.
      expect(HttpMethod.values, <HttpMethod>[
        HttpMethod.get,
        HttpMethod.post,
        HttpMethod.put,
        HttpMethod.patch,
        HttpMethod.delete,
      ]);
    });

    test('should spell each verb the way a request line does', () {
      // Dio takes the method as a string, so the name is the wire format.
      expect(HttpMethod.get.name, 'get');
      expect(HttpMethod.post.name, 'post');
      expect(HttpMethod.put.name, 'put');
      expect(HttpMethod.patch.name, 'patch');
      expect(HttpMethod.delete.name, 'delete');
    });
  });
}
