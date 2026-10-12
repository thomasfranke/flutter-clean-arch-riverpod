import 'dart:async';

import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
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

    /// A container whose preferences have finished their first load.
    Future<ProviderContainer> loadedContainer() async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);
      container.listen(preferencesProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);
      return container;
    }

    test(
      'updateLocale applies the saved locale without reading back',
      () async {
        final ProviderContainer container = await loadedContainer();
        when(
          () => repository.saveLocale('es'),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

        final Failure? failure = await container
            .read(preferencesProvider.notifier)
            .updateLocale('es');

        expect(failure, isNull);
        expect(
          container.read(preferencesProvider),
          PreferencesState.success(tPreferences.copyWith(locale: 'es')),
        );
        verify(() => repository.getPreferences()).called(1);
      },
    );

    test('updateDarkMode applies the saved flag', () async {
      final ProviderContainer container = await loadedContainer();
      when(
        () => repository.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      await container.read(preferencesProvider.notifier).updateDarkMode(true);

      expect(
        container.read(preferencesProvider),
        PreferencesState.success(tPreferences.copyWith(darkMode: true)),
      );
    });

    test('updateFontScale applies the saved scale', () async {
      final ProviderContainer container = await loadedContainer();
      when(
        () => repository.saveFontScale(1.2),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      await container.read(preferencesProvider.notifier).updateFontScale(1.2);

      expect(
        container.read(preferencesProvider),
        PreferencesState.success(tPreferences.copyWith(fontScale: 1.2)),
      );
    });

    test('an update never passes through loading', () async {
      final ProviderContainer container = await loadedContainer();
      when(
        () => repository.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      final List<PreferencesState> seen = <PreferencesState>[];
      container.listen(
        preferencesProvider,
        (_, final PreferencesState next) => seen.add(next),
      );

      await container.read(preferencesProvider.notifier).updateDarkMode(true);
      await Future<void>.delayed(Duration.zero);

      expect(seen, <PreferencesState>[
        PreferencesState.success(tPreferences.copyWith(darkMode: true)),
      ]);
    });

    for (final (
          String name,
          Future<Failure?> Function(PreferencesNotifier) update,
          void Function() failSave,
        )
        in <
          (
            String,
            Future<Failure?> Function(PreferencesNotifier),
            void Function(),
          )
        >[
          (
            'updateLocale',
            (final PreferencesNotifier n) => n.updateLocale('es'),
            () => when(() => repository.saveLocale('es')).thenAnswer(
              (_) async => const Left<Failure, Unit>(Failure.storage()),
            ),
          ),
          (
            'updateDarkMode',
            (final PreferencesNotifier n) => n.updateDarkMode(true),
            () => when(() => repository.saveDarkMode(true)).thenAnswer(
              (_) async => const Left<Failure, Unit>(Failure.storage()),
            ),
          ),
          (
            'updateFontScale',
            (final PreferencesNotifier n) => n.updateFontScale(1.2),
            () => when(() => repository.saveFontScale(1.2)).thenAnswer(
              (_) async => const Left<Failure, Unit>(Failure.storage()),
            ),
          ),
        ]) {
      test(
        '$name that fails returns the failure and keeps the preferences',
        () async {
          final ProviderContainer container = await loadedContainer();
          failSave();

          final Failure? failure = await update(
            container.read(preferencesProvider.notifier),
          );

          expect(failure, const Failure.storage());
          expect(
            container.read(preferencesProvider),
            PreferencesState.success(tPreferences),
          );
        },
      );
    }

    test('a reload that fails keeps the preferences already held', () async {
      final ProviderContainer container = await loadedContainer();
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      final Failure? failure = await container
          .read(preferencesProvider.notifier)
          .loadPreferences();

      expect(failure, const Failure.storage());
      expect(
        container.read(preferencesProvider),
        PreferencesState.success(tPreferences),
      );
    });

    test('a save before the first load reads the preferences back', () async {
      final Completer<Either<Failure, PreferencesEntity>> firstLoad =
          Completer<Either<Failure, PreferencesEntity>>();
      when(
        () => repository.getPreferences(),
      ).thenAnswer((_) => firstLoad.future);
      when(
        () => repository.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);
      container.listen(preferencesProvider, (_, _) {});

      await container.read(preferencesProvider.notifier).updateDarkMode(true);
      firstLoad.complete(
        Right<Failure, PreferencesEntity>(
          tPreferences.copyWith(darkMode: true),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(preferencesProvider),
        PreferencesState.success(tPreferences.copyWith(darkMode: true)),
      );
      verify(() => repository.getPreferences()).called(2);
    });

    test('an answer that arrives after disposal is still returned', () async {
      final ProviderContainer container = await loadedContainer();
      final Completer<Either<Failure, Unit>> save =
          Completer<Either<Failure, Unit>>();
      when(() => repository.saveDarkMode(true)).thenAnswer((_) => save.future);
      final Completer<Either<Failure, PreferencesEntity>> load =
          Completer<Either<Failure, PreferencesEntity>>();

      final PreferencesNotifier notifier = container.read(
        preferencesProvider.notifier,
      );
      final Future<Failure?> pendingSave = notifier.updateDarkMode(true);
      when(() => repository.getPreferences()).thenAnswer((_) => load.future);
      final Future<Failure?> pendingLoad = notifier.loadPreferences();
      container.dispose();
      save.complete(const Left<Failure, Unit>(Failure.storage()));
      load.complete(const Left<Failure, PreferencesEntity>(Failure.storage()));

      expect(await pendingSave, const Failure.storage());
      expect(await pendingLoad, const Failure.storage());
    });

    test('preferencesProvider.overrideWithValue replaces the state', () {
      expect(
        preferencesProvider.overrideWithValue(const PreferencesState.loading()),
        isNotNull,
      );
    });
  });
}
