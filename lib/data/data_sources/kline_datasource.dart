import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/kline_dto.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';

/// Datasource for fetching kline (candlestick) data from the Binance API.
class KlineDatasource {
  /// Creates a [KlineDatasource] with the required [HttpClientInterface].
  const KlineDatasource({required this.httpClient});

  /// The API client used to perform HTTP requests.
  final HttpClientInterface httpClient;

  /// Fetches klines for the given [symbol] and [interval] from the Binance
  /// API, returning either a [Failure] or a list of [KlineDTO].
  Future<Either<Failure, List<KlineDTO>>> getKlines({
    required final String symbol,
    required final String interval,
    final int limit = 24,
  }) async {
    final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
        await httpClient.request(
          apiRoute: const ApiRoute('/api/v3/klines', HttpMethod.get),
          queryParameters: <String, dynamic>{
            'symbol': symbol,
            'interval': interval,
            'limit': limit,
          },
        );

    return result.fold(
      (final HttpClientFailure failure) =>
          Left<Failure, List<KlineDTO>>(failure.toDomainFailure()),
      (final HttpClientResponse<dynamic> response) {
        try {
          final List<KlineDTO> klines = (response.data as List<dynamic>)
              .map<KlineDTO>(
                (final dynamic e) => KlineDTO.fromList(e as List<dynamic>),
              )
              .toList();
          return Right<Failure, List<KlineDTO>>(klines);
        } on Object catch (e, st) {
          log('Error: $e', name: 'KlineDatasource', error: e, stackTrace: st);
          return const Left<Failure, List<KlineDTO>>(Failure.parse());
        }
      },
    );
  }
}
