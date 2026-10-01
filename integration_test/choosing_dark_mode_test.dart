/// Dark mode: the preference that repaints the whole app.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Switches to dark mode',
    describe:
        'One switch, and every screen changes — the preference goes through '
        'storage and comes back as the theme the root widget builds with, so '
        'what is asserted is the brightness, not the switch.',
    group: 'Preferences',
    steps: <Step>[
      Step('start the app, drawn light', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        robot.seesLightMode();
      }),
      Step('open Preferences', (final CryptoRobot robot) async {
        await robot.openPreferences();
      }),
      Step('turn dark mode on', (final CryptoRobot robot) async {
        await robot.turnOnDarkMode();
      }),
      Step('the app is dark, list and all', (final CryptoRobot robot) async {
        await robot.goBack();
        await robot.seesTheQuotes();
        robot
          ..seesDarkMode()
          ..seesNothingBroken();
      }),
    ],
  );

  scenario(
    'Remembers dark mode across a restart',
    describe:
        'A theme that reverted on the next launch would be a preference '
        'nobody asked for twice. The app is started again without wiping '
        'storage, and has to come up dark.',
    group: 'Preferences',
    steps: <Step>[
      Step('turn dark mode on', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.openPreferences();
        await robot.turnOnDarkMode();
      }),
      Step('start the app again, keeping what was stored', (
        final CryptoRobot robot,
      ) async {
        await robot.launch(fresh: false);
        await robot.seesTheQuotes();
      }),
      Step('it comes up dark', (final CryptoRobot robot) async {
        robot
          ..seesDarkMode()
          ..seesNothingBroken();
      }),
    ],
  );
}
