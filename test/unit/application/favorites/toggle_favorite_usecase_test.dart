import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late _MockFavoritesRepository repository;
  late ToggleFavoriteUseCase sut;

  setUp(() {
    repository = _MockFavoritesRepository();
    sut = ToggleFavoriteUseCase(repository: repository);
  });

  const String tSymbol = 'BTCUSDT';
  final List<FavoriteEntity> tFavoritesWithSymbol = <FavoriteEntity>[
    const FavoriteEntity(symbol: tSymbol),
    const FavoriteEntity(symbol: 'ETHUSDT'),
  ];
  final List<FavoriteEntity> tFavoritesWithoutSymbol = <FavoriteEntity>[
    const FavoriteEntity(symbol: 'ETHUSDT'),
  ];

  group('ToggleFavoriteUseCase', () {
    test('should delegate to repository.toggleFavorite atomically', () async {
      when(() => repository.toggleFavorite(tSymbol)).thenAnswer(
        (_) async =>
            Right<Failure, List<FavoriteEntity>>(tFavoritesWithoutSymbol),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        Right<Failure, List<FavoriteEntity>>(tFavoritesWithoutSymbol),
      );
      verify(() => repository.toggleFavorite(tSymbol)).called(1);
    });

    test('should return the updated list when a symbol is added', () async {
      when(() => repository.toggleFavorite(tSymbol)).thenAnswer(
        (_) async => Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );
    });

    test('should return Failure when toggleFavorite fails', () async {
      when(() => repository.toggleFavorite(tSymbol)).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
    });
  });
}
