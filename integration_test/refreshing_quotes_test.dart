/// Pull-to-refresh: asking for the prices again.
library;

import 'support/harness.dart';

void main() {
  scenario(
    'Pulls the list down to refresh it',
    describe:
        'Prices go stale in seconds, so the list has to be re-askable. The '
        'gesture goes through RefreshIndicator into the notifier and out to '
        'the network again, and the list has to survive being replaced.',
    steps: <Step>[
      Step('start with a list of prices', (final CryptoRobot robot) async {
        await robot.launch();
        await robot.seesTheQuotes();
      }),
      Step('pull it down', (final CryptoRobot robot) async {
        await robot.pullToRefresh();
      }),
      Step('the list is still there', (final CryptoRobot robot) async {
        await robot.seesTheQuotes();
        robot.seesNothingBroken();
      }),
    ],
  );
}
