import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http_client.dart';

/// A realistic Binance `/api/v3/ticker/24hr` entry for BTCUSDT.
Map<String, dynamic> _btcUsdtJson() => <String, dynamic>{
  'symbol': 'BTCUSDT',
  'priceChange': '120.50',
  'priceChangePercent': '0.25',
  'weightedAvgPrice': '48000.00',
  'prevClosePrice': '47900.00',
  'lastPrice': '48020.50',
  'lastQty': '0.001',
  'bidPrice': '48020.00',
  'bidQty': '0.5',
  'askPrice': '48021.00',
  'askQty': '0.5',
  'openPrice': '47900.00',
  'highPrice': '48200.00',
  'lowPrice': '47800.00',
  'volume': '1200.5',
  'quoteVolume': '57600000.0',
  'openTime': 1700000000000,
  'closeTime': 1700086400000,
  'firstId': 1,
  'lastId': 100,
  'count': 100,
};

/// The real crypto quotes chain, wired the same way `quotes_di.dart` wires
/// it in the app.
typedef _QuotesStack = ({
  GetCryptoQuotesUseCase getQuotes,
  CryptoQuoteRepository repository,
});

/// Builds the real crypto quotes chain (use case -> repository ->
/// datasource) on top of a [FakeHttpClientInterface], which fakes only the
/// network edge — everything from `CryptoQuoteDatasource` up is real.
_QuotesStack _buildStack(final FakeHttpClientInterface httpClient) {
  final CryptoQuoteDatasource datasource = CryptoQuoteDatasource(
    httpClient: httpClient,
  );
  final CryptoQuotesRepositoryImpl repository = CryptoQuotesRepositoryImpl(
    datasource: datasource,
  );

  return (
    getQuotes: GetCryptoQuotesUseCase(repository: repository),
    repository: repository,
  );
}

void main() {
  group('Crypto quotes integration flow', () {
    test(
      'getQuotes maps a successful HTTP response into CryptoQuoteEntity list',
      () async {
        final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
          ..enqueueSuccess(<Map<String, dynamic>>[_btcUsdtJson()]);
        final _QuotesStack stack = _buildStack(httpClient);

        final Either<Failure, List<CryptoQuoteEntity>> result = await stack
            .getQuotes();

        expect(result.isRight(), isTrue);
        final List<CryptoQuoteEntity> entities = result.getOrElse(
          () => <CryptoQuoteEntity>[],
        );
        expect(entities, hasLength(1));
        expect(entities.single.symbol, 'BTCUSDT');
        expect(entities.single.lastPrice, 48020.5);
        expect(entities.single.highPrice, 48200.0);
      },
    );

    test('getQuotes propagates an HTTP failure as a domain Failure', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueFailure(const HttpClientFailure.server(statusCode: 500));
      final _QuotesStack stack = _buildStack(httpClient);

      final Either<Failure, List<CryptoQuoteEntity>> result = await stack
          .getQuotes();

      expect(
        result,
        const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiServer()),
      );
    });

    test('getQuotes maps a malformed payload to Failure.parse() instead of '
        'throwing', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueSuccess(<String, dynamic>{'not': 'a list'});
      final _QuotesStack stack = _buildStack(httpClient);

      final Either<Failure, List<CryptoQuoteEntity>> result = await stack
          .getQuotes();

      expect(
        result,
        const Left<Failure, List<CryptoQuoteEntity>>(Failure.parse()),
      );
    });

    test('getQuote(symbol) maps a successful response to one entity', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueSuccess(_btcUsdtJson());
      final _QuotesStack stack = _buildStack(httpClient);

      final Either<Failure, CryptoQuoteEntity> result = await stack.repository
          .getQuote('BTCUSDT');

      expect(
        result.map((final CryptoQuoteEntity e) => e.symbol),
        const Right<Failure, String>('BTCUSDT'),
      );
      expect(httpClient.requestedQueryParameters.single, <String, dynamic>{
        'symbol': 'BTCUSDT',
      });
    });

    test('getQuote(symbol) propagates a not-found HTTP failure as a domain '
        'Failure', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueFailure(const HttpClientFailure.notFound(statusCode: 404));
      final _QuotesStack stack = _buildStack(httpClient);

      final Either<Failure, CryptoQuoteEntity> result = await stack.repository
          .getQuote('DOESNOTEXIST');

      expect(
        result,
        const Left<Failure, CryptoQuoteEntity>(Failure.apiNotFound()),
      );
    });
  });
}
