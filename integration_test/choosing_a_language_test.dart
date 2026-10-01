/// Language: the preference that re-renders every string in the app.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Switches the language, and the whole app re-renders',
    describe:
        'Three locales are shipped, and the screen names them in their own '
        'language — which is also what makes them findable whichever locale '
        'the app is currently in. Each choice has to come back marked.',
    group: 'Preferences',
    steps: <Step>[
      Step('open Preferences', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
        await robot.openPreferences();
      }),
      Step('choose English', (final CryptoRobot robot) async {
        await robot.chooseLanguage('English');
      }),
      Step('choose Spanish', (final CryptoRobot robot) async {
        await robot.chooseLanguage('Español');
      }),
      Step('back to Portuguese', (final CryptoRobot robot) async {
        await robot.chooseLanguage('Português');
        robot.seesLanguageChosen('Português');
      }),
      Step('the list is still there behind it', (
        final CryptoRobot robot,
      ) async {
        await robot.goBack();
        await robot.seesTheQuotes();
        robot.seesNothingBroken();
      }),
    ],
  );
}
