import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http_client.dart';

/// A single Binance `/api/v3/klines` candle, positional per the Binance
/// docs: [openTime, open, high, low, close, volume, closeTime, quoteVolume,
/// numberOfTrades, takerBuyBase, takerBuyQuote, ignore].
List<dynamic> _candle() => <dynamic>[
  1700000000000,
  '48000.00',
  '48200.00',
  '47800.00',
  '48020.50',
  '1200.5',
  1700003600000,
  '57600000.0',
  100,
  '600.0',
  '28800000.0',
  '0',
];

/// Builds the real klines chain (use case -> repository -> datasource) on
/// top of a [FakeHttpClientInterface], which fakes only the network edge —
/// everything from `KlineDatasource` up is real.
GetKlinesUseCase _buildStack(final FakeHttpClientInterface httpClient) {
  final KlineDatasource datasource = KlineDatasource(httpClient: httpClient);
  final KlineRepositoryImpl repository = KlineRepositoryImpl(
    datasource: datasource,
  );

  return GetKlinesUseCase(repository: repository);
}

void main() {
  group('Klines integration flow', () {
    test(
      'getKlines maps a successful HTTP response into Kline entities',
      () async {
        final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
          ..enqueueSuccess(<List<dynamic>>[_candle()]);
        final GetKlinesUseCase getKlines = _buildStack(httpClient);

        final Either<Failure, List<Kline>> result = await getKlines(
          symbol: 'BTCUSDT',
          interval: '1h',
        );

        expect(result.isRight(), isTrue);
        final List<Kline> klines = result.getOrElse(() => <Kline>[]);
        expect(klines, hasLength(1));
        expect(klines.single.open, 48000.0);
        expect(klines.single.close, 48020.5);
        expect(klines.single.numberOfTrades, 100);
        expect(
          klines.single.openTime,
          DateTime.fromMillisecondsSinceEpoch(1700000000000),
        );
      },
    );

    test('getKlines propagates an HTTP failure as a domain Failure', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueFailure(const HttpClientFailure.network());
      final GetKlinesUseCase getKlines = _buildStack(httpClient);

      final Either<Failure, List<Kline>> result = await getKlines(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(result, const Left<Failure, List<Kline>>(Failure.apiNetwork()));
    });

    test('getKlines maps a malformed payload to Failure.parse() instead of '
        'throwing', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueSuccess(<String, dynamic>{'not': 'a list'});
      final GetKlinesUseCase getKlines = _buildStack(httpClient);

      final Either<Failure, List<Kline>> result = await getKlines(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(result, const Left<Failure, List<Kline>>(Failure.parse()));
    });

    test('symbol, interval and the default limit reach the HTTP request as '
        'query parameters', () async {
      final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
        ..enqueueSuccess(<List<dynamic>>[]);
      final GetKlinesUseCase getKlines = _buildStack(httpClient);

      await getKlines(symbol: 'ETHUSDT', interval: '4h');

      expect(httpClient.requestedQueryParameters.single, <String, dynamic>{
        'symbol': 'ETHUSDT',
        'interval': '4h',
        'limit': 24,
      });
    });
  });
}
