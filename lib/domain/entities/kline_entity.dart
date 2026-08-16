import 'package:freezed_annotation/freezed_annotation.dart';

part 'kline_entity.freezed.dart';

/// Domain entity representing a single candlestick (kline) data point,
/// containing OHLC price data, volume, and trade count for a given time period.
@freezed
abstract class Kline with _$Kline {
  /// Creates a [Kline] instance with the given parameters.
  const factory Kline({
    required final DateTime openTime,
    required final DateTime closeTime,
    required final double open,
    required final double high,
    required final double low,
    required final double close,
    required final double volume,
    required final int numberOfTrades,
  }) = _Kline;
}
