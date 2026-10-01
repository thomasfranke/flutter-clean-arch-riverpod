/// Font scale: the preference that resizes every label on screen.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Scales the font',
    describe:
        'The slider feeds a MediaQuery textScaler wrapped around the whole '
        'app, so the thing worth checking is that the list below still lays '
        'out — a scale nothing honours looks identical to one that works.',
    group: 'Preferences',
    steps: <Step>[
      Step('open Preferences', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.openPreferences();
      }),
      Step('drag the font scale up', (final CryptoRobot robot) async {
        await robot.scaleTheFont();
      }),
      Step('the quotes list still lays out', (final CryptoRobot robot) async {
        await robot.goBack();
        await robot.seesTheQuotes();
        robot.seesNothingBroken();
      }),
    ],
  );
}
