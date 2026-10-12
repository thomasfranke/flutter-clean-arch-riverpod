import 'package:auto_route/auto_route.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRouter', () {
    test('should declare the three screens the app has, and no more', () {
      final AppRouter router = AppRouter();

      final List<String> names = <String>[
        for (final AutoRoute route in router.routes) route.name,
      ];

      // Spelled out rather than counted: a route added here is a screen
      // somebody can reach, and one removed is a link that stops working.
      expect(names, <String>[
        'HomeRoute',
        'PreferencesRoute',
        'CryptoQuoteDetailRoute',
      ]);
    });

    test('should open on the home screen', () {
      final AppRouter router = AppRouter();

      final Iterable<AutoRoute> initial = router.routes.where(
        (final AutoRoute route) => route.initial,
      );

      expect(initial.length, 1, reason: 'exactly one route is the first one');
      expect(initial.single.name, 'HomeRoute');
    });

    test('should adapt its transitions to the platform', () {
      // Adaptive rather than fixed: the same code gives a Cupertino push on
      // iOS and a Material one on Android, which is what a user of either
      // expects a back gesture to do.
      expect(AppRouter().defaultRouteType, isA<AdaptiveRouteType>());
    });
  });
}
