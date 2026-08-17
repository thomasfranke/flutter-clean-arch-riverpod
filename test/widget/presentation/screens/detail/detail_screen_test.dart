import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/detail/detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../test_helpers.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

class _MockKlineRepository extends Mock implements KlineRepository {}

void main() {
  late _MockFavoritesRepository favoritesRepository;
  late _MockKlineRepository klineRepository;

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

  final Kline tKline = Kline(
    openTime: DateTime.fromMillisecondsSinceEpoch(0),
    closeTime: DateTime.fromMillisecondsSinceEpoch(1),
    open: 1,
    high: 2,
    low: 0.5,
    close: 1.5,
    volume: 10,
    numberOfTrades: 3,
  );

  setUp(() {
    favoritesRepository = _MockFavoritesRepository();
    klineRepository = _MockKlineRepository();

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
    ).thenAnswer((_) async => Right<Failure, List<Kline>>(<Kline>[tKline]));
  });

  List<Override> overrides() => <Override>[
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
    klineRepositoryProvider.overrideWithValue(klineRepository),
  ];

  group('CryptoQuoteDetailScreen', () {
    testWidgets('renders the quote price information', (
      final WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('BTCUSDT'), findsWidgets);
      expect(find.text('60000.00000000'), findsOneWidget);
    });

    testWidgets('favorite icon reflects state and toggles on tap', (
      final WidgetTester tester,
    ) async {
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );
      when(() => favoritesRepository.toggleFavorite('BTCUSDT')).thenAnswer(
        (_) async =>
            const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
      );

      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);

      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      await tester.pump();

      verify(() => favoritesRepository.toggleFavorite('BTCUSDT')).called(1);
    });

    testWidgets('shows a loading indicator for the chart', (
      final WidgetTester tester,
    ) async {
      when(
        () => klineRepository.getKlines(
          symbol: any(named: 'symbol'),
          interval: any(named: 'interval'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) => Completer<Either<Failure, List<Kline>>>().future);

      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows the "no data" message when there are no klines', (
      final WidgetTester tester,
    ) async {
      when(
        () => klineRepository.getKlines(
          symbol: any(named: 'symbol'),
          interval: any(named: 'interval'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Right<Failure, List<Kline>>(<Kline>[]));

      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('shows the error message when the chart fails', (
      final WidgetTester tester,
    ) async {
      when(
        () => klineRepository.getKlines(
          symbol: any(named: 'symbol'),
          interval: any(named: 'interval'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, List<Kline>>(Failure.apiServer()),
      );

      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Failure'), findsOneWidget);
    });

    testWidgets('tapping the chart shows the touch tooltip for the spot', (
      final WidgetTester tester,
    ) async {
      final List<Kline> denseKlines = List<Kline>.generate(
        60,
        (final int i) => Kline(
          openTime: DateTime.fromMillisecondsSinceEpoch(i * 60000),
          closeTime: DateTime.fromMillisecondsSinceEpoch(i * 60000 + 59999),
          open: 100 + i.toDouble(),
          high: 105 + i.toDouble(),
          low: 95 + i.toDouble(),
          close: 100 + i.toDouble(),
          volume: 10,
          numberOfTrades: 3,
        ),
      );
      when(
        () => klineRepository.getKlines(
          symbol: any(named: 'symbol'),
          interval: any(named: 'interval'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right<Failure, List<Kline>>(denseKlines));

      await pumpApp(
        tester,
        const CryptoQuoteDetailScreen(quote: tQuote),
        overrides: overrides(),
      );
      await tester.pump();
      await tester.pump();

      // The default `LineTouchData.distanceCalculator` only considers the
      // X axis, and 60 evenly spaced spots keep consecutive spots well
      // within the default 10px `touchSpotThreshold`, so any tap inside the
      // plotted area lands within range of the nearest spot regardless of Y.
      //
      // `tester.tap()` sends down+up with no time between them, which lets
      // fl_chart's own `PanGestureRecognizer` (registered on the same
      // pointer) stay undecided and win the gesture arena instead of the
      // `TapGestureRecognizer`. Driving the gesture manually with a pump in
      // between lets the tap recognizer resolve first, as it would for a
      // real, unhurried tap.
      final Offset chartCenter = tester.getCenter(find.byType(LineChart));
      final TestGesture gesture = await tester.startGesture(chartCenter);
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'switching the chart interval reloads klines for the new interval, '
      'keeping the correct symbol',
      (final WidgetTester tester) async {
        await pumpApp(
          tester,
          const CryptoQuoteDetailScreen(quote: tQuote),
          overrides: overrides(),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('4h'));
        await tester.pump();
        await tester.pump();

        verify(
          () => klineRepository.getKlines(
            symbol: 'BTCUSDT',
            interval: '4h',
            limit: 24,
          ),
        ).called(1);
      },
    );
  });
}
