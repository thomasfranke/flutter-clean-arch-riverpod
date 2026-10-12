/// Everything a scenario can do to the app, and everything it can see.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/main.dart';
import 'package:flutter_clean_arch_riverpod/presentation/failures/failure_message.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/favorites_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/quotes_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/kline_chart_widget.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives the assembled app through what is on screen.
///
/// Every tap, wait and assertion lives here, so a scenario is only a list of
/// steps and the next scenario reuses the wait somebody already got right. It
/// never reads a provider or a repository: a harness that read the state would
/// go green on a screen that never updated.
///
/// The finders are icons, widget types and the few strings the app never
/// translates — a language name, a chart interval, a symbol. That is what lets
/// one scenario switch the locale and every other scenario keep working in
/// whichever locale it happens to be in.
final class CryptoRobot {
  /// Wraps [tester].
  CryptoRobot(this.tester);

  /// The harness driving the widget tree.
  final WidgetTester tester;

  /// How long to hold the screen on each thing just done.
  ///
  /// Zero unless `arch e2e <name> --watch` passed the define, since a run at
  /// full speed is unwatchable. Parsed rather than `int.fromEnvironment`: the
  /// define is absent in every ordinary run, and a zero the analyzer can fold
  /// sets two lints arguing.
  static Duration get hold => Duration(
    milliseconds:
        int.tryParse(const String.fromEnvironment('E2E_HOLD_MS')) ?? 0,
  );

  /// How long the quotes list is waited for.
  ///
  /// `/api/v3/ticker/24hr` with no symbol returns every ticker Binance has —
  /// about 1.9MB of JSON — and deserializing that many DTOs on a device
  /// regularly takes longer than a default timeout allows.
  static const Duration networkPatience = Duration(seconds: 120);

