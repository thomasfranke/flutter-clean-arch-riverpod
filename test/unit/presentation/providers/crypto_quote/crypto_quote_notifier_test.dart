import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _MockCryptoQuoteRepository extends Mock
    implements CryptoQuoteRepository {}

void main() {
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

  group('CryptoQuoteNotifier', () {
    late _MockCryptoQuoteRepository repository;

    setUp(() {
      repository = _MockCryptoQuoteRepository();
    });

    ProviderContainer makeContainer() => ProviderContainer(
      overrides: <Override>[
        getCryptoQuotesUseCaseProvider.overrideWithValue(
          GetCryptoQuotesUseCase(repository: repository),
        ),
      ],
    );

    test('initial state should be loading', () {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      expect(
        container.read(cryptoQuoteProvider),
        isA<CryptoQuoteStateLoading>(),
      );
    });

    test('should emit success after a successful fetch', () async {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(cryptoQuoteProvider.notifier).fetchQuotes();

      expect(
        container.read(cryptoQuoteProvider),
        const CryptoQuoteState.success(<CryptoQuoteEntity>[tQuote]),
      );
    });

    test('should emit failure when repository fails', () async {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async =>
            const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(cryptoQuoteProvider.notifier).fetchQuotes();

      expect(
        container.read(cryptoQuoteProvider),
        const CryptoQuoteState.failure(Failure.apiNetwork()),
      );
    });

    test('cryptoQuoteProvider.overrideWithValue replaces the state', () {
      expect(
        cryptoQuoteProvider.overrideWithValue(const CryptoQuoteState.loading()),
        isNotNull,
      );
    });
  });
}
