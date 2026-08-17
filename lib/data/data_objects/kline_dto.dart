import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';

/// Data Transfer Object for a single kline (candlestick) returned by the
/// Binance API. The response is a raw list, so no fromJson annotation is
/// used — fields are parsed by position.
class KlineDTO {
  /// Creates a [KlineDTO] with the given parameters.
  const KlineDTO({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
    required this.numberOfTrades,
  });

  /// Parses a [KlineDTO] from a raw list returned by the Binance API.
  ///
  /// Binance returns klines as positional arrays, not JSON objects:
  /// [openTime, open, high, low, close, volume, closeTime, quoteVolume,
  ///  numberOfTrades, takerBuyBase, takerBuyQuote, ignore]
  ///
  /// Missing elements or fields of an unexpected type fall back to safe
  /// defaults instead of throwing, so a single malformed candle doesn't
  /// abort parsing the whole response.
  factory KlineDTO.fromList(final List<dynamic> list) => KlineDTO(
    openTime: _asInt(_at(list, 0)),
    open: _asString(_at(list, 1)),
    high: _asString(_at(list, 2)),
    low: _asString(_at(list, 3)),
    close: _asString(_at(list, 4)),
    volume: _asString(_at(list, 5)),
    closeTime: _asInt(_at(list, 6)),
    numberOfTrades: _asInt(_at(list, 8)),
  );

  /// Returns the element at [index], or `null` if [list] is too short.
  static dynamic _at(final List<dynamic> list, final int index) =>
      index < list.length ? list[index] : null;

  /// Coerces [value] to an [int], defaulting to `0` when it isn't a valid
  /// number.
  static int _asInt(final dynamic value) => switch (value) {
    final int v => v,
    final num v => v.toInt(),
    final String v => int.tryParse(v) ?? 0,
    _ => 0,
  };

  /// Coerces [value] to a [String], defaulting to `'0'` when absent.
  static String _asString(final dynamic value) => switch (value) {
    final String v => v,
    final num v => v.toString(),
    _ => '0',
  };

  /// The open time of the kline in milliseconds since epoch.
  final int openTime;

  /// The open price of the kline.
  final String open;

  /// The high price of the kline.
  final String high;

  /// The low price of the kline.
  final String low;

  /// The close price of the kline.
  final String close;

  /// The volume of the kline.
  final String volume;

  /// The close time of the kline in milliseconds since epoch.
  final int closeTime;

  /// The number of trades in the kline.
  final int numberOfTrades;

  /// Converts this DTO to a [Kline] domain entity.
  Kline toEntity() => Kline(
    openTime: DateTime.fromMillisecondsSinceEpoch(openTime),
    closeTime: DateTime.fromMillisecondsSinceEpoch(closeTime),
    open: double.tryParse(open) ?? 0.0,
    high: double.tryParse(high) ?? 0.0,
    low: double.tryParse(low) ?? 0.0,
    close: double.tryParse(close) ?? 0.0,
    volume: double.tryParse(volume) ?? 0.0,
    numberOfTrades: numberOfTrades,
  );
}
