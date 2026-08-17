import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_locale_usecase_di.g.dart';

/// Riverpod provider for the [UpdateLocaleUseCase].
@riverpod
UpdateLocaleUseCase updateLocaleUseCase(Ref ref) =>
    UpdateLocaleUseCase(repository: ref.watch(preferencesRepositoryProvider));
