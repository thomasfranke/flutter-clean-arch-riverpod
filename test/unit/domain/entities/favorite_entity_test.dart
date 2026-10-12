import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteEntity', () {
    test('should hold the symbol it was given', () {
      const FavoriteEntity favorite = FavoriteEntity(symbol: 'BTCUSDT');

      expect(favorite.symbol, 'BTCUSDT');
    });

    test('should be equal to another with the same symbol', () {
      const FavoriteEntity one = FavoriteEntity(symbol: 'BTCUSDT');
      const FavoriteEntity other = FavoriteEntity(symbol: 'BTCUSDT');

      expect(one, other);
      expect(one.hashCode, other.hashCode);
    });

    test('should differ from another with a different symbol', () {
      const FavoriteEntity btc = FavoriteEntity(symbol: 'BTCUSDT');
      const FavoriteEntity eth = FavoriteEntity(symbol: 'ETHUSDT');

      expect(btc, isNot(eth));
    });

    test('should copy with a new symbol, leaving the original alone', () {
      const FavoriteEntity btc = FavoriteEntity(symbol: 'BTCUSDT');

      final FavoriteEntity eth = btc.copyWith(symbol: 'ETHUSDT');

      expect(eth.symbol, 'ETHUSDT');
      expect(btc.symbol, 'BTCUSDT');
    });
  });
}
