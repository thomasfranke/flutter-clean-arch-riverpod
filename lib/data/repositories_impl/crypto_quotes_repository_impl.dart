import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/entity_list.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/failure_mappers.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/http_client/http_client_failure.dart';

/// Repository implementation for fetching cryptocurrency quotes, using a
/// [CryptoQuoteDatasource] to retrieve data and converting it to domain
/// entities.
///
/// This is the boundary, in both directions: the datasource hands it a DTO
/// and an [HttpClientFailure], and it hands the domain an entity and a
/// [Failure]. The translation lives here because this is the class that
/// implements a domain contract — nothing below it is obliged to know the
/// domain's vocabulary, and nothing above it may see infrastructure's.
class CryptoQuotesRepositoryImpl implements CryptoQuoteRepository {
  /// Creates a [CryptoQuotesRepositoryImpl] with the
  /// required [CryptoQuoteDatasource].
  const CryptoQuotesRepositoryImpl({required this.datasource});

  /// The data source used to fetch cryptocurrency quotes.
  final CryptoQuoteDatasource datasource;

  @override
  Future<Either<Failure, List<CryptoQuoteEntity>>> getQuotes() async {
    final Either<HttpClientFailure, List<CryptoQuoteDTO>> result =
        await datasource.getQuotes();

    return result
        .leftMap((final HttpClientFailure failure) => failure.toDomainFailure())
        .flatMap(
          (final List<CryptoQuoteDTO> dtos) => toEntities(
            dtos,
            (final CryptoQuoteDTO dto) => dto.toEntity(),
            source: 'CryptoQuotesRepositoryImpl',
          ),
        );
  }

  @override
  Future<Either<Failure, CryptoQuoteEntity>> getQuote(
    final String symbol,
  ) async {
    final Either<HttpClientFailure, CryptoQuoteDTO> result = await datasource
        .getQuote(symbol);

    return result
        .leftMap((final HttpClientFailure failure) => failure.toDomainFailure())
        .flatMap(
          (final CryptoQuoteDTO dto) =>
              toEntity(dto, (final CryptoQuoteDTO dto) => dto.toEntity()),
        );
  }
}
