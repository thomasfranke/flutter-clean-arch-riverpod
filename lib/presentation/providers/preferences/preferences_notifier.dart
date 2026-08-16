import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_notifier.g.dart';

/// Notifier for managing user preferences, including loading, saving, and
/// updating individual preference fields.
@riverpod
class PreferencesNotifier extends _$PreferencesNotifier {
  @override
  PreferencesState build() {
    unawaited(loadPreferences());
    return const PreferencesState.loading();
  }

  /// Loads user preferences and updates the state accordingly.
  Future<void> loadPreferences() async {
    state = const PreferencesState.loading();

    final GetPreferencesUseCase getUseCase = ref.read(
      getPreferencesUseCaseProvider,
    );
    final Either<Failure, PreferencesEntity> result = await getUseCase.call();

    state = result.fold(PreferencesState.failure, PreferencesState.success);
  }

  /// Updates the locale preference and updates the state accordingly.
  Future<void> updateLocale(final String locale) async {
    final UpdateLocaleUseCase useCase = ref.read(updateLocaleUseCaseProvider);
    final Either<Failure, Unit> result = await useCase.call(locale);

    result.fold(
      (final Failure failure) => state = PreferencesState.failure(failure),
      (_) => unawaited(loadPreferences()),
    );
  }

  /// Updates the dark mode preference and updates the state accordingly.
  Future<void> updateDarkMode(final bool darkMode) async {
    final UpdateDarkModeUseCase useCase = ref.read(
      updateDarkModeUseCaseProvider,
    );
    final Either<Failure, Unit> result = await useCase.call(darkMode);

    result.fold(
      (final Failure failure) => state = PreferencesState.failure(failure),
      (_) => unawaited(loadPreferences()),
    );
  }

  /// Updates the font scale preference and updates the state accordingly.
  Future<void> updateFontScale(final double fontScale) async {
    final UpdateFontScaleUseCase useCase = ref.read(
      updateFontScaleUseCaseProvider,
    );
    final Either<Failure, Unit> result = await useCase.call(fontScale);

    result.fold(
      (final Failure failure) => state = PreferencesState.failure(failure),
      (_) => unawaited(loadPreferences()),
    );
  }
}
