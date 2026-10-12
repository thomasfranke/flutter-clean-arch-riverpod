import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// One quote with every field distinct, so a field read in place of another
/// changes the number and fails.
const CryptoQuoteEntity _bitcoin = CryptoQuoteEntity(
  symbol: 'BTCUSDT',
  lastPrice: 1,
  priceChange: 2,
  priceChangePct: 3,
  highPrice: 4,
  lowPrice: 5,
  volume: 6,
  quoteVolume: 7,
);

void main() {
  group('CryptoQuoteEntity', () {
    test('should hold every value it was given, each in its own field', () {
      expect(_bitcoin.symbol, 'BTCUSDT');
      expect(_bitcoin.lastPrice, 1);
      expect(_bitcoin.priceChange, 2);
      expect(_bitcoin.priceChangePct, 3);
      expect(_bitcoin.highPrice, 4);
      expect(_bitcoin.lowPrice, 5);
      expect(_bitcoin.volume, 6);
      expect(_bitcoin.quoteVolume, 7);
    });

    test('should be equal to another with the same values', () {
      expect(_bitcoin, _bitcoin.copyWith());
      expect(_bitcoin.hashCode, _bitcoin.copyWith().hashCode);
    });

    test('should differ when any one value differs', () {
      expect(_bitcoin, isNot(_bitcoin.copyWith(lastPrice: 1.5)));
      expect(_bitcoin, isNot(_bitcoin.copyWith(symbol: 'ETHUSDT')));
    });

    test('should copy one field, keeping the rest', () {
      final CryptoQuoteEntity cheaper = _bitcoin.copyWith(lastPrice: 0.5);

      expect(cheaper.lastPrice, 0.5);
      expect(cheaper.symbol, _bitcoin.symbol);
      expect(cheaper.quoteVolume, _bitcoin.quoteVolume);
      expect(_bitcoin.lastPrice, 1);
    });
  });
}
