import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/main.dart' as app;
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/favorites_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/quotes_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/kline_chart_widget.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// End-to-end demo script.
///
/// Runs the real app against the public Binance data API (no mocks, no
/// backend to stand up) and walks the full user journey: switch to dark mode
/// right away (so the rest of the demo looks better), browse and filter
/// quotes, favorite one from the list, open its detail screen and switch the
/// chart interval, pull-to-refresh, unfavorite it from the Favorites tab,
/// and finish by adjusting font scale and language in Preferences.
///
/// Error/failure states are intentionally not covered here — they're already
/// exercised by the mocked widget tests under test/widget/, which can force
/// those states on demand. This script only drives the real, reachable app.
///
/// Run against the connected Android emulator with:
///   flutter test integration_test/app_test.dart -d emulator-5554
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete demo journey through the app', (
    final WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    // --- 1. Home: the public quotes list loads over the network. ---
    await _pumpUntilFound(tester, find.byType(QuoteTile));

    // --- 2. Switch to dark mode right away, purely so the rest of the demo
    // runs in dark mode. ---
    await tester.tap(find.byIcon(Icons.menu));
    await _settle(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await _settle(tester);

    await tester.tap(find.byType(SwitchListTile));
    await _pumpUntil(
      tester,
      () => tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await _settle(tester);
    await _pumpUntilFound(tester, find.byType(QuoteTile));

    final QuoteTile firstTile = tester.widget<QuoteTile>(
      find.byType(QuoteTile).first,
    );
    final String symbol = firstTile.quote.symbol;

    // --- 3. Filter the list by a symbol that matches. ---
    final String filter = symbol.substring(0, 3);
    await _filterBy(tester, filter);
    for (final Element element in find.byType(QuoteTile).evaluate()) {
      final QuoteTile tile = element.widget as QuoteTile;
      expect(tile.quote.symbol.contains(filter), isTrue);
    }
    await _filterBy(tester, '');

    // --- 4. Filter with a query that matches nothing. ---
    await _filterBy(tester, 'ZZZZZZ');
    expect(find.byType(QuoteTile), findsNothing);
    await _filterBy(tester, '');
    await _pumpUntilFound(tester, find.byType(QuoteTile));

    // The soft keyboard opened by `enterText` above resizes the Scaffold
    // (windowSoftInputMode="adjustResize") through a native animation that
    // pumpAndSettle can't track, which can throw off tap coordinates below.
    // Unfocus and give it real time to close before tapping anything else.
    FocusManager.instance.primaryFocus?.unfocus();
    await _settle(tester);

    // --- 5. Favorite the first quote directly from the list. ---
    final Finder firstQuoteTile = find.byType(QuoteTile).first;
    await tester.tap(
      find.descendant(
        of: firstQuoteTile,
        matching: find.byIcon(Icons.star_outline),
      ),
    );
    await _pumpUntilFound(
      tester,
      find.descendant(of: firstQuoteTile, matching: find.byIcon(Icons.star)),
    );

    // --- 6. Open its detail screen: chart loads, favorite state carried
    // over from the list, and switching the interval reloads the chart. ---
    await tester.tap(firstQuoteTile);
    await tester.pump();
    await _pumpUntilFound(tester, find.byType(KlineChart));
    await _pumpUntil(
      tester,
      () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
    );
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '4h'));
    await tester.pump();
    await _pumpUntil(
      tester,
      () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
    );
    expect(find.byType(LineChart), findsOneWidget);

    // (Not tester.pageBack(): it looks up the back button by its Material
    // tooltip, which is localized and won't be "Back" once the locale isn't
    // English — the arrow_back icon is stable across locales.)
    await tester.tap(find.byIcon(Icons.arrow_back));
    await _settle(tester);

    // --- 7. Pull-to-refresh the quotes list. ---
    await tester.fling(
      find.descendant(
        of: find.byType(QuotesTab),
        matching: find.byType(ListView),
      ),
      const Offset(0, 300),
      1000,
    );
    await _settle(tester);
    expect(
      find.descendant(
        of: find.byType(QuotesTab),
        matching: find.byType(QuoteTile),
      ),
      findsWidgets,
    );

    // --- 8. Favorites tab: the favorited quote shows up here too. ---
    await tester.tap(find.byType(Tab).at(1));
    await _settle(tester);

    final Finder favoriteInTab = find.descendant(
      of: find.byType(FavoritesTab),
      matching: find.text(symbol),
    );
    await _pumpUntilFound(tester, favoriteInTab);

    // --- 9. Unfavorite it from the Favorites tab and land on the empty
    // state. ---
    await tester.tap(
      find.descendant(
        of: find.byType(FavoritesTab),
        matching: find.byIcon(Icons.star),
      ),
    );
    await _pumpUntil(tester, () => favoriteInTab.evaluate().isEmpty);
    expect(
      find.descendant(
        of: find.byType(FavoritesTab),
        matching: find.byIcon(Icons.star_outline),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byType(Tab).at(0));
    await _settle(tester);

    // --- 10. Back to Preferences for the rest of the tour: font scale and
    // language. ---
    await tester.tap(find.byIcon(Icons.menu));
    await _settle(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await _settle(tester);

    final double initialFontScale = tester
        .widget<Slider>(find.byType(Slider))
        .value;
    await tester.drag(find.byType(Slider), const Offset(40, 0));
    await _pumpUntil(
      tester,
      () =>
          tester.widget<Slider>(find.byType(Slider)).value != initialFontScale,
    );

    await tester.tap(find.text('English'));
    await _pumpUntilFound(
      tester,
      find.descendant(
        of: find.ancestor(
          of: find.text('English'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.check),
      ),
    );
    await tester.tap(find.text('Português'));
    await _pumpUntilFound(
      tester,
      find.descendant(
        of: find.ancestor(
          of: find.text('Português'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.check),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await _settle(tester);

    // --- 11. Still on Home, still in dark mode. ---
    expect(find.byType(QuoteTile), findsWidgets);
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
  });
}

Future<void> _filterBy(final WidgetTester tester, final String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pumpAndSettle();
}

/// [WidgetTester.pumpAndSettle] plus a little real extra time, so that
/// device-native effects it can't track (page transition chrome, the soft
/// keyboard's resize animation) have finished before the next interaction.
Future<void> _settle(final WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

/// Pumps frames at [step] intervals until [condition] is true, instead of
/// [WidgetTester.pumpAndSettle], which never returns while a real network
/// request keeps an indeterminate [CircularProgressIndicator] spinning.
Future<void> _pumpUntil(
  final WidgetTester tester,
  final bool Function() condition, {
  final Duration timeout = const Duration(seconds: 30),
  final Duration step = const Duration(milliseconds: 250),
}) async {
  final DateTime deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition not met within $timeout');
    }
    await tester.pump(step);
  }
}

Future<void> _pumpUntilFound(
  final WidgetTester tester,
  final Finder finder, {
  final Duration timeout = const Duration(seconds: 30),
}) => _pumpUntil(tester, () => finder.evaluate().isNotEmpty, timeout: timeout);
