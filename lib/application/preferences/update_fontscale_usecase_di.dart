import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/save_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_fontscale_usecase_di.g.dart';

/// Riverpod provider for the [UpdateFontScaleUseCase].
@riverpod
UpdateFontScaleUseCase updateFontScaleUseCase(Ref ref) =>
    UpdateFontScaleUseCase(
      getPreferences: ref.watch(getPreferencesUseCaseProvider),
      savePreferences: ref.watch(savePreferencesUseCaseProvider),
    );
