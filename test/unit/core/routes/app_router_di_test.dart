import 'package:flutter_clean_arch_riverpod/core/routes/app_router.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/app_router_di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('appRouterProvider builds an AppRouter', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final AppRouter router = container.read(appRouterProvider);

    expect(router, isA<AppRouter>());
    expect(appRouterProvider.overrideWithValue(router), isNotNull);
  });
}
