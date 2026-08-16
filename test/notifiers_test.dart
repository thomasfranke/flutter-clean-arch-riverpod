import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase_di.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_state.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _MockCryptoQuoteRepository extends Mock
    implements CryptoQuoteRepository {}

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  const CryptoQuoteEntity tQuote = CryptoQuoteEntity(
    symbol: 'BTCUSDT',
    lastPrice: 60000,
    priceChange: 1000,
    priceChangePct: 1.69,
    highPrice: 61000,
    lowPrice: 59000,
    volume: 500,
    quoteVolume: 30000000,
  );

  group('CryptoQuoteNotifier', () {
    late _MockCryptoQuoteRepository repository;

    setUp(() {
      repository = _MockCryptoQuoteRepository();
    });

    ProviderContainer makeContainer() => ProviderContainer(
      overrides: <Override>[
        getCryptoQuotesUseCaseProvider.overrideWithValue(
          GetCryptoQuotesUseCase(repository: repository),
        ),
      ],
    );

    test('estado inicial deve ser loading', () {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      expect(
        container.read(cryptoQuoteProvider),
        isA<CryptoQuoteStateLoading>(),
      );
    });

    test('deve emitir success após fetch bem-sucedido', () async {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async => const Right<Failure, List<CryptoQuoteEntity>>(
          <CryptoQuoteEntity>[tQuote],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(cryptoQuoteProvider.notifier).fetchQuotes();

      expect(
        container.read(cryptoQuoteProvider),
        const CryptoQuoteState.success(<CryptoQuoteEntity>[tQuote]),
      );
    });

    test('deve emitir failure quando repositório falha', () async {
      when(() => repository.getQuotes()).thenAnswer(
        (_) async =>
            const Left<Failure, List<CryptoQuoteEntity>>(Failure.apiNetwork()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(cryptoQuoteProvider.notifier).fetchQuotes();

      expect(
        container.read(cryptoQuoteProvider),
        const CryptoQuoteState.failure(Failure.apiNetwork()),
      );
    });
  });

  group('FavoritesNotifier', () {
    late _MockFavoritesRepository repository;

    setUp(() {
      repository = _MockFavoritesRepository();
    });

    ProviderContainer makeContainer() => ProviderContainer(
      overrides: <Override>[
        getFavoritesUseCaseProvider.overrideWithValue(
          GetFavoritesUseCase(repository: repository),
        ),
        toggleFavoriteUseCaseProvider.overrideWithValue(
          ToggleFavoriteUseCase(repository: repository),
        ),
      ],
    );

    test('deve emitir success com lista de favoritos', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider),
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
      );
    });

    test('deve emitir failure quando getFavorites falha', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider),
        const FavoritesState.failure(Failure.storage()),
      );
    });

    test(
      'isFavorite deve retornar true quando símbolo está na lista',
      () async {
        when(() => repository.getFavorites()).thenAnswer(
          (_) async => const Right<Failure, List<FavoriteEntity>>(
            <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
          ),
        );

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(favoritesProvider.notifier).loadFavorites();

        expect(
          container.read(favoritesProvider.notifier).isFavorite('BTCUSDT'),
          isTrue,
        );
        expect(
          container.read(favoritesProvider.notifier).isFavorite('ETHUSDT'),
          isFalse,
        );
      },
    );

    test('isFavorite deve retornar false em estado não-success', () async {
      when(() => repository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      final ProviderContainer container = makeContainer();
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).loadFavorites();

      expect(
        container.read(favoritesProvider.notifier).isFavorite('BTCUSDT'),
        isFalse,
      );
    });

    test(
      'toggleFavorite deve atualizar estado após operação bem-sucedida',
      () async {
        when(() => repository.getFavorites()).thenAnswer(
          (_) async =>
              const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
        );
        when(() => repository.addFavorite('BTCUSDT')).thenAnswer(
          (_) async => const Right<Failure, List<FavoriteEntity>>(
            <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
          ),
        );

        final ProviderContainer container = makeContainer();
        addTearDown(container.dispose);

        await container.read(favoritesProvider.notifier).loadFavorites();
        await container
            .read(favoritesProvider.notifier)
            .toggleFavorite('BTCUSDT');

        expect(
          container.read(favoritesProvider),
          const FavoritesState.success(<FavoriteEntity>[
            FavoriteEntity(symbol: 'BTCUSDT'),
          ]),
        );
      },
    );
  });
}
