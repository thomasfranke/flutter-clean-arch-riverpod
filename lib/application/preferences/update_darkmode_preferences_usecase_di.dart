import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/save_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_darkmode_preferences_usecase_di.g.dart';

/// Riverpod provider for the [UpdateDarkModeUseCase].
@riverpod
UpdateDarkModeUseCase updateDarkModeUseCase(Ref ref) => UpdateDarkModeUseCase(
  getPreferences: ref.watch(getPreferencesUseCaseProvider),
  savePreferences: ref.watch(savePreferencesUseCaseProvider),
);
