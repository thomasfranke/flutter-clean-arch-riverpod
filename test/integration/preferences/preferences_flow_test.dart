import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The real preferences chain, wired the same way `preferences_di.dart`
/// wires it in the app.
typedef _PreferencesStack = ({
  GetPreferencesUseCase getPreferences,
  UpdateDarkModeUseCase updateDarkMode,
  UpdateFontScaleUseCase updateFontScale,
  UpdateLocaleUseCase updateLocale,
});

/// Builds the real preferences chain (use cases -> repository -> datasource
/// -> SharedPreferencesImpl) on top of the shared_preferences plugin's own
/// mock platform channel. Only the platform channel is faked; every class
/// in `lib/` between it and the use cases is the real implementation.
Future<_PreferencesStack> _buildStack() async {
  final SharedPreferencesImpl storage = await SharedPreferencesImpl.create();
  final PreferencesDatasource datasource = PreferencesDatasource(
    storage: storage,
  );
  final PreferencesRepositoryImpl repository = PreferencesRepositoryImpl(
    datasource: datasource,
  );

  return (
    getPreferences: GetPreferencesUseCase(repository: repository),
    updateDarkMode: UpdateDarkModeUseCase(repository: repository),
    updateFontScale: UpdateFontScaleUseCase(repository: repository),
    updateLocale: UpdateLocaleUseCase(repository: repository),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Preferences integration flow', () {
    test('get_preferences on empty storage falls back to PreferencesEntity '
        'defaults instead of failing', () async {
      final _PreferencesStack stack = await _buildStack();

      final Either<Failure, PreferencesEntity> result = await stack
          .getPreferences();

      expect(
        result,
        Right<Failure, PreferencesEntity>(PreferencesEntity.defaults()),
      );
    });

    test(
      'update_darkmode is persisted and reflected by get_preferences',
      () async {
        final _PreferencesStack stack = await _buildStack();

        await stack.updateDarkMode(true);
        final Either<Failure, PreferencesEntity> result = await stack
            .getPreferences();

        expect(
          result.map((final PreferencesEntity e) => e.darkMode),
          const Right<Failure, bool>(true),
        );
      },
    );

    test(
      'update_fontscale is persisted and reflected by get_preferences',
      () async {
        final _PreferencesStack stack = await _buildStack();

        await stack.updateFontScale(1.5);
        final Either<Failure, PreferencesEntity> result = await stack
            .getPreferences();

        expect(
          result.map((final PreferencesEntity e) => e.fontScale),
          const Right<Failure, double>(1.5),
        );
      },
    );

    test(
      'update_locale is persisted and reflected by get_preferences',
      () async {
        final _PreferencesStack stack = await _buildStack();

        await stack.updateLocale('es');
        final Either<Failure, PreferencesEntity> result = await stack
            .getPreferences();

        expect(
          result.map((final PreferencesEntity e) => e.locale),
          const Right<Failure, String>('es'),
        );
      },
    );

    test('updating one preference does not clobber the others already '
        'persisted under their own keys', () async {
      final _PreferencesStack stack = await _buildStack();

      await stack.updateLocale('es');
      await stack.updateDarkMode(true);
      await stack.updateFontScale(1.2);

      final Either<Failure, PreferencesEntity> result = await stack
          .getPreferences();

      expect(
        result,
        const Right<Failure, PreferencesEntity>(
          PreferencesEntity(locale: 'es', darkMode: true, fontScale: 1.2),
        ),
      );
    });
  });
}
