import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/models/http_methods.dart';

/// Datasource for fetching kline (candlestick) data from the Binance API.
class KlineDatasource {
  /// Creates a [KlineDatasource] with the required [ApiClientInterface].
  const KlineDatasource({required this.apiClient});

  /// The API client used to perform HTTP requests.
  final ApiClientInterface apiClient;

  /// Fetches klines for the given [symbol] and [interval] from the Binance
  /// API, returning either a [Failure] or a list of [KlineDTO].
  Future<Either<Failure, List<KlineDTO>>> getKlines({
    required final String symbol,
    required final String interval,
    final int limit = 24,
  }) async {
    final Either<ApiClientFailure, Response<dynamic>> result = await apiClient
        .request(
          apiRoute: const ApiRoute('/api/v3/klines', HttpMethod.get),
          queryParameters: <String, dynamic>{
            'symbol': symbol,
            'interval': interval,
            'limit': limit,
          },
        );

    return result.fold(
      (final ApiClientFailure failure) =>
          Left<Failure, List<KlineDTO>>(failure.toDomainFailure()),
      (final Response<dynamic> response) {
        try {
          final List<KlineDTO> klines = (response.data as List<dynamic>)
              .map<KlineDTO>(
                (final dynamic e) => KlineDTO.fromList(e as List<dynamic>),
              )
              .toList();
          return Right<Failure, List<KlineDTO>>(klines);
        } on Object catch (e, st) {
          debugPrint('Error: $e');
          debugPrintStack(stackTrace: st);
          return const Left<Failure, List<KlineDTO>>(Failure.parse());
        }
      },
    );
  }
}
