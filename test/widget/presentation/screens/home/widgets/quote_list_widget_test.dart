import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list_widget.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_tile_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../test_helpers.dart';

class _MockFavoritesRepository extends Mock
    implements FavoritesRepositoryInterface {}

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

void main() {
  late _MockFavoritesRepository favoritesRepository;

  setUp(() {
    favoritesRepository = _MockFavoritesRepository();
    when(() => favoritesRepository.getFavorites()).thenAnswer(
      (_) async =>
          const Right<Failure, List<FavoriteEntity>>(<FavoriteEntity>[]),
    );
  });

  List<Override> overrides() => <Override>[
    favoritesRepositoryProvider.overrideWithValue(favoritesRepository),
  ];

  group('QuoteListWidget', () {
    testWidgets('draws one tile per quote, in the order given', (
      final WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        QuoteListWidget(
          quotes: <CryptoQuoteEntity>[_quote('BTCUSDT'), _quote('ETHUSDT')],
          onRefresh: () async {},
        ),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuoteTileWidget), findsNWidgets(2));
      final List<String> drawn = tester
          .widgetList<QuoteTileWidget>(find.byType(QuoteTileWidget))
          .map((final QuoteTileWidget tile) => tile.quote.symbol)
          .toList();
      expect(drawn, <String>['BTCUSDT', 'ETHUSDT']);
    });

    testWidgets('draws nothing but an empty list when there are no quotes', (
      final WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        QuoteListWidget(
          quotes: const <CryptoQuoteEntity>[],
          onRefresh: () async {},
        ),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuoteTileWidget), findsNothing);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('calls onRefresh when the list is pulled down', (
      final WidgetTester tester,
    ) async {
      final Completer<void> refreshed = Completer<void>();

      await pumpApp(
        tester,
        QuoteListWidget(
          quotes: <CryptoQuoteEntity>[_quote('BTCUSDT')],
          onRefresh: () async {
            if (!refreshed.isCompleted) {
              refreshed.complete();
            }
          },
        ),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      expect(refreshed.isCompleted, isTrue);
    });
  });
}
