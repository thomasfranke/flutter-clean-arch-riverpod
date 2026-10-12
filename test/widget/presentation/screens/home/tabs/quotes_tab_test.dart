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
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/quotes_tab.dart';
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
  _quote('SOLUSDT'),
];

void main() {
  late _MockFavoritesRepository favoritesRepository;
  late _MockCryptoQuotesRepository quotesRepository;

  setUp(() {
    favoritesRepository = _MockFavoritesRepository();
    quotesRepository = _MockCryptoQuotesRepository();
    when(() => favoritesRepository.getFavorites()).thenAnswer(
      (_) async =>
          const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
    );
    when(
      () => quotesRepository.getQuotes(),
    ).thenAnswer((_) async => Right<Failure, List<CryptoQuoteEntity>>(_quotes));
  });

  List<Override> overrides() => <Override>[
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
    cryptoQuotesRepositoryProvider.overrideWithValue(quotesRepository),
  ];

  Future<void> pumpTab(final WidgetTester tester) async {
    await pumpApp(tester, QuotesTab(quotes: _quotes), overrides: overrides());
    await tester.pumpAndSettle();
  }

  group('QuotesTab', () {
    testWidgets('lists every quote it was given', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);

      expect(find.byType(QuoteTileWidget), findsNWidgets(3));
    });

    testWidgets('offers a search field, labelled in the app language', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);

      final BuildContext context = tester.element(find.byType(TextField));
      expect(
        find.text(AppLocalizations.of(context).filterBySymbol),
        findsOneWidget,
      );
    });

    testWidgets('filters the list as the symbol is typed', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);

      await tester.enterText(find.byType(TextField), 'eth');
      await tester.pumpAndSettle();

      expect(find.byType(QuoteTileWidget), findsOneWidget);
      expect(find.text('ETHUSDT'), findsOneWidget);
    });

    testWidgets('matches a symbol whatever case it is typed in', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);

      await tester.enterText(find.byType(TextField), 'SOL');
      await tester.pumpAndSettle();

      expect(find.text('SOLUSDT'), findsOneWidget);
      expect(find.byType(QuoteTileWidget), findsOneWidget);
    });

    testWidgets('shows everything again once the field is cleared', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);
      await tester.enterText(find.byType(TextField), 'BTC');
      await tester.pumpAndSettle();
      expect(find.byType(QuoteTileWidget), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(find.byType(QuoteTileWidget), findsNWidgets(3));
    });

    testWidgets('lists nothing when no symbol matches', (
      final WidgetTester tester,
    ) async {
      await pumpTab(tester);

      await tester.enterText(find.byType(TextField), 'NOTHING');
      await tester.pumpAndSettle();

      expect(find.byType(QuoteTileWidget), findsNothing);
    });
  });
}
