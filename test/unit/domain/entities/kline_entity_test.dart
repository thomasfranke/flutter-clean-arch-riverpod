import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_test/flutter_test.dart';

final DateTime _opened = DateTime.utc(2026, 10, 11, 12);
final DateTime _closed = DateTime.utc(2026, 10, 11, 13);

/// One candle, every field distinct so a field read in place of another
/// changes the number and fails.
final KlineEntity _candle = KlineEntity(
  openTime: _opened,
  closeTime: _closed,
  open: 1,
  high: 2,
  low: 3,
  close: 4,
  volume: 5,
  numberOfTrades: 6,
);

void main() {
  group('KlineEntity', () {
    test('should hold every value it was given, each in its own field', () {
      expect(_candle.openTime, _opened);
      expect(_candle.closeTime, _closed);
      expect(_candle.open, 1);
      expect(_candle.high, 2);
      expect(_candle.low, 3);
      expect(_candle.close, 4);
      expect(_candle.volume, 5);
      expect(_candle.numberOfTrades, 6);
    });

    test('should be equal to another with the same values', () {
      expect(_candle, _candle.copyWith());
      expect(_candle.hashCode, _candle.copyWith().hashCode);
    });

    test('should differ when a time differs', () {
      // The chart reads the close time as the x axis, so two candles that
      // differ only there are two candles.
      expect(
        _candle,
        isNot(
          _candle.copyWith(closeTime: _closed.add(const Duration(hours: 1))),
        ),
      );
    });

    test('should copy one field, keeping the rest', () {
      final KlineEntity higher = _candle.copyWith(high: 9);

      expect(higher.high, 9);
      expect(higher.openTime, _opened);
      expect(higher.numberOfTrades, 6);
      expect(_candle.high, 2);
    });
  });
}
