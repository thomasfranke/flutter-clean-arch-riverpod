import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_fontscale_usecase_di.g.dart';

/// Riverpod provider for the [UpdateFontScaleUseCase].
@riverpod
UpdateFontScaleUseCase updateFontScaleUseCase(Ref ref) =>
    UpdateFontScaleUseCase(
      repository: ref.watch(preferencesRepositoryProvider),
    );
