import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/crypto_quote_dto.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';

/// Repository implementation for fetching cryptocurrency quotes, using a
/// [CryptoQuoteDatasource] to retrieve data and converting it to domain
/// entities.
class CryptoQuotesRepositoryImpl implements CryptoQuoteRepository {
  /// Creates a [CryptoQuotesRepositoryImpl] with the
  /// required [CryptoQuoteDatasource].
  const CryptoQuotesRepositoryImpl({required this.datasource});

  /// The data source used to fetch cryptocurrency quotes.
  final CryptoQuoteDatasource datasource;

  @override
  Future<Either<Failure, List<CryptoQuoteEntity>>> getQuotes() async {
    final Either<Failure, List<CryptoQuoteDTO>> result = await datasource
        .getQuotes();

    return result.fold(Left.new, (final List<CryptoQuoteDTO> dtos) {
      try {
        final List<CryptoQuoteEntity> entities = dtos
            .map((final CryptoQuoteDTO dto) => dto.toEntity())
            .toList();
        return Right<Failure, List<CryptoQuoteEntity>>(entities);
      } on Object catch (e, st) {
        debugPrint('Error: $e');
        debugPrintStack(stackTrace: st);
        return const Left<Failure, List<CryptoQuoteEntity>>(Failure.parse());
      }
    });
  }

  @override
  Future<Either<Failure, CryptoQuoteEntity>> getQuote(
    final String symbol,
  ) async {
    final Either<Failure, CryptoQuoteDTO> result = await datasource.getQuote(
      symbol,
    );

    return result.fold(Left.new, (final CryptoQuoteDTO dto) {
      try {
        return Right<Failure, CryptoQuoteEntity>(dto.toEntity());
      } on Object catch (e, st) {
        debugPrint('Error: $e');
        debugPrintStack(stackTrace: st);
        return const Left<Failure, CryptoQuoteEntity>(Failure.parse());
      }
    });
  }
}
