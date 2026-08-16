import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';

/// Repository interface for fetching kline (candlestick) data, defining the
/// contract for retrieving historical price data for a given symbol and
/// interval.
abstract interface class KlineRepository {
  /// Fetches a list of klines for the given [symbol] and [interval],
  /// returning either a [Failure] or a list of [Kline] entities.
  Future<Either<Failure, List<Kline>>> getKlines({
    required final String symbol,
    required final String interval,
    final int limit,
  });
}
