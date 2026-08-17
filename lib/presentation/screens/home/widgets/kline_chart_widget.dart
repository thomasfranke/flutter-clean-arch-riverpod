import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/klines/kline_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/klines/kline_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Available intervals for the kline chart.
const List<String> kKlineIntervals = <String>['15m', '1h', '4h', '1d'];

/// Widget that displays a kline (candlestick) chart for a given [symbol],
/// with an interval selector and loading/error states.
class KlineChart extends ConsumerWidget {
  /// Creates a [KlineChart] for the given [symbol].
  const KlineChart({required this.symbol, super.key});

  /// The cryptocurrency symbol to display klines for.
  final String symbol;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final KlineState state = ref.watch(klineProvider(symbol));
    final KlineNotifier notifier = ref.read(klineProvider(symbol).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _IntervalSelector(
          current: notifier.currentInterval,
          onSelected: (final String interval) =>
              notifier.switchInterval(interval: interval),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: switch (state) {
            KlineStateInitial() || KlineStateLoading() => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            KlineStateFailure(:final Failure failure) => Center(
              child: Text(
                failure.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            KlineStateSuccess(:final List<Kline> klines) => _Chart(
              klines: klines,
            ),
          },
        ),
      ],
    );
  }
}

/// Interval selector row.
class _IntervalSelector extends StatelessWidget {
  const _IntervalSelector({required this.current, required this.onSelected});

  final String current;
  final void Function(String) onSelected;

  @override
  Widget build(final BuildContext context) => Row(
    children: kKlineIntervals.map((final String interval) {
      final bool isSelected = interval == current;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(interval),
          selected: isSelected,
          onSelected: (_) => onSelected(interval),
        ),
      );
    }).toList(),
  );
}

/// Line chart built from kline data using fl_chart.
class _Chart extends StatelessWidget {
  const _Chart({required this.klines});

  final List<Kline> klines;

  @override
  Widget build(final BuildContext context) {
    if (klines.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).noData,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    final List<FlSpot> spots = klines
        .asMap()
        .entries
        .map(
          (final MapEntry<int, Kline> e) =>
              FlSpot(e.key.toDouble(), e.value.close),
        )
        .toList();

    final double minY = klines
        .map((final Kline k) => k.low)
        .reduce((final double a, final double b) => a < b ? a : b);
    final double maxY = klines
        .map((final Kline k) => k.high)
        .reduce((final double a, final double b) => a > b ? a : b);

    final bool isPositive = klines.last.close >= klines.first.close;
    final Color lineColor = isPositive ? Colors.green : Colors.red;

    return LineChart(
      LineChartData(
        minY: minY * 0.999,
        maxY: maxY * 1.001,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.grey.withAlpha(31), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (final double value, final TitleMeta meta) =>
                  Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (klines.length / 4).ceilToDouble(),
              getTitlesWidget: (final double value, final TitleMeta meta) {
                final int index = value.toInt();
                if (index < 0 || index >= klines.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  DateFormat('HH:mm').format(klines[index].closeTime),
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withAlpha(31),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (final List<LineBarSpot> spots) =>
                spots.map((final LineBarSpot spot) {
                  final Kline kline = klines[spot.x.toInt()];
                  return LineTooltipItem(
                    '${kline.close.toStringAsFixed(4)}\n',
                    TextStyle(
                      color: lineColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: DateFormat('dd/MM HH:mm').format(kline.closeTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
