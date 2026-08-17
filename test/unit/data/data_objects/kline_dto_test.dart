import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KlineDTOMapper', () {
    final List<dynamic> tRawKline = <dynamic>[
      1713916800000, // openTime
      '60000.0', // open
      '61000.0', // high
      '59000.0', // low
      '60500.0', // close
      '500.5', // volume
      1713920399999, // closeTime
      '30000000.0', // quoteVolume (ignored)
      1234, // numberOfTrades
      '200.0', // takerBuyBase (ignored)
      '12000000.0', // takerBuyQuote (ignored)
      '0', // ignore
    ];

    test('should correctly convert positional list to Kline', () {
      final KlineDTO dto = KlineDTO.fromList(tRawKline);
      final Kline entity = dto.toEntity();

      expect(entity.open, 60000.0);
      expect(entity.high, 61000.0);
      expect(entity.low, 59000.0);
      expect(entity.close, 60500.0);
      expect(entity.volume, 500.5);
      expect(entity.numberOfTrades, 1234);
      expect(
        entity.openTime,
        DateTime.fromMillisecondsSinceEpoch(1713916800000),
      );
      expect(
        entity.closeTime,
        DateTime.fromMillisecondsSinceEpoch(1713920399999),
      );
    });

    test('should use 0.0 for invalid strings', () {
      final List<dynamic> invalidKline = <dynamic>[
        0,
        'invalid',
        'invalid',
        'invalid',
        'invalid',
        'invalid',
        0,
        '',
        0,
        '',
        '',
        '',
      ];

      final KlineDTO dto = KlineDTO.fromList(invalidKline);
      final Kline entity = dto.toEntity();

      expect(entity.open, 0.0);
      expect(entity.high, 0.0);
      expect(entity.low, 0.0);
      expect(entity.close, 0.0);
      expect(entity.volume, 0.0);
    });

    test('should not throw when the list has fewer elements than expected', () {
      final List<dynamic> shortKline = <dynamic>[1713916800000, '60000.0'];

      final KlineDTO dto = KlineDTO.fromList(shortKline);

      expect(dto.openTime, 1713916800000);
      expect(dto.open, '60000.0');
      expect(dto.high, '0');
      expect(dto.numberOfTrades, 0);
    });

    test('should not throw when a numeric field comes as double instead of '
        'int', () {
      final List<dynamic> mistypedKline = <dynamic>[
        1713916800000.0,
        '60000.0',
        '61000.0',
        '59000.0',
        '60500.0',
        '500.5',
        1713920399999.0,
        '30000000.0',
        1234.0,
      ];

      final KlineDTO dto = KlineDTO.fromList(mistypedKline);

      expect(dto.openTime, 1713916800000);
      expect(dto.closeTime, 1713920399999);
      expect(dto.numberOfTrades, 1234);
    });
  });
}
