/// The detail screen: one symbol, its numbers, and its price history.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Opens a quote and draws its price history',
    describe:
        'A second request, for a second screen: the klines behind the chart. '
        'It is the one place the app draws something rather than listing it, '
        'and the only screen with a chart on it.',
    group: 'Detail',
    steps: <Step>[
      Step('start with a list of prices', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      Step('open the first one', (final CryptoRobot robot) async {
        await robot.openTheFirstQuote();
      }),
      Step('the chart is drawn', (final CryptoRobot robot) async {
        await robot.seesTheChart();
        robot.seesNothingBroken();
      }),
      Step('going back lands on the list again', (
        final CryptoRobot robot,
      ) async {
        await robot.goBack();
        await robot.seesTheQuotes();
      }),
    ],
  );

  scenario(
    'Switches the chart interval',
    describe:
        'The interval chips are a second fetch of the same screen, keyed by '
        'the interval — which is what makes them the cheapest way to prove '
        'the provider family is keyed the way it thinks it is.',
    group: 'Detail',
    steps: <Step>[
      Step('open a quote', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.openTheFirstQuote();
        await robot.seesTheChart();
      }),
      Step('ask for four-hour candles', (final CryptoRobot robot) async {
        await robot.switchInterval('4h');
      }),
      Step('ask for daily candles', (final CryptoRobot robot) async {
        await robot.switchInterval('1d');
        robot.seesNothingBroken();
      }),
    ],
  );
}
