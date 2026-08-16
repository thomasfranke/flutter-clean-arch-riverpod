import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_preferences_usecase_di.g.dart';

/// Riverpod provider for the [GetPreferencesUseCase].
@riverpod
GetPreferencesUseCase getPreferencesUseCase(Ref ref) =>
    GetPreferencesUseCase(repository: ref.watch(preferencesRepositoryProvider));
