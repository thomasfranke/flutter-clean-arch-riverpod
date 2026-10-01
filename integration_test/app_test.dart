/// The complete demo journey: every flow the app has, in one run.
///
/// The long one, kept whole on purpose. The scenarios beside it each prove one
/// thing and are what anybody runs while working; this one is the tour, and it
/// is the recording the README's demo GIF and the screenshots under `docs/`
/// are frames of — which is why it opens by setting dark mode and English,
/// before anything worth photographing happens.
///
/// Error and failure states are deliberately absent: the mocked widget tests
/// under `test/widget/` can force those on demand, and this script only drives
/// the real, reachable app against the live Binance API.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'The complete demo journey',
    describe:
        'Every flow the app has, in the order a person would walk them: dark '
        'mode and English first, then browsing, filtering, favoriting, the '
        'detail chart, a refresh, the Favorites tab, and back to Preferences '
        'for the font scale and the language.',
    group: 'The whole journey',
    steps: <Step>[
      Step('the quotes list loads over the network', (
        final CryptoRobot robot,
      ) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      // Dark mode and English come first purely so the rest of the run looks
      // better and matches the language the docs are written in.
      Step('switch to dark mode', (final CryptoRobot robot) async {
        await robot.openPreferences();
        await robot.turnOnDarkMode();
      }),
      Step('switch to English', (final CryptoRobot robot) async {
        await robot.chooseLanguage('English');
        await robot.goBack();
        await robot.seesTheQuotes();
      }),
      Step('filter by a symbol that matches', (final CryptoRobot robot) async {
        await robot.filterBy(robot.firstSymbol.substring(0, 3));
        robot.seesOnlyQuotesMatching(robot.firstSymbol.substring(0, 3));
      }),
      Step('filter by one that matches nothing', (
        final CryptoRobot robot,
      ) async {
        await robot.filterBy('ZZZZZZ');
        robot.seesNoQuotes();
        await robot.clearTheFilter();
      }),
      Step('favorite the first quote from the list', (
        final CryptoRobot robot,
      ) async {
        await robot.favoriteTheFirstQuote();
      }),
      Step('open its detail screen and switch the interval', (
        final CryptoRobot robot,
      ) async {
        await robot.openTheFirstQuote();
        await robot.seesTheChart();
        // Carried over from the list, not fetched again: the same favorites
        // state, read by a second screen.
        robot.seesItIsAFavorite();
        await robot.switchInterval('4h');
        await robot.goBack();
      }),
      Step('pull the quotes list down to refresh it', (
        final CryptoRobot robot,
      ) async {
        await robot.pullToRefresh();
      }),
      Step('the favorite shows up under Favorites', (
        final CryptoRobot robot,
      ) async {
        final String symbol = robot.firstSymbol;
        await robot.openTheFavoritesTab();
        await robot.seesFavorite(symbol);
      }),
      Step('unfavorite it, landing on the empty state', (
        final CryptoRobot robot,
      ) async {
        await robot.unfavoriteFromTheFavoritesTab();
        robot.seesNoFavorites();
        await robot.openTheQuotesTab();
      }),
      Step('adjust the font scale', (final CryptoRobot robot) async {
        await robot.openPreferences();
        await robot.scaleTheFont();
      }),
      Step('switch language away and back', (final CryptoRobot robot) async {
        // Away and back, so the recording shows the whole UI re-render in
        // another language and still finishes in English.
        await robot.chooseLanguage('Português');
        await robot.chooseLanguage('English');
        await robot.goBack();
      }),
      Step('still on the list, still dark', (final CryptoRobot robot) async {
        await robot.seesTheQuotes();
        robot
          ..seesDarkMode()
          ..seesNothingBroken();
      }),
    ],
  );
}
