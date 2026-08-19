import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/theme/app_theme.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockCryptoQuoteRepository extends Mock
    implements CryptoQuoteRepository {}

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

class _MockKlineRepository extends Mock implements KlineRepository {}

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockCryptoQuoteRepository cryptoQuoteRepository;
  late _MockFavoritesRepository favoritesRepository;
  late _MockKlineRepository klineRepository;
  late _MockPreferencesRepository preferencesRepository;

  setUp(() {
    cryptoQuoteRepository = _MockCryptoQuoteRepository();
    favoritesRepository = _MockFavoritesRepository();
    klineRepository = _MockKlineRepository();
    preferencesRepository = _MockPreferencesRepository();

    when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
      (_) async =>
          const Right<Failure, List<CryptoQuoteEntity>>(<CryptoQuoteEntity>[]),
    );
    when(() => favoritesRepository.getFavorites()).thenAnswer(
      (_) async =>
          const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
    );
  });

  List<Override> overrides() => <Override>[
    cryptoQuotesRepositoryProvider.overrideWithValue(cryptoQuoteRepository),
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
    klineRepositoryProvider.overrideWithValue(klineRepository),
    preferencesRepositoryProvider.overrideWithValue(preferencesRepository),
  ];

  /// Pumps [app.MyApp] itself — the same widget `main()` hands to `runApp`.
  Future<MaterialApp> pumpMyApp(final WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: overrides(), child: const app.MyApp()),
    );
    await tester.pump();
    await tester.pump();
    return tester.widget<MaterialApp>(find.byType(MaterialApp));
  }

  void stubPreferences(final PreferencesEntity preferences) => when(
    () => preferencesRepository.getPreferences(),
  ).thenAnswer((_) async => Right<Failure, PreferencesEntity>(preferences));

  group('MyApp', () {
    testWidgets('falls back to default preferences while they are loading', (
      final WidgetTester tester,
    ) async {
      // Never completes: keeps the notifier in its loading state, which is
      // the `_ => PreferencesEntity.defaults()` branch.
      when(() => preferencesRepository.getPreferences()).thenAnswer(
        (_) => Completer<Either<Failure, PreferencesEntity>>().future,
      );

      await tester.pumpWidget(
        ProviderScope(overrides: overrides(), child: const app.MyApp()),
      );
      await tester.pump();

      final MaterialApp materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      final PreferencesEntity defaults = PreferencesEntity.defaults();

      expect(materialApp.locale, Locale(defaults.locale));
      expect(materialApp.themeMode, ThemeMode.light);
    });

    testWidgets('falls back to default preferences when loading fails', (
      final WidgetTester tester,
    ) async {
      when(() => preferencesRepository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      final MaterialApp materialApp = await pumpMyApp(tester);

      expect(materialApp.locale, Locale(PreferencesEntity.defaults().locale));
      expect(materialApp.themeMode, ThemeMode.light);
    });

    testWidgets('applies the loaded locale and dark mode', (
      final WidgetTester tester,
    ) async {
      stubPreferences(
        const PreferencesEntity(locale: 'es', darkMode: true, fontScale: 1),
      );

      final MaterialApp materialApp = await pumpMyApp(tester);

      expect(materialApp.locale, const Locale('es'));
      expect(materialApp.themeMode, ThemeMode.dark);
    });

    testWidgets('applies the loaded font scale through a MediaQuery builder', (
      final WidgetTester tester,
    ) async {
      stubPreferences(
        const PreferencesEntity(locale: 'en', darkMode: false, fontScale: 1.5),
      );

      await pumpMyApp(tester);

      expect(
        tester
            .widgetList<MediaQuery>(find.byType(MediaQuery))
            .any(
              (final MediaQuery m) =>
                  m.data.textScaler == const TextScaler.linear(1.5),
            ),
        isTrue,
      );
    });

    testWidgets('wires up routing, l10n and both themes', (
      final WidgetTester tester,
    ) async {
      stubPreferences(PreferencesEntity.defaults());

      final MaterialApp materialApp = await pumpMyApp(tester);

      expect(materialApp.routerConfig, isNotNull);
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
      expect(materialApp.theme?.brightness, AppTheme().light.brightness);
      expect(materialApp.darkTheme?.brightness, AppTheme().dark.brightness);
      expect(materialApp.supportedLocales, isNotEmpty);
      expect(materialApp.localizationsDelegates, isNotNull);
    });
  });

  group('main()', () {
    testWidgets('boots the app with a real SharedPreferences override', (
      final WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      // `app.main()`, not `main()`: the latter is this test file's own entry
      // point, and calling it re-runs the whole declaration block.
      await tester.runAsync(() async {
        app.main();
        // Let `SharedPreferencesImpl.create()` resolve before pumping.
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();

      expect(find.byType(app.MyApp), findsOneWidget);

      // The override `main()` installs must be the real storage impl, not
      // whatever `storageProvider` would build on its own.
      final ProviderScope scope = tester.widget<ProviderScope>(
        find.byType(ProviderScope),
      );
      final ProviderContainer container = ProviderScope.containerOf(
        tester.element(find.byType(app.MyApp)),
      );

      expect(scope.overrides, hasLength(1));
      expect(container.read(storageProvider), isA<SharedPreferencesImpl>());
    });
  });
}
