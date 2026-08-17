import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
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
  late KlineDatasource sut;

  setUp(() {
    httpClient = _MockHttpClient();
    sut = KlineDatasource(httpClient: httpClient);
  });

  final List<dynamic> tRawKline = <dynamic>[
    1713916800000,
    '60000.0',
    '61000.0',
    '59000.0',
    '60500.0',
    '500.5',
    1713920399999,
    '30000000.0',
    1234,
    '200.0',
    '12000000.0',
    '0',
  ];

  group('getKlines', () {
    test('should convert the response into a list of KlineDTO', () async {
      when(
        () => httpClient.request(
          apiRoute: any(named: 'apiRoute'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Right<HttpClientFailure, HttpClientResponse<dynamic>>(
          HttpClientResponse<dynamic>(
            data: <List<dynamic>>[tRawKline],
            statusCode: 200,
          ),
        ),
      );

      final Either<Failure, List<KlineDTO>> result = await sut.getKlines(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(result.isRight(), isTrue);
      final List<KlineDTO> klines = result.getOrElse(() => <KlineDTO>[]);
      expect(klines, hasLength(1));
      expect(klines.first.numberOfTrades, 1234);
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
                HttpClientFailure.server(),
              ),
        );

        final Either<Failure, List<KlineDTO>> result = await sut.getKlines(
          symbol: 'BTCUSDT',
          interval: '1h',
        );

        expect(result.isLeft(), isTrue);
      },
    );

    test(
      'should return Failure.parse when the payload is not a list',
      () async {
        when(
          () => httpClient.request(
            apiRoute: any(named: 'apiRoute'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async =>
              const Right<HttpClientFailure, HttpClientResponse<dynamic>>(
                HttpClientResponse<dynamic>(
                  data: <String, dynamic>{'unexpected': 'shape'},
                  statusCode: 200,
                ),
              ),
        );

        final Either<Failure, List<KlineDTO>> result = await sut.getKlines(
          symbol: 'BTCUSDT',
          interval: '1h',
        );

        expect(result, const Left<Failure, List<KlineDTO>>(Failure.parse()));
      },
    );
  });
}
