import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';

/// Repository implementation for fetching kline data, using [KlineDatasource]
/// to retrieve data and converting DTOs to [Kline] entities.
class KlineRepositoryImpl implements KlineRepository {
  /// Creates a [KlineRepositoryImpl] with the required [KlineDatasource].
  const KlineRepositoryImpl({required this.datasource});

  /// The datasource used to fetch kline data.
  final KlineDatasource datasource;

  @override
  Future<Either<Failure, List<Kline>>> getKlines({
    required final String symbol,
    required final String interval,
    final int limit = 24,
  }) async {
    final Either<Failure, List<KlineDTO>> result = await datasource.getKlines(
      symbol: symbol,
      interval: interval,
      limit: limit,
    );

    return result.map(
      (final List<KlineDTO> dtos) =>
          dtos.map((final KlineDTO dto) => dto.toEntity()).toList(),
    );
  }
}
