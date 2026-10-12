import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/crypto_quotes_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/failures/failure_message_mapper.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/favorites_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_tile_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../test_helpers.dart';

class _MockFavoritesRepository extends Mock
    implements FavoritesRepositoryInterface {}

class _MockCryptoQuotesRepository extends Mock
    implements CryptoQuotesRepositoryInterface {}

CryptoQuoteEntity _quote(final String symbol) => CryptoQuoteEntity(
  symbol: symbol,
  lastPrice: 1,
  priceChange: 0,
  priceChangePct: 0,
  highPrice: 1,
  lowPrice: 1,
  volume: 1,
  quoteVolume: 1,
);

final List<CryptoQuoteEntity> _quotes = <CryptoQuoteEntity>[
  _quote('BTCUSDT'),
  _quote('ETHUSDT'),
];

void main() {
  late _MockFavoritesRepository favoritesRepository;
  late _MockCryptoQuotesRepository quotesRepository;

  setUp(() {
    favoritesRepository = _MockFavoritesRepository();
    quotesRepository = _MockCryptoQuotesRepository();
    when(
      () => quotesRepository.getQuotes(),
    ).thenAnswer((_) async => Right<Failure, List<CryptoQuoteEntity>>(_quotes));
  });

  List<Override> overrides() => <Override>[
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
    cryptoQuotesRepositoryProvider.overrideWithValue(quotesRepository),
  ];

  Future<void> pumpTab(final WidgetTester tester) async {
    await pumpApp(
      tester,
      FavoritesTab(quotes: _quotes),
      overrides: overrides(),
    );
    await tester.pumpAndSettle();
  }

  group('FavoritesTab', () {
    testWidgets('lists only the quotes that are favorites', (
      final WidgetTester tester,
    ) async {
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'ETHUSDT')],
        ),
      );

      await pumpTab(tester);

      expect(find.byType(QuoteTileWidget), findsOneWidget);
      expect(find.text('ETHUSDT'), findsOneWidget);
      expect(find.text('BTCUSDT'), findsNothing);
    });

    testWidgets('says there are none yet, in the app language', (
      final WidgetTester tester,
    ) async {
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async =>
            const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
      );

      await pumpTab(tester);

      final BuildContext context = tester.element(find.byType(FavoritesTab));
      expect(
        find.text(AppLocalizations.of(context).noFavoritesYet),
        findsOneWidget,
      );
      expect(find.byType(QuoteTileWidget), findsNothing);
    });

    testWidgets('ignores a favorite whose quote is not in the list', (
      final WidgetTester tester,
    ) async {
      // A symbol delisted since it was starred: the star survives in storage
      // and there is no quote to draw, which must not be an empty tile.
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'GONEUSDT')],
        ),
      );

      await pumpTab(tester);

      expect(find.byType(QuoteTileWidget), findsNothing);
    });

    testWidgets('says what went wrong when the favorites cannot be read', (
      final WidgetTester tester,
    ) async {
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async =>
            const Left<Failure, List<FavoriteEntity>>(Failure.storage()),
      );

      await pumpTab(tester);

      final BuildContext context = tester.element(find.byType(FavoritesTab));
      expect(
        find.text(
          const Failure.storage().message(AppLocalizations.of(context)),
        ),
        findsOneWidget,
      );
    });
  });
}
