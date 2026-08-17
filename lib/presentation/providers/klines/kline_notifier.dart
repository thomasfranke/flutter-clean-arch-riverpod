import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/klines/kline_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kline_notifier.g.dart';

/// Notifier for managing the state of kline (candlestick) data for a given
/// symbol, including fetching and interval switching.
@riverpod
class KlineNotifier extends _$KlineNotifier {
  String _interval = '1h';

  @override
  KlineState build(final String symbol) {
    unawaited(loadKlines(interval: _interval));
    return const KlineState.loading();
  }

  /// Loads klines for [symbol] (the family argument this notifier is scoped
  /// to) at the given [interval].
  Future<void> loadKlines({required final String interval}) async {
    state = const KlineState.loading();
    _interval = interval;

    final GetKlinesUseCase useCase = ref.read(getKlinesUseCaseProvider);
    final Either<Failure, List<Kline>> result = await useCase.call(
      symbol: symbol,
      interval: interval,
    );

    if (!ref.mounted) {
      return;
    }
    state = result.fold(KlineState.failure, KlineState.success);
  }

  /// Switches to a new [interval] and reloads the klines.
  Future<void> switchInterval({required final String interval}) =>
      loadKlines(interval: interval);

  /// The currently selected interval.
  String get currentInterval => _interval;
}
