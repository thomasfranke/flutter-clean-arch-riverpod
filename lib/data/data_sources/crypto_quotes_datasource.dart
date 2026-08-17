import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';

/// Data source for fetching cryptocurrency quotes from an API.
class CryptoQuoteDatasource {
  /// Creates a [CryptoQuoteDatasource] with the required [HttpClientInterface].
  const CryptoQuoteDatasource({required this.httpClient});

  /// Converts an [HttpClientFailure] to a domain [Failure].
  final HttpClientInterface httpClient;

  /// Fetches a list of cryptocurrency quotes.
  Future<Either<Failure, List<CryptoQuoteDTO>>> getQuotes() async {
    final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
        await httpClient.request(
          apiRoute: const ApiRoute('/api/v3/ticker/24hr', HttpMethod.get),
        );

    return result.fold(
      (final HttpClientFailure failure) =>
          Left<Failure, List<CryptoQuoteDTO>>(failure.toDomainFailure()),
      (final HttpClientResponse<dynamic> response) {
        try {
          final List<CryptoQuoteDTO> list = (response.data as List<dynamic>)
              .map<CryptoQuoteDTO>(
                (final dynamic e) =>
                    CryptoQuoteDTO.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return Right<Failure, List<CryptoQuoteDTO>>(list);
        } on Object catch (e, st) {
          log(
            'Error: $e',
            name: 'CryptoQuoteDatasource',
            error: e,
            stackTrace: st,
          );
          return const Left<Failure, List<CryptoQuoteDTO>>(Failure.parse());
        }
      },
    );
  }

  /// Fetches a single cryptocurrency quote for the given [symbol].
  Future<Either<Failure, CryptoQuoteDTO>> getQuote(final String symbol) async {
    final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
        await httpClient.request(
          apiRoute: const ApiRoute('/api/v3/ticker/24hr', HttpMethod.get),
          queryParameters: <String, dynamic>{'symbol': symbol},
        );

    return result.fold(
      (final HttpClientFailure failure) =>
          Left<Failure, CryptoQuoteDTO>(failure.toDomainFailure()),
      (final HttpClientResponse<dynamic> response) {
        try {
          final CryptoQuoteDTO dto = CryptoQuoteDTO.fromJson(
            response.data as Map<String, dynamic>,
          );
          return Right<Failure, CryptoQuoteDTO>(dto);
        } on Object catch (e, st) {
          log(
            'Error: $e',
            name: 'CryptoQuoteDatasource',
            error: e,
            stackTrace: st,
          );
          return const Left<Failure, CryptoQuoteDTO>(Failure.parse());
        }
      },
    );
  }
}
