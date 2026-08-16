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
    test('deve chamar removeFavorite quando símbolo já é favorito', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async => Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );
      when(() => repository.removeFavorite(tSymbol)).thenAnswer(
        (_) async =>
            Right<Failure, List<FavoriteEntity>>(tFavoritesWithoutSymbol),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        Right<Failure, List<FavoriteEntity>>(tFavoritesWithoutSymbol),
      );
      verify(() => repository.getFavorites()).called(1);
      verify(() => repository.removeFavorite(tSymbol)).called(1);
      verifyNever(() => repository.addFavorite(any()));
    });

    test('deve chamar addFavorite quando símbolo não é favorito', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            Right<Failure, List<FavoriteEntity>>(tFavoritesWithoutSymbol),
      );
      when(() => repository.addFavorite(tSymbol)).thenAnswer(
        (_) async => Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );
      verify(() => repository.getFavorites()).called(1);
      verify(() => repository.addFavorite(tSymbol)).called(1);
      verifyNever(() => repository.removeFavorite(any()));
    });

    test('deve retornar Failure quando getFavorites falha', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final Either<Failure, List<FavoriteEntity>> result = await sut(tSymbol);

      expect(
        result,
        const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );
      verify(() => repository.getFavorites()).called(1);
      verifyNever(() => repository.addFavorite(any()));
      verifyNever(() => repository.removeFavorite(any()));
    });

    test('deve retornar Failure quando removeFavorite falha', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async => Right<Failure, List<FavoriteEntity>>(tFavoritesWithSymbol),
      );
      when(() => repository.removeFavorite(tSymbol)).thenAnswer(
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
