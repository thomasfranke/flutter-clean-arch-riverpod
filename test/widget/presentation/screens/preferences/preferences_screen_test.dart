import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/preferences/preferences_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../test_helpers.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository preferencesRepository;

  setUp(() {
    preferencesRepository = _MockPreferencesRepository();

    when(() => preferencesRepository.getPreferences()).thenAnswer(
      (_) async =>
          Right<Failure, PreferencesEntity>(PreferencesEntity.defaults()),
    );
    when(
      () => preferencesRepository.saveDarkMode(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    when(
      () => preferencesRepository.saveFontScale(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    when(
      () => preferencesRepository.saveLocale(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
  });

  List<Override> overrides() => <Override>[
    preferencesRepositoryProvider.overrideWithValue(preferencesRepository),
  ];

  group('PreferencesScreen', () {
    testWidgets('shows a loading indicator initially', (
      final WidgetTester tester,
    ) async {
      when(() => preferencesRepository.getPreferences()).thenAnswer(
        (_) => Completer<Either<Failure, PreferencesEntity>>().future,
      );

      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the error message when the repository fails', (
      final WidgetTester tester,
    ) async {
      when(() => preferencesRepository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Failure'), findsOneWidget);
    });

    testWidgets('renders the loaded preferences', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Português'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Español'), findsOneWidget);

      final SwitchListTile darkModeSwitch = tester.widget(
        find.byType(SwitchListTile),
      );
      expect(darkModeSwitch.value, false);
    });

    testWidgets('marks the currently selected language with a check', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      final ListTile portugueseTile = tester.widget(
        find.widgetWithText(ListTile, 'Português'),
      );
      expect(portugueseTile.trailing, isA<Icon>());

      final ListTile englishTile = tester.widget(
        find.widgetWithText(ListTile, 'English'),
      );
      expect(englishTile.trailing, isNull);
    });

    testWidgets('toggling dark mode calls the repository and reloads', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();
      await tester.pump();

      verify(() => preferencesRepository.saveDarkMode(true)).called(1);
    });

    testWidgets('dragging the font slider calls the repository', (
      final WidgetTester tester,
    ) async {
      await pumpApp(tester, const PreferencesScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.drag(find.byType(Slider), const Offset(50, 0));
      await tester.pump();
      await tester.pump();

      verify(() => preferencesRepository.saveFontScale(any())).called(1);
    });

    testWidgets(
      'tapping each language calls the repository with the correct locale',
      (final WidgetTester tester) async {
        await pumpApp(
          tester,
          const PreferencesScreen(),
          overrides: overrides(),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('English'));
        await tester.pump();
        await tester.pump();
        verify(() => preferencesRepository.saveLocale('en')).called(1);

        await tester.tap(find.text('Português'));
        await tester.pump();
        await tester.pump();
        verify(() => preferencesRepository.saveLocale('pt')).called(1);

        await tester.tap(find.text('Español'));
        await tester.pump();
        await tester.pump();
        verify(() => preferencesRepository.saveLocale('es')).called(1);
      },
    );
  });
}
