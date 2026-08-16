import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/detail/detail_screen.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/home_screen.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/preferences/preferences_screen.dart';

part 'auto_route.gr.dart';

/// Application route manager.
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  /// Creates an [AppRouter].
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    /// --- System ---
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: PreferencesRoute.page),
    AutoRoute(page: CryptoQuoteDetailRoute.page),
  ];
}
