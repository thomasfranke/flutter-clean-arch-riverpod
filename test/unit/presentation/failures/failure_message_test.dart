import 'package:flutter/widgets.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/presentation/failures/failure_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final AppLocalizations en = lookupAppLocalizations(const Locale('en'));
  final AppLocalizations pt = lookupAppLocalizations(const Locale('pt'));

  group('FailureMessage.message', () {
    final Map<Failure, String> expected = <Failure, String>{
      const Failure.apiNetwork('socket closed'): en.failureNetwork,
      const Failure.apiServer('500'): en.failureServer,
      const Failure.apiNotFound(): en.failureNotFound,
      const Failure.apiClient(): en.failureClient,
      const Failure.parse(): en.failureParse,
      const Failure.storage(): en.failureStorage,
      const Failure.unexpected(): en.failureUnexpected,
    };

    for (final MapEntry<Failure, String> entry in expected.entries) {
      test('${entry.key} reads as its own sentence', () {
        expect(entry.key.message(en), entry.value);
      });
    }

    test('never shows the technical message', () {
      expect(
        const Failure.apiNetwork('socket closed').message(en),
        isNot(contains('socket')),
      );
    });

    test('follows the language it is given', () {
      expect(const Failure.storage().message(pt), pt.failureStorage);
      expect(pt.failureStorage, isNot(en.failureStorage));
    });
  });
}
