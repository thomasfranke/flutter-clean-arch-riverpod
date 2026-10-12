import 'dart:developer';

import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/api_route.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_client_response.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/models/http_methods.dart';

/// Data source for fetching cryptocurrency quotes from an API.
///
/// It resolves data and nothing else: asks [HttpClientInterface] for a
/// payload and parses it into a DTO. What it hands back on failure is still
/// [HttpClientFailure] — translating that into a domain failure belongs to
/// the repository, which is the only place that knows what the failure means
/// for the call being composed.
class CryptoQuoteDatasource {
  /// Creates a [CryptoQuoteDatasource] with the required [HttpClientInterface].
  const CryptoQuoteDatasource({required this.httpClient});

  /// The API client used to perform HTTP requests.
  final HttpClientInterface httpClient;

  /// Fetches a list of cryptocurrency quotes.
  Future<Either<HttpClientFailure, List<CryptoQuoteDTO>>> getQuotes() async {
    final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
        await httpClient.request(
          apiRoute: const ApiRoute('/api/v3/ticker/24hr', HttpMethod.get),
        );

    return result.fold(Left<HttpClientFailure, List<CryptoQuoteDTO>>.new, (
      final HttpClientResponse<dynamic> response,
    ) {
      try {
        final List<CryptoQuoteDTO> list = (response.data as List<dynamic>)
            .map<CryptoQuoteDTO>(
              (final dynamic e) =>
                  CryptoQuoteDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        return Right<HttpClientFailure, List<CryptoQuoteDTO>>(list);
      } on Object catch (e, st) {
        log(
          'Error: $e',
          name: 'CryptoQuoteDatasource',
          error: e,
          stackTrace: st,
        );
        return const Left<HttpClientFailure, List<CryptoQuoteDTO>>(
          HttpClientFailure.parse(),
        );
      }
    });
  }

  /// Fetches a single cryptocurrency quote for the given [symbol].
  Future<Either<HttpClientFailure, CryptoQuoteDTO>> getQuote(
    final String symbol,
  ) async {
    final Either<HttpClientFailure, HttpClientResponse<dynamic>> result =
        await httpClient.request(
          apiRoute: const ApiRoute('/api/v3/ticker/24hr', HttpMethod.get),
          queryParameters: <String, dynamic>{'symbol': symbol},
        );

    return result.fold(Left<HttpClientFailure, CryptoQuoteDTO>.new, (
      final HttpClientResponse<dynamic> response,
    ) {
      try {
        final CryptoQuoteDTO dto = CryptoQuoteDTO.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right<HttpClientFailure, CryptoQuoteDTO>(dto);
      } on Object catch (e, st) {
        log(
          'Error: $e',
          name: 'CryptoQuoteDatasource',
          error: e,
          stackTrace: st,
        );
        return const Left<HttpClientFailure, CryptoQuoteDTO>(
          HttpClientFailure.parse(),
        );
      }
    });
  }
}
