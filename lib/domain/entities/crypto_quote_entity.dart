import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_quote_entity.freezed.dart';

/// Domain entity representing a cryptocurrency quote, used within the
/// application to encapsulate the relevant data for a cryptocurrency pair.
@freezed
abstract class CryptoQuoteEntity with _$CryptoQuoteEntity {
  /// Creates a [CryptoQuoteEntity] instance with the given parameters.
  const factory CryptoQuoteEntity({
    required final String symbol,
    required final double lastPrice,
    required final double priceChange,
    required final double priceChangePct,
    required final double highPrice,
    required final double lowPrice,
    required final double volume,
    required final double quoteVolume,
  }) = _CryptoQuoteEntity;
}
