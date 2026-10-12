import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/app_drawer_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_helpers.dart';

/// A scaffold whose drawer is the one under test, with a router above it so
/// the settings row has somewhere to push to.
Widget _hostingTheDrawer() => Scaffold(
  drawer: const AppDrawerWidget(),
  appBar: AppBar(),
  body: const SizedBox.shrink(),
);

void main() {
  group('AppDrawerWidget', () {
    testWidgets('names the app at the top, in the app language', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, _hostingTheDrawer());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(AppDrawerWidget));
      expect(find.text(AppLocalizations.of(context).appTitle), findsOneWidget);
    });

    testWidgets('offers one way out: settings', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, _hostingTheDrawer());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(AppDrawerWidget));
      expect(find.text(AppLocalizations.of(context).settings), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      // One row, so the drawer cannot grow a second one unnoticed.
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('puts the name in a header above the rows', (
      final WidgetTester tester,
    ) async {
      // Closing the drawer before it navigates is the other thing worth
      // knowing about this widget, and it needs the real router and the
      // providers under it — so it is proven end to end instead, by the
      // scenario that reaches the preferences screen through the drawer.
      await pumpApp(tester, _hostingTheDrawer());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.byIcon(Icons.currency_bitcoin), findsOneWidget);
    });
  });
}
