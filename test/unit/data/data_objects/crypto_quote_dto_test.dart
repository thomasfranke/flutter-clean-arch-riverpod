import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoQuoteDTOMapper', () {
    test('should correctly convert string fields to double', () {
      const CryptoQuoteDTO dto = CryptoQuoteDTO(
        symbol: 'BTCUSDT',
        lastPrice: '60000.12345678',
        priceChange: '1000.0',
        priceChangePercent: '1.69',
        highPrice: '61000.0',
        lowPrice: '59000.0',
        volume: '500.5',
        quoteVolume: '30000000.0',
        weightedAvgPrice: null,
        prevClosePrice: null,
        lastQty: null,
        bidPrice: null,
        bidQty: null,
        askPrice: null,
        askQty: null,
        openPrice: null,
        openTime: null,
        closeTime: null,
        firstId: null,
        lastId: null,
        count: null,
      );

      final CryptoQuoteEntity entity = dto.toEntity();

      expect(entity.symbol, 'BTCUSDT');
      expect(entity.lastPrice, 60000.12345678);
      expect(entity.priceChange, 1000.0);
      expect(entity.priceChangePct, 1.69);
      expect(entity.highPrice, 61000.0);
      expect(entity.lowPrice, 59000.0);
      expect(entity.volume, 500.5);
      expect(entity.quoteVolume, 30000000.0);
    });

    test('should use default values when fields are null', () {
      const CryptoQuoteDTO dto = CryptoQuoteDTO(
        symbol: null,
        lastPrice: null,
        priceChange: null,
        priceChangePercent: null,
        highPrice: null,
        lowPrice: null,
        volume: null,
        quoteVolume: null,
        weightedAvgPrice: null,
        prevClosePrice: null,
        lastQty: null,
        bidPrice: null,
        bidQty: null,
        askPrice: null,
        askQty: null,
        openPrice: null,
        openTime: null,
        closeTime: null,
        firstId: null,
        lastId: null,
        count: null,
      );

      final CryptoQuoteEntity entity = dto.toEntity();

      expect(entity.symbol, '');
      expect(entity.lastPrice, 0.0);
      expect(entity.priceChange, 0.0);
      expect(entity.priceChangePct, 0.0);
      expect(entity.highPrice, 0.0);
      expect(entity.lowPrice, 0.0);
      expect(entity.volume, 0.0);
      expect(entity.quoteVolume, 0.0);
    });

    test('should use 0.0 when string is not a valid number', () {
      const CryptoQuoteDTO dto = CryptoQuoteDTO(
        symbol: 'BTCUSDT',
        lastPrice: 'invalid',
        priceChange: '',
        priceChangePercent: '1',
        highPrice: null,
        lowPrice: null,
        volume: null,
        quoteVolume: null,
        weightedAvgPrice: null,
        prevClosePrice: null,
        lastQty: null,
        bidPrice: null,
        bidQty: null,
        askPrice: null,
        askQty: null,
        openPrice: null,
        openTime: null,
        closeTime: null,
        firstId: null,
        lastId: null,
        count: null,
      );

      final CryptoQuoteEntity entity = dto.toEntity();

      expect(entity.lastPrice, 0.0);
      expect(entity.priceChange, 0.0);
      expect(entity.priceChangePct, 1);
    });

    test('should return CryptoQuoteEntity with correct types', () {
      const CryptoQuoteDTO dto = CryptoQuoteDTO(
        symbol: 'ETHUSDT',
        lastPrice: '3000.0',
        priceChange: '-50.0',
        priceChangePercent: '-1.64',
        highPrice: '3100.0',
        lowPrice: '2950.0',
        volume: '1000.0',
        quoteVolume: '3000000.0',
        weightedAvgPrice: null,
        prevClosePrice: null,
        lastQty: null,
        bidPrice: null,
        bidQty: null,
        askPrice: null,
        askQty: null,
        openPrice: null,
        openTime: null,
        closeTime: null,
        firstId: null,
        lastId: null,
        count: null,
      );

      final CryptoQuoteEntity entity = dto.toEntity();

      expect(entity, isA<CryptoQuoteEntity>());
      expect(entity.priceChange, -50.0);
      expect(entity.priceChangePct, -1.64);
    });
  });

  group('CryptoQuoteDTO.fromJson', () {
    test('should deserialize a JSON payload from Binance', () {
      final CryptoQuoteDTO dto = CryptoQuoteDTO.fromJson(<String, dynamic>{
        'symbol': 'BTCUSDT',
        'priceChange': '1000.0',
        'priceChangePercent': '1.69',
        'weightedAvgPrice': '60500.0',
        'prevClosePrice': '59000.0',
        'lastPrice': '60000.0',
        'lastQty': '0.01',
        'bidPrice': '59999.0',
        'bidQty': '0.5',
        'askPrice': '60001.0',
        'askQty': '0.5',
        'openPrice': '59000.0',
        'highPrice': '61000.0',
        'lowPrice': '59000.0',
        'volume': '500.5',
        'quoteVolume': '30000000.0',
        'openTime': 1713916800000,
        'closeTime': 1713920399999,
        'firstId': 1,
        'lastId': 2,
        'count': 2,
      });

      expect(dto.symbol, 'BTCUSDT');
      expect(dto.lastPrice, '60000.0');
      expect(dto.openTime, 1713916800000);
      expect(dto.count, 2);
    });

    test('should tolerate missing/null fields in JSON', () {
      final CryptoQuoteDTO dto = CryptoQuoteDTO.fromJson(<String, dynamic>{
        'symbol': 'ETHUSDT',
      });

      expect(dto.symbol, 'ETHUSDT');
      expect(dto.lastPrice, isNull);
      expect(dto.openTime, isNull);
    });

    test('toJson should serialize the DTO fields back', () {
      const CryptoQuoteDTO dto = CryptoQuoteDTO(
        symbol: 'BTCUSDT',
        priceChange: '1000.0',
        priceChangePercent: '1.69',
        weightedAvgPrice: null,
        prevClosePrice: null,
        lastPrice: '60000.0',
        lastQty: null,
        bidPrice: null,
        bidQty: null,
        askPrice: null,
        askQty: null,
        openPrice: null,
        highPrice: '61000.0',
        lowPrice: '59000.0',
        volume: '500.5',
        quoteVolume: '30000000.0',
        openTime: 1713916800000,
        closeTime: null,
        firstId: null,
        lastId: null,
        count: null,
      );

      final Map<String, dynamic> json = dto.toJson();

      expect(json['symbol'], 'BTCUSDT');
      expect(json['lastPrice'], '60000.0');
      expect(json['openTime'], 1713916800000);
    });
  });
}
