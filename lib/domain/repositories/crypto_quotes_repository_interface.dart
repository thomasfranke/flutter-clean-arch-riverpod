import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';

/// Repository interface for fetching cryptocurrency quotes, defining the
/// contract for the repository implementation.
abstract interface class CryptoQuoteRepository {
  /// Fetches a list of cryptocurrency quotes.
  Future<Either<Failure, List<CryptoQuoteEntity>>> getQuotes();

  /// Fetches a single cryptocurrency quote for the given [symbol].
  Future<Either<Failure, CryptoQuoteEntity>> getQuote(final String symbol);
}
