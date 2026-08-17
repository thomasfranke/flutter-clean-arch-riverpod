import 'package:flutter_clean_arch_riverpod/core/constants/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("AppConfig.baseUrl points to Binance's public API", () {
    expect(AppConfig.baseUrl, 'https://data-api.binance.vision');
  });
}