  /// Starts the app: the real object graph, against the live API.
  ///
  /// [fresh] wipes the stored preferences and favorites first, which is what
  /// makes a scenario independent of whichever one ran before it on this
  /// device. Pass `false` to relaunch and prove something was remembered.
  ///
  /// The three lines of composition below are `main`'s own, repeated rather
  /// than called: `runApp` a second time does not replace a tree that is
  /// already mounted, and a scenario that restarts the app is exactly how
  /// persistence gets tested.
  Future<void> launch({final bool fresh = true}) async {
    final SharedPreferencesImpl storage = await SharedPreferencesImpl.create();
    if (fresh) {
      await storage.clear();
    }
    // Unmounted first: Flutter updates an element in place when the widget's
    // type matches, so a second ProviderScope would keep the first one's
    // container, and every provider's state with it.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[storageProvider.overrideWithValue(storage)],
        child: const MyApp(),
      ),
    );
    await settle();
  }

  /// Waits until the quotes list has arrived from the network.
  Future<void> seesTheQuotes() async {
    await _pumpUntilFound(
      find.byType(QuoteTile),
      what: 'the quotes to arrive',
      timeout: networkPatience,
    );
    await _held();
  }

  /// The symbol of the first quote on screen — whatever Binance listed first.
  String get firstSymbol =>
      tester.widget<QuoteTile>(find.byType(QuoteTile).first).quote.symbol;

  /// Opens Preferences through the drawer.
  ///
  /// Both taps are on icons: the drawer's row and the screen's title are
  /// translated, and the scenario that switches the language would be the one
  /// to break.
  Future<void> openPreferences() async {
    await tester.tap(find.byIcon(Icons.menu));
    await settle();
    await tester.tap(find.byIcon(Icons.settings));
    await settle();
    await _held();
  }

  /// Turns dark mode on, and waits for the app to actually be dark.
  ///
  /// The wait is on the theme rather than on the switch: the switch flips as
  /// soon as the tap is handled, while the brightness only changes once the
  /// preference has round-tripped through storage and rebuilt the app.
  Future<void> turnOnDarkMode() async {
    await tester.tap(find.byType(SwitchListTile));
    await _pumpUntil(
      () => _brightness == Brightness.dark,
      what: 'the app to be drawn dark',
    );
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );
    await _held();
  }

  /// Asserts the app is drawn dark.
  void seesDarkMode() => expect(_brightness, Brightness.dark);

  /// Asserts the app is drawn light.
  void seesLightMode() => expect(_brightness, Brightness.light);

  /// Chooses the language called [language], by the name it calls itself.
  ///
  /// Language names are never translated, so `Português` is `Português` in
  /// every locale — which is what makes this finder hold whichever locale the
  /// app is in when the step runs.
  Future<void> chooseLanguage(final String language) async {
    await tester.tap(find.text(language));
    await _pumpUntilFound(
      _check(beside: language),
      what: '$language to be checked',
    );
    await _held();
  }

  /// Asserts [language] is the one marked as chosen.
  void seesLanguageChosen(final String language) =>
      expect(_check(beside: language), findsOneWidget);

  /// Drags the font scale slider, and waits for the value to move.
  ///
  /// The assertion is that it moved at all, not where it landed: the slider has
  /// six divisions and a drag of a given number of pixels lands on a different
  /// one on every screen size.
  Future<void> scaleTheFont() async {
    final double before = tester.widget<Slider>(find.byType(Slider)).value;
    await tester.drag(find.byType(Slider), const Offset(40, 0));
    await _pumpUntil(
      () => tester.widget<Slider>(find.byType(Slider)).value != before,
      what: 'the font scale to move',
    );
    await _held();
  }

  /// Goes back one screen.
  ///
  /// Not `tester.pageBack()`: that looks the button up by its Material
  /// tooltip, which is localized and stops being "Back" the moment the locale
  /// is not English. The arrow is the same in every locale.
  Future<void> goBack() async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await settle();
    await _held();
  }

  /// Types [text] into the filter above the quotes list.
  Future<void> filterBy(final String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
    await _held();
  }

  /// Empties the filter and waits for the whole list to come back.
  Future<void> clearTheFilter() async {
    await filterBy('');
    await _pumpUntilFound(find.byType(QuoteTile), what: 'the whole list back');
    await dismissTheKeyboard();
  }

  /// Closes the soft keyboard, and gives it time to actually be gone.
  ///
  /// `enterText` opens it, and it resizes the Scaffold through a native
  /// animation `pumpAndSettle` cannot track — which throws off the coordinates
  /// of whatever is tapped next.
  Future<void> dismissTheKeyboard() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await settle();
  }

  /// Asserts every quote on screen matches [filter].
  void seesOnlyQuotesMatching(final String filter) {
    expect(find.byType(QuoteTile), findsWidgets);
    for (final Element element in find.byType(QuoteTile).evaluate()) {
      final QuoteTile tile = element.widget as QuoteTile;
      expect(tile.quote.symbol.contains(filter), isTrue);
    }
  }

  /// Asserts the list is empty.
  void seesNoQuotes() => expect(find.byType(QuoteTile), findsNothing);

  /// Favorites the first quote from the list itself, and waits for the star to
  /// fill in.
  Future<void> favoriteTheFirstQuote() async {
    await tester.tap(
      find.descendant(
        of: find.byType(QuoteTile).first,
        matching: find.byIcon(Icons.star_outline),
      ),
    );
    await _pumpUntilFound(
      find.descendant(
        of: find.byType(QuoteTile).first,
        matching: find.byIcon(Icons.star),
      ),
      what: 'the star to fill in',
    );
    await _held();
  }

  /// Opens the first quote's detail screen.
  Future<void> openTheFirstQuote() async {
    await tester.tap(find.byType(QuoteTile).first);
    await tester.pump();
    await _held();
  }

  /// Waits for the price history chart to be drawn.
  Future<void> seesTheChart() async {
    await _pumpUntilFound(find.byType(KlineChart), what: 'the chart');
    await _pumpUntil(
      () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
      what: 'the chart to stop loading',
    );
    expect(find.byType(LineChart), findsOneWidget);
    await _held();
  }

  /// Asserts the quote on the detail screen is a favorite.
  void seesItIsAFavorite() => expect(find.byIcon(Icons.star), findsOneWidget);

  /// Picks the [interval] chip and waits for the chart to come back.
  Future<void> switchInterval(final String interval) async {
    await tester.tap(find.widgetWithText(ChoiceChip, interval));
    await tester.pump();
    await _pumpUntil(
      () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
      what: 'the chart to come back',
    );
    expect(find.byType(LineChart), findsOneWidget);
    await _held();
  }

  /// Pulls the quotes list down to refresh it.
  Future<void> pullToRefresh() async {
    await tester.fling(
      find.descendant(
        of: find.byType(QuotesTab),
        matching: find.byType(ListView),
      ),
      const Offset(0, 300),
      1000,
    );
    await settle();
    expect(
      find.descendant(
        of: find.byType(QuotesTab),
        matching: find.byType(QuoteTile),
      ),
      findsWidgets,
    );
    await _held();
  }

  /// Switches to the Favorites tab.
  Future<void> openTheFavoritesTab() => _openTab(1);

  /// Switches to the Quotes tab.
  Future<void> openTheQuotesTab() => _openTab(0);

  /// Waits for [symbol] to show up under Favorites.
  Future<void> seesFavorite(final String symbol) async {
    await _pumpUntilFound(
      _inFavorites(find.text(symbol)),
      what: '$symbol under Favorites',
    );
    await _held();
  }

  /// Waits for Favorites to hold at least one quote.
  ///
  /// The assertion for a scenario that restarted the app: which symbol is
  /// listed first is Binance's business and can change between two requests,
  /// so what is being proved is that the favorite survived, not which one it
  /// was.
  Future<void> seesAFavorite() async {
    await _pumpUntilFound(
      _inFavorites(find.byType(QuoteTile)),
      what: 'a favorite to still be there',
    );
    await _held();
  }

  /// Unfavorites the one quote under Favorites, and waits for the list to
  /// empty.
  Future<void> unfavoriteFromTheFavoritesTab() async {
    await tester.tap(_inFavorites(find.byIcon(Icons.star)));
    await _pumpUntil(
      () => _inFavorites(find.byType(QuoteTile)).evaluate().isEmpty,
      what: 'Favorites to empty',
    );
    await _held();
  }

  /// Asserts Favorites is showing its empty state.
  void seesNoFavorites() =>
      expect(_inFavorites(find.byIcon(Icons.star_outline)), findsOneWidget);

  /// Asserts nothing on screen is an error.
  ///
  /// The cheap assertion worth making at the end of every flow: a provider that
  /// threw leaves an [ErrorWidget] where the screen used to be, and a scenario
  /// that only ever looked for what it expected would not notice.
  void seesNothingBroken() => expect(find.byType(ErrorWidget), findsNothing);

  /// [WidgetTester.pumpAndSettle] plus a little real time, so that
  /// device-native effects it cannot track — a page transition, the soft
  /// keyboard's resize — have finished before the next interaction.
  Future<void> settle() async {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
  }

  Brightness get _brightness =>
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness;

  /// The check mark on the row for [beside], which is how the Preferences
  /// screen says which language is chosen.
  Finder _check({required final String beside}) => find.descendant(
    of: find.ancestor(of: find.text(beside), matching: find.byType(ListTile)),
    matching: find.byIcon(Icons.check),
  );

  Finder _inFavorites(final Finder finder) =>
      find.descendant(of: find.byType(FavoritesTab), matching: finder);

  Future<void> _openTab(final int index) async {
    await tester.tap(find.byType(Tab).at(index));
    await settle();
    await _held();
  }

  /// Holds the screen on what just happened, for a run somebody is watching.
  Future<void> _held() async {
    if (hold <= Duration.zero) {
      return;
    }
    await tester.binding.delayed(hold);
  }

  /// Pumps frames at [step] intervals until [condition] holds, giving up after
  /// [timeout] and saying [what] it was waiting for.
  ///
  /// Instead of [WidgetTester.pumpAndSettle], which never returns while a real
  /// network request keeps an indeterminate [CircularProgressIndicator]
  /// spinning.
  Future<void> _pumpUntil(
    final bool Function() condition, {
    final String what = 'the condition',
    final Duration timeout = const Duration(seconds: 30),
    final Duration step = const Duration(milliseconds: 250),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) {
        fail('Waited $timeout for $what.${_complaint()}');
      }
      // The pump carries the deadline too, and not only the gap between two of
      // them: under the live binding a pump waits for a frame the device
      // actually draws, so a device that stopped drawing leaves the loop
      // parked inside `pump`, where the check above is never reached again.
      // That is a hang no step timeout can explain, so it names itself.
      await tester
          .pump(step)
          .timeout(
            deadline.difference(DateTime.now()),
            onTimeout: () => fail(
              'Waited $timeout for $what, and the device stopped drawing: a '
              'pump never returned. On Android that is what photographing the '
              'app mid-test does — the surface is swapped for an image and '
              'only swapped back at teardown.${_complaint()}',
            ),
          );
    }
  }

  Future<void> _pumpUntilFound(
    final Finder finder, {
    final String what = 'the condition',
    final Duration timeout = const Duration(seconds: 30),
  }) => _pumpUntil(
    () => finder.evaluate().isNotEmpty,
    what: what,
    timeout: timeout,
  );

  /// What the screen says went wrong, ready to append to a failure.
  ///
  /// A provider that failed draws its failure as ordinary text, which a
  /// finder waiting for a list never reads: the run would report that it
  /// waited, and keep to itself that the answer was on screen the whole time.
  String _complaint() {
    for (final Element element in find.byType(Text).evaluate()) {
      final String? data = (element.widget as Text).data;
      if (data != null && _failureSentences.contains(data)) {
        return '\nThe screen says: $data';
      }
    }
    return '';
  }

  /// Every sentence a [Failure] can be drawn as, in every language the app
  /// speaks — the screen shows the localized message, not the type.
  static final Set<String> _failureSentences = <String>{
    for (final Locale locale in AppLocalizations.supportedLocales)
      for (final Failure failure in const <Failure>[
        Failure.apiNetwork(),
        Failure.apiServer(),
        Failure.apiNotFound(),
        Failure.apiClient(),
        Failure.parse(),
        Failure.storage(),
        Failure.unexpected(),
      ])
        failure.message(lookupAppLocalizations(locale)),
  };
}
