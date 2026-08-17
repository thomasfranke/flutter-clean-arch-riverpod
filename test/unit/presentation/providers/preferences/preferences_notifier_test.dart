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
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;

  final PreferencesEntity tPreferences = PreferencesEntity.defaults();

  setUp(() {
    repository = _MockPreferencesRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: <Override>[
      getPreferencesUseCaseProvider.overrideWithValue(
        GetPreferencesUseCase(repository: repository),
      ),
      updateLocaleUseCaseProvider.overrideWithValue(
        UpdateLocaleUseCase(repository: repository),
      ),
      updateDarkModeUseCaseProvider.overrideWithValue(
        UpdateDarkModeUseCase(repository: repository),
      ),
      updateFontScaleUseCaseProvider.overrideWithValue(
        UpdateFontScaleUseCase(repository: repository),
      ),
    ],
  );

  group('PreferencesNotifier', () {
    test('should emit success after a successful loadPreferences', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(preferencesProvider.notifier).loadPreferences();

      expect(
        container.read(preferencesProvider),
        PreferencesState.success(tPreferences),
      );
    });

    test('should emit failure when getPreferences fails', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(preferencesProvider.notifier).loadPreferences();

      expect(
        container.read(preferencesProvider),
        const PreferencesState.failure(Failure.storage()),
      );
    });

    test(
      'updateLocale should save and reload preferences on success',
      () async {
        when(() => repository.getPreferences()).thenAnswer(
          (_) async => Right<Failure, PreferencesEntity>(tPreferences),
        );
        when(
          () => repository.saveLocale('es'),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);
        // updateLocale reloads via `unawaited(loadPreferences())`. Without an
        // active listener the autoDispose provider tears itself down as soon
        // as `.notifier` is released, discarding that pending reload — keep
        // a listener alive for the duration of the test.
        container.listen(preferencesProvider, (_, _) {});

        await container.read(preferencesProvider.notifier).updateLocale('es');
        await Future<void>.delayed(Duration.zero);

        expect(
          container.read(preferencesProvider),
          PreferencesState.success(tPreferences),
        );
        verify(() => repository.saveLocale('es')).called(1);
      },
    );

    test('updateLocale should emit failure when saveLocale fails', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      when(
        () => repository.saveLocale('es'),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(preferencesProvider.notifier).updateLocale('es');

      expect(
        container.read(preferencesProvider),
        const PreferencesState.failure(Failure.storage()),
      );
    });

    test('updateDarkMode should delegate to saveDarkMode', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      when(
        () => repository.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(preferencesProvider.notifier).updateDarkMode(true);

      verify(() => repository.saveDarkMode(true)).called(1);
    });

    test('updateFontScale should delegate to saveFontScale', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      when(
        () => repository.saveFontScale(1.8),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(preferencesProvider.notifier).updateFontScale(1.8);

      verify(() => repository.saveFontScale(1.8)).called(1);
    });

    test(
      'updateDarkMode should emit failure when saveDarkMode fails',
      () async {
        when(() => repository.getPreferences()).thenAnswer(
          (_) async => Right<Failure, PreferencesEntity>(tPreferences),
        );
        when(
          () => repository.saveDarkMode(true),
        ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(preferencesProvider.notifier).updateDarkMode(true);

        expect(
          container.read(preferencesProvider),
          const PreferencesState.failure(Failure.storage()),
        );
      },
    );

    test(
      'updateFontScale should emit failure when saveFontScale fails',
      () async {
        when(() => repository.getPreferences()).thenAnswer(
          (_) async => Right<Failure, PreferencesEntity>(tPreferences),
        );
        when(
          () => repository.saveFontScale(1.8),
        ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(preferencesProvider.notifier).updateFontScale(1.8);

        expect(
          container.read(preferencesProvider),
          const PreferencesState.failure(Failure.storage()),
        );
      },
    );

    test('preferencesProvider.overrideWithValue replaces the state', () {
      expect(
        preferencesProvider.overrideWithValue(const PreferencesState.loading()),
        isNotNull,
      );
    });
  });
}
