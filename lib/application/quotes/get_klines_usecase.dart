import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';

/// Use case for fetching kline (candlestick) data for a given symbol and
/// interval.
class GetKlinesUseCase {
  /// Creates a [GetKlinesUseCase] with the required [KlineRepository].
  const GetKlinesUseCase({required this.repository});

  /// The repository used to fetch kline data.
  final KlineRepository repository;

  /// Executes the use case, returning either a [Failure] or a list of [Kline]
  /// entities.
  Future<Either<Failure, List<Kline>>> call({
    required final String symbol,
    required final String interval,
    final int limit = 24,
  }) => repository.getKlines(symbol: symbol, interval: interval, limit: limit);
}
