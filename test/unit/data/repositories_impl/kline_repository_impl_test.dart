import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockKlineDatasource extends Mock implements KlineDatasource {}

void main() {
  late _MockKlineDatasource datasource;
  late KlineRepositoryImpl sut;

  setUp(() {
    datasource = _MockKlineDatasource();
    sut = KlineRepositoryImpl(datasource: datasource);
  });

  final KlineDTO tDto = KlineDTO.fromList(<dynamic>[
    1713916800000,
    '60000.0',
    '61000.0',
    '59000.0',
    '60500.0',
    '500.5',
    1713920399999,
    '30000000.0',
    1234,
  ]);

  group('getKlines', () {
    test('should convert the list of DTOs into Kline entities', () async {
      when(
        () => datasource.getKlines(symbol: 'BTCUSDT', interval: '1h'),
      ).thenAnswer(
        (_) async => Right<HttpClientFailure, List<KlineDTO>>(<KlineDTO>[tDto]),
      );

      final Either<Failure, List<Kline>> result = await sut.getKlines(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(result.isRight(), isTrue);
      final List<Kline> klines = result.getOrElse(() => <Kline>[]);
      expect(klines, hasLength(1));
      expect(klines.first.numberOfTrades, 1234);
    });

    test('should translate the infrastructure failure into a domain '
        'Failure', () async {
      when(
        () => datasource.getKlines(symbol: 'BTCUSDT', interval: '1h'),
      ).thenAnswer(
        (_) async => const Left<HttpClientFailure, List<KlineDTO>>(
          HttpClientFailure.server(errorMessage: 'boom'),
        ),
      );

      final Either<Failure, List<Kline>> result = await sut.getKlines(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(
        result,
        const Left<Failure, List<Kline>>(Failure.apiServer('boom')),
      );
    });

    test('should be Failure.parse when no kline is well-formed', () async {
      when(
        () => datasource.getKlines(symbol: 'BTCUSDT', interval: '1h'),
      ).thenAnswer(
        (_) async => Right<HttpClientFailure, List<KlineDTO>>(<KlineDTO>[
          KlineDTO.fromList(<dynamic>[1713916800000]),
        ]),
      );

      expect(
        await sut.getKlines(symbol: 'BTCUSDT', interval: '1h'),
        const Left<Failure, List<Kline>>(Failure.parse()),
      );
    });
  });
}
