import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/klines/kline_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/klines/kline_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _MockKlineRepository extends Mock implements KlineRepository {}

void main() {
  late _MockKlineRepository repository;

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

  setUp(() {
    repository = _MockKlineRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: <Override>[
      getKlinesUseCaseProvider.overrideWithValue(
        GetKlinesUseCase(repository: repository),
      ),
    ],
  );

  group('KlineNotifier', () {
    test(
      'initial state should be loading and use the default interval "1h"',
      () {
        when(
          () => repository.getKlines(
            symbol: any(named: 'symbol'),
            interval: any(named: 'interval'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Right<Failure, List<Kline>>(<Kline>[tKline]));

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        expect(
          container.read(klineProvider('BTCUSDT')),
          isA<KlineStateLoading>(),
        );
        expect(
          container.read(klineProvider('BTCUSDT').notifier).currentInterval,
          '1h',
        );
      },
    );

    test('should emit success after a successful loadKlines', () async {
      when(
        () =>
            repository.getKlines(symbol: 'BTCUSDT', interval: '1h', limit: 24),
      ).thenAnswer((_) async => Right<Failure, List<Kline>>(<Kline>[tKline]));

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(klineProvider('BTCUSDT').notifier)
          .loadKlines(interval: '1h');

      expect(
        container.read(klineProvider('BTCUSDT')),
        KlineState.success(<Kline>[tKline]),
      );
    });

    test('should emit failure when the repository fails', () async {
      when(
        () =>
            repository.getKlines(symbol: 'BTCUSDT', interval: '1h', limit: 24),
      ).thenAnswer(
        (_) async => const Left<Failure, List<Kline>>(Failure.apiServer()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(klineProvider('BTCUSDT').notifier)
          .loadKlines(interval: '1h');

      expect(
        container.read(klineProvider('BTCUSDT')),
        const KlineState.failure(Failure.apiServer()),
      );
    });

    test('switchInterval should reload and update currentInterval', () async {
      when(
        () => repository.getKlines(
          symbol: any(named: 'symbol'),
          interval: any(named: 'interval'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right<Failure, List<Kline>>(<Kline>[tKline]));

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(klineProvider('BTCUSDT').notifier)
          .switchInterval(interval: '4h');

      expect(
        container.read(klineProvider('BTCUSDT').notifier).currentInterval,
        '4h',
      );
      verify(
        () =>
            repository.getKlines(symbol: 'BTCUSDT', interval: '4h', limit: 24),
      ).called(1);
    });

    test('klineProvider(symbol).overrideWithValue replaces the state, and '
        'toString identifies the provider and the family', () {
      expect(
        klineProvider('BTCUSDT').overrideWithValue(const KlineState.loading()),
        isNotNull,
      );
      expect(klineProvider('BTCUSDT').toString(), contains('BTCUSDT'));
      expect(klineProvider.toString(), 'klineProvider');
    });
  });
}
