/// Browsing the quotes: the first screen, and the filter above it.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Loads the quotes from the live API',
    describe:
        'The whole app in one assertion: the request Binance answers with '
        'every ticker it has, deserialized into entities and drawn as a list. '
        'Nothing is mocked, so this is also the scenario that fails when the '
        'network does.',
    steps: <Step>[
      Step('start the app', (final CryptoRobot robot) async {
        await robot.launch();
      }),
      Step('the quotes arrive and are drawn', (final CryptoRobot robot) async {
        await robot.seesTheQuotes();
        robot.seesNothingBroken();
      }),
    ],
  );

  scenario(
    'Filters the list down to one symbol',
    describe:
        'What the search field is for. The filter runs over what was already '
        'fetched, so the test is that the list narrows and that everything '
        'left in it actually matches.',
    steps: <Step>[
      Step('start with the whole list', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      Step('filter by the start of the first symbol', (
        final CryptoRobot robot,
      ) async {
        // Taken off the screen rather than hardcoded: which symbol Binance
        // lists first is not something this repository gets to decide.
        await robot.filterBy(robot.firstSymbol.substring(0, 3));
      }),
      Step('everything left matches', (final CryptoRobot robot) async {
        await robot.seesTheQuotes();
        robot.seesOnlyQuotesMatching(robot.firstSymbol.substring(0, 3));
      }),
      Step('clearing it brings the whole list back', (
        final CryptoRobot robot,
      ) async {
        await robot.clearTheFilter();
        await robot.seesTheQuotes();
        robot.seesNothingBroken();
      }),
    ],
  );

  scenario(
    'Shows an empty list for a symbol that does not exist',
    describe:
        'The other half of the filter, and the one nobody writes: a query '
        'matching nothing has to empty the list rather than leave the last '
        'result on screen.',
    steps: <Step>[
      Step('start with the whole list', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      Step('filter by something no symbol contains', (
        final CryptoRobot robot,
      ) async {
        await robot.filterBy('ZZZZZZ');
      }),
      Step('the list is empty', (final CryptoRobot robot) async {
        robot
          ..seesNoQuotes()
          ..seesNothingBroken();
      }),
      Step('clearing it brings the whole list back', (
        final CryptoRobot robot,
      ) async {
        await robot.clearTheFilter();
        await robot.seesTheQuotes();
      }),
    ],
  );
}
