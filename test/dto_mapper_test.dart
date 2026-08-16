import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoQuoteDTOMapper', () {
    test('deve converter campos string para double corretamente', () {
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

    test('deve usar valores default quando campos são nulos', () {
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

    test('deve usar 0.0 quando string não é um número válido', () {
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

    test('deve retornar CryptoQuoteEntity com os tipos corretos', () {
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

  group('KlineDTOMapper', () {
    final List<dynamic> tRawKline = <dynamic>[
      1713916800000, // openTime
      '60000.0', // open
      '61000.0', // high
      '59000.0', // low
      '60500.0', // close
      '500.5', // volume
      1713920399999, // closeTime
      '30000000.0', // quoteVolume (ignorado)
      1234, // numberOfTrades
      '200.0', // takerBuyBase (ignorado)
      '12000000.0', // takerBuyQuote (ignorado)
      '0', // ignore
    ];

    test('deve converter lista posicional para Kline corretamente', () {
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

    test('deve usar 0.0 para strings inválidas', () {
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
  });

  group('PreferencesDAOMapper', () {
    test('deve converter DAO para entity com valores presentes', () {
      const PreferencesDAO dao = PreferencesDAO(
        locale: 'en',
        darkMode: true,
        fontScale: 1.5,
      );

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, 'en');
      expect(entity.darkMode, true);
      expect(entity.fontScale, 1.5);
    });

    test('deve usar defaults quando campos são nulos', () {
      const PreferencesDAO dao = PreferencesDAO(
        locale: null,
        darkMode: null,
        fontScale: null,
      );
      final PreferencesEntity defaults = PreferencesEntity.defaults();

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, defaults.locale);
      expect(entity.darkMode, defaults.darkMode);
      expect(entity.fontScale, defaults.fontScale);
    });

    test('deve usar default apenas nos campos nulos', () {
      final PreferencesEntity defaults = PreferencesEntity.defaults();
      const PreferencesDAO dao = PreferencesDAO(
        locale: 'es',
        darkMode: null,
        fontScale: null,
      );

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, 'es');
      expect(entity.darkMode, defaults.darkMode);
      expect(entity.fontScale, defaults.fontScale);
    });
  });
}
