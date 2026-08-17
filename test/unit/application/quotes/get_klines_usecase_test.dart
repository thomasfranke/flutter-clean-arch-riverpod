import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockKlineRepository extends Mock implements KlineRepository {}

void main() {
  late _MockKlineRepository repository;
  late GetKlinesUseCase sut;

  final Kline tKline = Kline(
    openTime: DateTime.fromMillisecondsSinceEpoch(0),
    closeTime: DateTime.fromMillisecondsSinceEpoch(1),
    open: 1,
    high: 2,
    low: 0.5,
    close: 1.5,
    volume: 10,
    numberOfTrades: 3,
  );

  final List<Kline> tKlines = <Kline>[tKline];

  setUp(() {
    repository = _MockKlineRepository();
    sut = GetKlinesUseCase(repository: repository);
  });

  group('GetKlinesUseCase', () {
    test(
      'should delegate to repository.getKlines with the received parameters',
      () async {
        when(
          () => repository.getKlines(
            symbol: 'BTCUSDT',
            interval: '1h',
            limit: 24,
          ),
        ).thenAnswer((_) async => Right<Failure, List<Kline>>(tKlines));

        final Either<Failure, List<Kline>> result = await sut(
          symbol: 'BTCUSDT',
          interval: '1h',
        );

        expect(result, Right<Failure, List<Kline>>(tKlines));
        verify(
          () => repository.getKlines(
            symbol: 'BTCUSDT',
            interval: '1h',
            limit: 24,
          ),
        ).called(1);
      },
    );

    test('should return Failure when the repository fails', () async {
      when(
        () =>
            repository.getKlines(symbol: 'BTCUSDT', interval: '1h', limit: 24),
      ).thenAnswer(
        (_) async => const Left<Failure, List<Kline>>(Failure.apiServer()),
      );

      final Either<Failure, List<Kline>> result = await sut(
        symbol: 'BTCUSDT',
        interval: '1h',
      );

      expect(result, const Left<Failure, List<Kline>>(Failure.apiServer()));
    });
  });
}
