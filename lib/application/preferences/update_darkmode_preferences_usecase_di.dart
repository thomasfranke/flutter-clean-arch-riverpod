import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_darkmode_preferences_usecase_di.g.dart';

/// Riverpod provider for the [UpdateDarkModeUseCase].
@riverpod
UpdateDarkModeUseCase updateDarkModeUseCase(Ref ref) =>
    UpdateDarkModeUseCase(repository: ref.watch(preferencesRepositoryProvider));
