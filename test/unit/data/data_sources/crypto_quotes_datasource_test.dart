import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttpClient extends Mock implements HttpClientInterface {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ApiRoute('', HttpMethod.get));
  });

  late _MockHttpClient httpClient;
  late CryptoQuoteDatasource sut;

  setUp(() {
    httpClient = _MockHttpClient();
    sut = CryptoQuoteDatasource(httpClient: httpClient);
  });

  final Map<String, dynamic> tQuoteJson = <String, dynamic>{
    'symbol': 'BTCUSDT',
    'priceChange': '1000.0',
    'priceChangePercent': '1.69',
    'weightedAvgPrice': null,
    'prevClosePrice': null,
    'lastPrice': '60000.0',
    'lastQty': null,
    'bidPrice': null,
    'bidQty': null,
    'askPrice': null,
    'askQty': null,
    'openPrice': null,
    'highPrice': '61000.0',
    'lowPrice': '59000.0',
    'volume': '500.5',
    'quoteVolume': '30000000.0',
    'openTime': null,
    'closeTime': null,
    'firstId': null,
    'lastId': null,
    'count': null,
  };

  group('getQuotes', () {
    test('should convert the response into a list of CryptoQuoteDTO', () async {
      when(
        () => httpClient.request(apiRoute: any(named: 'apiRoute')),
      ).thenAnswer(
        (_) async => Right<HttpClientFailure, HttpClientResponse<dynamic>>(
          HttpClientResponse<dynamic>(
            data: <Map<String, dynamic>>[tQuoteJson],
            statusCode: 200,
          ),
        ),
      );

      final Either<Failure, List<CryptoQuoteDTO>> result = await sut
          .getQuotes();

      expect(result.isRight(), isTrue);
      final List<CryptoQuoteDTO> dtos = result.getOrElse(
        () => <CryptoQuoteDTO>[],
      );
      expect(dtos, hasLength(1));
      expect(dtos.first.symbol, 'BTCUSDT');
    });

    test(
      'should propagate the HttpClient failure as a domain Failure',
      () async {
        when(
          () => httpClient.request(apiRoute: any(named: 'apiRoute')),
        ).thenAnswer(
          (_) async =>
              const Left<HttpClientFailure, HttpClientResponse<dynamic>>(
                HttpClientFailure.network(),
              ),
        );

        final Either<Failure, List<CryptoQuoteDTO>> result = await sut
            .getQuotes();

        expect(result.isLeft(), isTrue);
      },
    );

    test('should return Failure.parse when the payload does not have the '
        'expected format', () async {
      when(
        () => httpClient.request(apiRoute: any(named: 'apiRoute')),
      ).thenAnswer(
        (_) async =>
            const Right<HttpClientFailure, HttpClientResponse<dynamic>>(
              HttpClientResponse<dynamic>(
                data: <String, dynamic>{'unexpected': 'shape'},
                statusCode: 200,
              ),
            ),
      );

      final Either<Failure, List<CryptoQuoteDTO>> result = await sut
          .getQuotes();

      expect(
        result,
        const Left<Failure, List<CryptoQuoteDTO>>(Failure.parse()),
      );
    });
  });

  group('getQuote', () {
    test('should convert the response into a single CryptoQuoteDTO', () async {
      when(
        () => httpClient.request(
          apiRoute: any(named: 'apiRoute'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Right<HttpClientFailure, HttpClientResponse<dynamic>>(
          HttpClientResponse<dynamic>(data: tQuoteJson, statusCode: 200),
        ),
      );

      final Either<Failure, CryptoQuoteDTO> result = await sut.getQuote(
        'BTCUSDT',
      );

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => throw StateError('expected Right')).symbol,
        'BTCUSDT',
      );
    });

    test('should return Failure.parse when the payload is not a Map', () async {
      when(
        () => httpClient.request(
          apiRoute: any(named: 'apiRoute'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async =>
            const Right<HttpClientFailure, HttpClientResponse<dynamic>>(
              HttpClientResponse<dynamic>(
                data: <dynamic>['not', 'a', 'map'],
                statusCode: 200,
              ),
            ),
      );

      final Either<Failure, CryptoQuoteDTO> result = await sut.getQuote(
        'BTCUSDT',
      );

      expect(result, const Left<Failure, CryptoQuoteDTO>(Failure.parse()));
    });

    test(
      'should propagate the HttpClient failure as a domain Failure',
      () async {
        when(
          () => httpClient.request(
            apiRoute: any(named: 'apiRoute'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left<HttpClientFailure, HttpClientResponse<dynamic>>(
                HttpClientFailure.notFound(),
              ),
        );

        final Either<Failure, CryptoQuoteDTO> result = await sut.getQuote(
          'BTCUSDT',
        );

        expect(result.isLeft(), isTrue);
      },
    );
  });
}
