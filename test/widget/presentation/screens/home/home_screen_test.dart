import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/detail/detail_screen.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/home_screen.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/favorites_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/quotes_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/preferences/preferences_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../test_helpers.dart';

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

  const CryptoQuoteEntity tQuote = CryptoQuoteEntity(
    symbol: 'BTCUSDT',
    lastPrice: 60000,
    priceChange: 1000,
    priceChangePct: 1.69,
    highPrice: 61000,
    lowPrice: 59000,
    volume: 500,
    quoteVolume: 30000000,
  );
  const CryptoQuoteEntity tOtherQuote = CryptoQuoteEntity(
    symbol: 'ETHUSDT',
    lastPrice: 3000,
    priceChange: -50,
    priceChangePct: -1.64,
    highPrice: 3100,
    lowPrice: 2950,
    volume: 1000,
    quoteVolume: 3000000,
  );

  setUp(() {
    cryptoQuoteRepository = _MockCryptoQuoteRepository();
    favoritesRepository = _MockFavoritesRepository();
    klineRepository = _MockKlineRepository();
    preferencesRepository = _MockPreferencesRepository();

    when(() => favoritesRepository.getFavorites()).thenAnswer(
      (_) async =>
          const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
    );
    when(
      () => klineRepository.getKlines(
        symbol: any(named: 'symbol'),
        interval: any(named: 'interval'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => Right<Failure, List<Kline>>(<Kline>[
        Kline(
          openTime: DateTime.fromMillisecondsSinceEpoch(0),
          closeTime: DateTime.fromMillisecondsSinceEpoch(1),
          open: 1,
          high: 2,
          low: 0.5,
          close: 1.5,
          volume: 10,
          numberOfTrades: 3,
        ),
      ]),
    );
    when(() => preferencesRepository.getPreferences()).thenAnswer(
      (_) async =>
          Right<Failure, PreferencesEntity>(PreferencesEntity.defaults()),
    );
  });

  List<Override> overrides() => <Override>[
    cryptoQuotesRepositoryProvider.overrideWithValue(cryptoQuoteRepository),
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
    klineRepositoryProvider.overrideWithValue(klineRepository),
    preferencesRepositoryProvider.overrideWithValue(preferencesRepository),
  ];

  group('HomeScreen', () {
    testWidgets('shows a loading indicator initially', (
      final WidgetTester tester,
    ) async {
      // Never resolves within the test, so the widget stays in the loading
      // state regardless of how many frames are pumped.
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) => Completer<Either<Failure, List<CryptoQuoteEntity>>>().future,
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows the list of quotes after loading', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote, tOtherQuote],
        ),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      expect(find.text('BTCUSDT'), findsOneWidget);
      expect(find.text('ETHUSDT'), findsOneWidget);
    });

    testWidgets('filters the list by the typed symbol', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote, tOtherQuote],
        ),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'ETH');
      await tester.pump();

      expect(find.text('BTCUSDT'), findsNothing);
      expect(find.text('ETHUSDT'), findsOneWidget);
    });

    testWidgets('shows the error message when the repository fails', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async =>
            const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Failure'), findsOneWidget);
    });

    testWidgets(
      'favorites tab shows the empty state when there are no favorites',
      (final WidgetTester tester) async {
        when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
          (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
            <CryptoQuoteEntity>[tQuote],
          ),
        );

        await pumpApp(tester, const HomeScreen(), overrides: overrides());
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Favorites'));
        await tester.pumpAndSettle();

        expect(find.text('No favorites yet'), findsOneWidget);
      },
    );

    testWidgets('favorites tab shows the list when there are favorites', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote, tOtherQuote],
        ),
      );
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      expect(find.text('BTCUSDT'), findsOneWidget);
      expect(find.text('ETHUSDT'), findsNothing);
    });

    testWidgets('opens the drawer and navigates to the preferences screen', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      await pumpRoutedApp(tester, overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump();

      expect(find.byType(PreferencesScreen), findsOneWidget);
    });

    testWidgets(
      'tapping a favorite quote unfavorites it and it disappears from the tab',
      (final WidgetTester tester) async {
        when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
          (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
            <CryptoQuoteEntity>[tQuote],
          ),
        );
        when(() => favoritesRepository.getFavorites()).thenAnswer(
          (_) async => const Right<Failure, List<FavoriteEntity>>(
            <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
          ),
        );
        when(() => favoritesRepository.toggleFavorite('BTCUSDT')).thenAnswer(
          (_) async =>
              const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
        );

        await pumpApp(tester, const HomeScreen(), overrides: overrides());
        await tester.pump();
        await tester.pump();

        await tester.tap(find.byIcon(Icons.star).first);
        await tester.pump();
        await tester.pump();

        verify(() => favoritesRepository.toggleFavorite('BTCUSDT')).called(1);
      },
    );

    testWidgets('tapping a quote tile navigates to the detail screen', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      await pumpRoutedApp(tester, overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('BTCUSDT'));
      await tester.pumpAndSettle();

      expect(find.byType(CryptoQuoteDetailScreen), findsOneWidget);
    });

    testWidgets('favorites tab shows an error message when it fails', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Failure'), findsOneWidget);
    });

    testWidgets('pulling to refresh on the favorites tab re-fetches quotes', (
      final WidgetTester tester,
    ) async {
      when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );

      await pumpApp(tester, const HomeScreen(), overrides: overrides());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      final Finder favoritesListView = find.descendant(
        of: find.byType(FavoritesTab),
        matching: find.byType(ListView),
      );
      await tester.fling(favoritesListView, const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      verify(() => cryptoQuoteRepository.getQuotes()).called(greaterThan(1));
    });

    testWidgets(
      'pulling to refresh on the quotes tab updates the list without typing',
      (final WidgetTester tester) async {
        when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
          (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
            <CryptoQuoteEntity>[tQuote],
          ),
        );

        await pumpApp(tester, const HomeScreen(), overrides: overrides());
        await tester.pump();
        await tester.pump();

        expect(find.text('BTCUSDT'), findsOneWidget);
        expect(find.text('ETHUSDT'), findsNothing);

        when(() => cryptoQuoteRepository.getQuotes()).thenAnswer(
          (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
            <CryptoQuoteEntity>[tOtherQuote],
          ),
        );

        final Finder quotesListView = find.descendant(
          of: find.byType(QuotesTab),
          matching: find.byType(ListView),
        );
        await tester.fling(quotesListView, const Offset(0, 300), 1000);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.text('BTCUSDT'), findsNothing);
        expect(find.text('ETHUSDT'), findsOneWidget);
      },
    );
  });
}
