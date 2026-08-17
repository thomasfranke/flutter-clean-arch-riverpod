import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCryptoQuoteDatasource extends Mock
    implements CryptoQuoteDatasource {}

void main() {
  late _MockCryptoQuoteDatasource datasource;
  late CryptoQuotesRepositoryImpl sut;

  setUp(() {
    datasource = _MockCryptoQuoteDatasource();
    sut = CryptoQuotesRepositoryImpl(datasource: datasource);
  });

  const CryptoQuoteDTO tDto = CryptoQuoteDTO(
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
    openTime: null,
    closeTime: null,
    firstId: null,
    lastId: null,
    count: null,
  );

  group('getQuotes', () {
    test('should convert the list of DTOs into domain entities', () async {
      when(() => datasource.getQuotes()).thenAnswer(
        (_) async =>
            const Right<Failure, List<CryptoQuoteDTO>>(<CryptoQuoteDTO>[tDto]),
      );

      final Either<Failure, List<CryptoQuoteEntity>> result = await sut
          .getQuotes();

      expect(result.isRight(), isTrue);
      final List<CryptoQuoteEntity> entities = result.getOrElse(
        () => <CryptoQuoteEntity>[],
      );
      expect(entities, hasLength(1));
      expect(entities.first.symbol, 'BTCUSDT');
      expect(entities.first.lastPrice, 60000.0);
    });

    test('should propagate Failure when the datasource fails', () async {
      when(() => datasource.getQuotes()).thenAnswer(
        (_) async =>
            const Left<Failure, List<CryptoQuoteDTO>>(Failure.apiNetwork()),
      );

      final Either<Failure, List<CryptoQuoteEntity>> result = await sut
          .getQuotes();

      expect(
        result,
        const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );
    });
  });

  group('getQuote', () {
    test('should convert the DTO into a domain entity', () async {
      when(
        () => datasource.getQuote('BTCUSDT'),
      ).thenAnswer((_) async => const Right<Failure, CryptoQuoteDTO>(tDto));

      final Either<Failure, CryptoQuoteEntity> result = await sut.getQuote(
        'BTCUSDT',
      );

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => throw StateError('expected Right')).symbol,
        'BTCUSDT',
      );
    });

    test('should propagate Failure when the datasource fails', () async {
      when(() => datasource.getQuote('BTCUSDT')).thenAnswer(
        (_) async => const Left<Failure, CryptoQuoteDTO>(Failure.storage()),
      );

      final Either<Failure, CryptoQuoteEntity> result = await sut.getQuote(
        'BTCUSDT',
      );

      expect(result, const Left<Failure, CryptoQuoteEntity>(Failure.storage()));
    });
  });
}
