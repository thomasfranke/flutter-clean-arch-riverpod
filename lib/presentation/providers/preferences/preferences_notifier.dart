import 'dart:async';

import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_notifier.g.dart';

/// Notifier for managing user preferences, including loading, saving, and
/// updating individual preference fields.
///
/// The whole app is themed, sized and translated from this state, so once a
/// value is loaded it is never replaced by `loading` or `failure` again: a
/// frame drawn from either would fall back to the defaults. A failed save
/// leaves the state as it was and is returned to the caller, which is the
/// one that can tell the user.
@riverpod
class PreferencesNotifier extends _$PreferencesNotifier {
  @override
  PreferencesState build() {
    unawaited(loadPreferences());
    return const PreferencesState.loading();
  }

  /// Loads user preferences, returning the [Failure] if the read failed.
  ///
  /// The state becomes `failure` only when nothing was loaded before; a
  /// failed reload keeps the preferences already held.
  Future<Failure?> loadPreferences() async {
    final GetPreferencesUseCase getUseCase = ref.read(
      getPreferencesUseCaseProvider,
    );
    final Either<Failure, PreferencesEntity> result = await getUseCase.call();

    if (!ref.mounted) {
      return result.fold((final Failure failure) => failure, (_) => null);
    }
    return result.fold(
      (final Failure failure) {
        if (state is! PreferencesStateSuccess) {
          state = PreferencesState.failure(failure);
        }
        return failure;
      },
      (final PreferencesEntity preferences) {
        state = PreferencesState.success(preferences);
        return null;
      },
    );
  }

  /// Updates the locale preference, returning the [Failure] if it was not
  /// saved.
  Future<Failure?> updateLocale(final String locale) => _update(
    ref.read(updateLocaleUseCaseProvider).call(locale),
    (final PreferencesEntity p) => p.copyWith(locale: locale),
  );

  /// Updates the dark mode preference, returning the [Failure] if it was not
  /// saved.
  Future<Failure?> updateDarkMode(final bool darkMode) => _update(
    ref.read(updateDarkModeUseCaseProvider).call(darkMode),
    (final PreferencesEntity p) => p.copyWith(darkMode: darkMode),
  );

  /// Updates the font scale preference, returning the [Failure] if it was not
  /// saved.
  Future<Failure?> updateFontScale(final double fontScale) => _update(
    ref.read(updateFontScaleUseCaseProvider).call(fontScale),
    (final PreferencesEntity p) => p.copyWith(fontScale: fontScale),
  );

  /// Waits for [save] and, once storage has agreed, applies the same change
  /// to the preferences held — rather than reading them all back, which is
  /// what used to pass the app through `loading`.
  Future<Failure?> _update(
    final Future<Either<Failure, Unit>> save,
    final PreferencesEntity Function(PreferencesEntity) apply,
  ) async {
    final Either<Failure, Unit> result = await save;

    if (!ref.mounted) {
      return result.fold((final Failure failure) => failure, (_) => null);
    }
    return result.fold((final Failure failure) => failure, (_) {
      switch (state) {
        case PreferencesStateSuccess(:final PreferencesEntity preferences):
          state = PreferencesState.success(apply(preferences));
        default:
          // Saved before anything was loaded: read it back whole.
          unawaited(loadPreferences());
      }
      return null;
    });
  }
}
