import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';

/// What a [Failure] says to the person holding the phone.
///
/// The translation lives in `presentation/` because it is a UI decision: the
/// layers below hand up a [Failure] so that each screen, not each repository,
/// chooses the words. Its technical message stays in the log.
extension FailureMessage on Failure {
  /// The localized sentence for this failure, in [l10n]'s language.
  String message(final AppLocalizations l10n) => switch (this) {
    ApiNetworkDomainFailure() => l10n.failureNetwork,
    ApiServerDomainFailure() => l10n.failureServer,
    ApiClientNotFoundDomainFailure() => l10n.failureNotFound,
    ApiClientDomainFailure() => l10n.failureClient,
    ParseDomainFailure() => l10n.failureParse,
    SharedPreferencesDomainFailure() => l10n.failureStorage,
    UnexpectedDomainFailure() => l10n.failureUnexpected,
  };
}

/// Shows the failure [pending] completes with, if any, as a [SnackBar].
///
/// For commands — a toggle, a save — whose failure is an event to report,
/// not a state to draw. The messenger and the language are read before the
/// await, so [context] is never touched across the gap.
Future<void> reportFailure(
  final BuildContext context,
  final Future<Failure?> pending,
) async {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final AppLocalizations l10n = AppLocalizations.of(context);
  final Failure? failure = await pending;
  if (failure != null) {
    messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
  }
}
