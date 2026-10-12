import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_quote_dto.freezed.dart';
part 'crypto_quote_dto.g.dart';

/// Data Transfer Object (DTO) for cryptocurrency quotes, used for parsing
/// API responses.
@freezed
abstract class CryptoQuoteDTO with _$CryptoQuoteDTO {
  /// Creates a [CryptoQuoteDTO] instance with the given parameters.
  const factory CryptoQuoteDTO({
    /// The symbol of the cryptocurrency pair (e.g., "BTCUSDT").
    required final String? symbol,

    /// The price change over the last 24 hours.
    required final String? priceChange,

    /// The percentage price change over the last 24 hours.
    required final String? priceChangePercent,

    /// The weighted average price over the last 24 hours.
    required final String? weightedAvgPrice,

    /// The previous closing price.
    required final String? prevClosePrice,

    /// The current price.
    required final String? lastPrice,

    /// The quantity of the last trade.
    required final String? lastQty,

    /// The highest bid price.
    required final String? bidPrice,

    /// The quantity of the highest bid.
    required final String? bidQty,

    /// The lowest ask price.
    required final String? askPrice,

    /// The quantity of the lowest ask.
    required final String? askQty,

    /// The opening price 24 hours ago.
    required final String? openPrice,

    /// The highest price over the last 24 hours.
    required final String? highPrice,

    /// The lowest price over the last 24 hours.
    required final String? lowPrice,

    /// The total traded base asset volume over the last 24 hours.
    required final String? volume,

    /// The total traded quote asset volume over the last 24 hours.
    required final String? quoteVolume,

    /// The open time of the 24-hour period.
    required final int? openTime,

    /// The close time of the 24-hour period.
    required final int? closeTime,

    /// The first trade ID in the 24-hour period.
    required final int? firstId,

    /// The last trade ID in the 24-hour period.
    required final int? lastId,

    /// The total number of trades over the last 24 hours.
    required final int? count,
  }) = _CryptoQuoteDTO;

  /// Creates a [CryptoQuoteDTO] from a JSON map.
  factory CryptoQuoteDTO.fromJson(final Map<String, dynamic> json) =>
      _$CryptoQuoteDTOFromJson(json);
}

/// Extension method to convert [CryptoQuoteDTO] to the
/// domain entity [CryptoQuoteEntity].
extension CryptoQuoteDTOMapper on CryptoQuoteDTO {
  /// Converts this DTO to a [CryptoQuoteEntity], or `null` when the symbol is
  /// missing or any price or volume is not a number.
  ///
  /// Null rather than `0.0`: a quote whose price defaulted to zero cannot be
  /// told apart from a coin that is worth nothing.
  CryptoQuoteEntity? toEntity() => switch ((
    symbol,
    _number(lastPrice),
    _number(priceChange),
    _number(priceChangePercent),
    _number(highPrice),
    _number(lowPrice),
    _number(volume),
    _number(quoteVolume),
  )) {
    (
      final String symbol,
      final double lastPrice,
      final double priceChange,
      final double priceChangePct,
      final double highPrice,
      final double lowPrice,
      final double volume,
      final double quoteVolume,
    )
        when symbol.isNotEmpty =>
      CryptoQuoteEntity(
        symbol: symbol,
        lastPrice: lastPrice,
        priceChange: priceChange,
        priceChangePct: priceChangePct,
        highPrice: highPrice,
        lowPrice: lowPrice,
        volume: volume,
        quoteVolume: quoteVolume,
      ),
    _ => null,
  };
}

/// Binance sends every price as a decimal string.
double? _number(final String? value) =>
    value == null ? null : double.tryParse(value);
