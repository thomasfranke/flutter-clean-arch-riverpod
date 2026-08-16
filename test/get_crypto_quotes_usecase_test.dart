import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCryptoQuoteRepository extends Mock
    implements CryptoQuoteRepository {}

void main() {
  late _MockCryptoQuoteRepository repository;
  late GetCryptoQuotesUseCase sut;

  setUp(() {
    repository = _MockCryptoQuoteRepository();
    sut = GetCryptoQuotesUseCase(repository: repository);
  });

  const CryptoQuoteEntity tQuote = CryptoQuoteEntity(
    symbol: 'BTCUSDT',
    lastPrice: 60000,
    priceChange: 1000,
    priceChangePct: 1.69,
    highPrice: 61000,
    lowPrice: 59000,
    volume: 500,
    quoteVolume: 30000000,
  );

  group('GetCryptoQuotesUseCase', () {
    test(
      'deve retornar lista de quotes quando repositório retorna sucesso',
      () async {
        when(() => repository.getQuotes()).thenAnswer(
          (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
            <CryptoQuoteEntity>[tQuote],
          ),
        );

        final Either<Failure, List<CryptoQuoteEntity>> result = await sut();

        expect(
          result,
          const Right<Failure, List<CryptoQuoteEntity>>(<CryptoQuoteEntity>[
            tQuote,
          ]),
        );
        verify(() => repository.getQuotes()).called(1);
      },
    );

    test('deve retornar Failure quando repositório falha', () async {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async =>
            const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );

      final Either<Failure, List<CryptoQuoteEntity>> result = await sut();

      expect(
        result,
        const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );
      verify(() => repository.getQuotes()).called(1);
    });
  });
}
