import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';

/// Use case for fetching cryptocurrency quotes.
class GetCryptoQuotesUseCase {
  /// Creates a [GetCryptoQuotesUseCase] with the
  /// required [CryptoQuoteRepository].
  const GetCryptoQuotesUseCase({required this.repository});

  /// The repository used to fetch cryptocurrency quotes.
  final CryptoQuoteRepository repository;

  /// Executes the use case to fetch cryptocurrency quotes, returning either a
  /// [Failure] or a list of [CryptoQuoteEntity] entities.
  Future<Either<Failure, List<CryptoQuoteEntity>>> call() =>
      repository.getQuotes();
}
