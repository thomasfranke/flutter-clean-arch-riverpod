/// Favorites: the one thing the app stores about the user's own choices.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Favorites a quote from the list',
    describe:
        'The star on a row writes to storage and two screens read it back: '
        'the row itself fills in, and the Favorites tab gains an entry. Same '
        'state, two places, which is where a notifier usually gets it wrong.',
    group: 'Favorites',
    steps: <Step>[
      Step('start with a list of prices', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      Step('star the first quote', (final CryptoRobot robot) async {
        await robot.favoriteTheFirstQuote();
      }),
      Step('it shows up under Favorites', (final CryptoRobot robot) async {
        final String symbol = robot.firstSymbol;
        await robot.openTheFavoritesTab();
        await robot.seesFavorite(symbol);
        robot.seesNothingBroken();
      }),
    ],
  );

  scenario(
    'Unfavorites a quote from the Favorites tab',
    describe:
        'Taking the last favorite away has to land on the empty state rather '
        'than on a list of nothing — the case a test that only ever adds '
        'never reaches.',
    group: 'Favorites',
    steps: <Step>[
      Step('favorite one, so there is one to remove', (
        final CryptoRobot robot,
      ) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.favoriteTheFirstQuote();
      }),
      Step('go to Favorites', (final CryptoRobot robot) async {
        final String symbol = robot.firstSymbol;
        await robot.openTheFavoritesTab();
        await robot.seesFavorite(symbol);
      }),
      Step('unstar it', (final CryptoRobot robot) async {
        await robot.unfavoriteFromTheFavoritesTab();
      }),
      Step('the empty state is what is left', (final CryptoRobot robot) async {
        robot
          ..seesNoFavorites()
          ..seesNothingBroken();
      }),
    ],
  );

  scenario(
    'Remembers a favorite across a restart',
    describe:
        'What a favorite is for. The app is started again without wiping '
        'storage, which is the only way to tell a notifier holding state in '
        'memory from one that actually wrote it down.',
    group: 'Favorites',
    steps: <Step>[
      Step('favorite the first quote', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.favoriteTheFirstQuote();
      }),
      Step('start the app again, keeping what was stored', (
        final CryptoRobot robot,
      ) async {
        await robot.launch(fresh: false);
        await robot.seesTheQuotes();
      }),
      Step('Favorites still holds it', (final CryptoRobot robot) async {
        await robot.openTheFavoritesTab();
        await robot.seesAFavorite();
        robot.seesNothingBroken();
      }),
    ],
  );
}
