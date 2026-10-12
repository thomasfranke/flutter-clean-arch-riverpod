import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/kline/kline_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// One candle, so the success case has something distinguishable in it.
final KlineEntity _candle = KlineEntity(
  openTime: DateTime.utc(2026, 10, 11, 12),
  closeTime: DateTime.utc(2026, 10, 11, 13),
  open: 1,
  high: 2,
  low: 3,
  close: 4,
  volume: 5,
  numberOfTrades: 6,
);

void main() {
  group('KlineState', () {
    test('should offer the four cases every screen switches over', () {
      // Spelled out rather than read back. The screens are a `switch` over
      // these four, and a case added or dropped changes what a screen has to
      // draw — which is the kind of change worth failing a test.
      expect(const KlineState.initial(), isA<KlineState>());
      expect(const KlineState.loading(), isA<KlineState>());
      expect(
        KlineState.success(<KlineEntity>[_candle]),
        isA<KlineStateSuccess>(),
      );
      expect(const KlineState.failure(Failure.parse()), isA<KlineState>());
    });

    test('should carry the value the success case was given', () {
      final KlineStateSuccess success =
          KlineState.success(<KlineEntity>[_candle]) as KlineStateSuccess;

      expect(success.klines, <KlineEntity>[_candle]);
    });

    test('should carry the failure the failure case was given', () {
      const KlineState state = KlineState.failure(Failure.storage());

      expect(state, const KlineState.failure(Failure.storage()));
      expect(state, isNot(const KlineState.failure(Failure.parse())));
    });

    test('should tell the empty cases apart', () {
      // `initial` is "nothing asked yet" and `loading` is "asked, waiting".
      // Equal, a notifier could not keep the last good value by testing for
      // one of them.
      expect(const KlineState.initial(), isNot(const KlineState.loading()));
    });

    test('should compare two successes by what they hold', () {
      expect(
        KlineState.success(<KlineEntity>[_candle]),
        KlineState.success(<KlineEntity>[_candle]),
      );
      expect(
        KlineState.success(<KlineEntity>[_candle]),
        isNot(const KlineState.success(<KlineEntity>[])),
      );
    });
  });
}
