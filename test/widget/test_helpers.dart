import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Pumps [child] wrapped in a [ProviderScope] and a minimal [MaterialApp],
/// with the app's localization delegates configured. Use this for widgets
/// that don't drive `auto_route` navigation.
Future<void> pumpApp(
  final WidgetTester tester,
  final Widget child, {
  final List<Override> overrides = const <Override>[],
}) => tester.pumpWidget(
  ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  ),
);

/// Pumps the real [AppRouter], starting at its initial route (`HomeRoute`).
/// Use this for flows that need real `context.router` navigation (tapping a
/// quote tile, opening the drawer, etc).
Future<AppRouter> pumpRoutedApp(
  final WidgetTester tester, {
  final List<Override> overrides = const <Override>[],
}) async {
  final AppRouter appRouter = AppRouter();
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  return appRouter;
}
