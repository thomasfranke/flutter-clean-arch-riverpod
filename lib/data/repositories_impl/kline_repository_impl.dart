import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/entity_list.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/failure_mappers.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/kline_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';

/// Repository implementation for fetching kline data, using [KlineDatasource]
/// to retrieve data and converting DTOs to [Kline] entities.
///
/// Like every repository here, it is where an [HttpClientFailure] becomes a
/// [Failure] — the datasource below only resolves data.
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
    final Either<HttpClientFailure, List<KlineDTO>> result = await datasource
        .getKlines(symbol: symbol, interval: interval, limit: limit);

    return result
        .leftMap((final HttpClientFailure failure) => failure.toDomainFailure())
        .flatMap(
          (final List<KlineDTO> dtos) => toEntities(
            dtos,
            (final KlineDTO dto) => dto.toEntity(),
            source: 'KlineRepositoryImpl',
          ),
        );
  }
}
