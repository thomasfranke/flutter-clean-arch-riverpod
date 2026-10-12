import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// One quote, so the success case has something distinguishable in it.
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
  group('CryptoQuoteState', () {
    test('should offer the four cases every screen switches over', () {
      // Spelled out rather than read back. The screens are a `switch` over
      // these four, and a case added or dropped changes what a screen has to
      // draw — which is the kind of change worth failing a test.
      expect(const CryptoQuoteState.initial(), isA<CryptoQuoteState>());
      expect(const CryptoQuoteState.loading(), isA<CryptoQuoteState>());
      expect(
        const CryptoQuoteState.success(<CryptoQuoteEntity>[_bitcoin]),
        isA<CryptoQuoteStateSuccess>(),
      );
      expect(
        const CryptoQuoteState.failure(Failure.parse()),
        isA<CryptoQuoteState>(),
      );
    });

    test('should carry the value the success case was given', () {
      const CryptoQuoteStateSuccess success =
          CryptoQuoteState.success(<CryptoQuoteEntity>[_bitcoin])
              as CryptoQuoteStateSuccess;

      expect(success.quotes, const <CryptoQuoteEntity>[_bitcoin]);
    });

    test('should carry the failure the failure case was given', () {
      const CryptoQuoteState state = CryptoQuoteState.failure(
        Failure.storage(),
      );

      expect(state, const CryptoQuoteState.failure(Failure.storage()));
      expect(state, isNot(const CryptoQuoteState.failure(Failure.parse())));
    });

    test('should tell the empty cases apart', () {
      // `initial` is "nothing asked yet" and `loading` is "asked, waiting".
      // Equal, a notifier could not keep the last good value by testing for
      // one of them.
      expect(
        const CryptoQuoteState.initial(),
        isNot(const CryptoQuoteState.loading()),
      );
    });

    test('should compare two successes by what they hold', () {
      expect(
        const CryptoQuoteState.success(<CryptoQuoteEntity>[_bitcoin]),
        const CryptoQuoteState.success(<CryptoQuoteEntity>[_bitcoin]),
      );
      expect(
        const CryptoQuoteState.success(<CryptoQuoteEntity>[_bitcoin]),
        isNot(const CryptoQuoteState.success(<CryptoQuoteEntity>[])),
      );
    });
  });
}
