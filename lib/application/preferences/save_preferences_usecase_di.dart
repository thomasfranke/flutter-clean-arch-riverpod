import 'package:flutter_clean_arch_riverpod/application/preferences/save_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_preferences_usecase_di.g.dart';

/// Riverpod provider for the [SavePreferencesUseCase].
@riverpod
SavePreferencesUseCase savePreferencesUseCase(Ref ref) =>
    SavePreferencesUseCase(
      repository: ref.watch(preferencesRepositoryProvider),
    );
