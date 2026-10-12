import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route_value_object.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_method_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiRoute', () {
    test('should hold the path and the method it was given', () {
      const ApiRoute route = ApiRoute('/api/v3/ticker/24hr', HttpMethod.get);

      expect(route.path, '/api/v3/ticker/24hr');
      expect(route.method, HttpMethod.get);
    });

    test('should be equal to another naming the same call', () {
      const ApiRoute one = ApiRoute('/api/v3/klines', HttpMethod.get);
      const ApiRoute other = ApiRoute('/api/v3/klines', HttpMethod.get);

      expect(one, other);
      expect(one.hashCode, other.hashCode);
    });

    test('should differ when the method differs on the same path', () {
      // A route is the pair, not the path: the same endpoint read and
      // written are two calls.
      const ApiRoute read = ApiRoute('/api/v3/order', HttpMethod.get);
      const ApiRoute write = ApiRoute('/api/v3/order', HttpMethod.post);

      expect(read, isNot(write));
    });
  });
}
