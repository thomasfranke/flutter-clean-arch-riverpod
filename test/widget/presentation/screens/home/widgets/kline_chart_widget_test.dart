import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/failures/failure_message_mapper.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/kline_chart_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../test_helpers.dart';

class _MockKlineRepository extends Mock implements KlineRepositoryInterface {}

KlineEntity _candle(final int hour) => KlineEntity(
  openTime: DateTime.utc(2026, 10, 11, hour),
  closeTime: DateTime.utc(2026, 10, 11, hour + 1),
  open: 1,
  high: 2,
  low: 0.5,
  close: 1.5,
  volume: 10,
  numberOfTrades: 3,
);

void main() {
  late _MockKlineRepository klineRepository;

  setUp(() {
    klineRepository = _MockKlineRepository();
  });

  List<Override> overrides() => <Override>[
    klineRepositoryProvider.overrideWithValue(klineRepository),
  ];

  void answerWith(final Either<Failure, List<KlineEntity>> answer) {
    when(
      () => klineRepository.getKlines(
        symbol: any(named: 'symbol'),
        interval: any(named: 'interval'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => answer);
  }

  Future<void> pumpChart(final WidgetTester tester) async {
    await pumpApp(
      tester,
      const KlineChartWidget(symbol: 'BTCUSDT'),
      overrides: overrides(),
    );
    await tester.pumpAndSettle();
  }

  group('KlineChartWidget', () {
    testWidgets('offers every interval the chart can be read at', (
      final WidgetTester tester,
    ) async {
      answerWith(Right<Failure, List<KlineEntity>>(<KlineEntity>[_candle(12)]));

      await pumpChart(tester);

      for (final String interval in kKlineIntervals) {
        expect(
          find.text(interval),
          findsOneWidget,
          reason: '$interval is selectable',
        );
      }
    });

    testWidgets('draws the chart once the candles arrive', (
      final WidgetTester tester,
    ) async {
      answerWith(
        Right<Failure, List<KlineEntity>>(<KlineEntity>[
          _candle(12),
          _candle(13),
        ]),
      );

      await pumpChart(tester);

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('says what went wrong instead of drawing an empty chart', (
      final WidgetTester tester,
    ) async {
      answerWith(const Left<Failure, List<KlineEntity>>(Failure.apiNetwork()));

      await pumpChart(tester);

      final BuildContext context = tester.element(
        find.byType(KlineChartWidget),
      );
      expect(
        find.text(
          const Failure.apiNetwork().message(AppLocalizations.of(context)),
        ),
        findsOneWidget,
      );
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('asks again at the interval that was tapped', (
      final WidgetTester tester,
    ) async {
      answerWith(Right<Failure, List<KlineEntity>>(<KlineEntity>[_candle(12)]));
      await pumpChart(tester);

      await tester.tap(find.text('1d'));
      await tester.pumpAndSettle();

      verify(
        () => klineRepository.getKlines(
          symbol: 'BTCUSDT',
          interval: '1d',
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  });
}
