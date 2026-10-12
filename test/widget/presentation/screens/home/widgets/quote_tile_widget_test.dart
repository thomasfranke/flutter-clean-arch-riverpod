import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl_di.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/favorites_repository_interface.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_tile_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../test_helpers.dart';

class _MockFavoritesRepository extends Mock
    implements FavoritesRepositoryInterface {}

const CryptoQuoteEntity _rising = CryptoQuoteEntity(
  symbol: 'BTCUSDT',
  lastPrice: 1234.5,
  priceChange: 10,
  priceChangePct: 2.5,
  highPrice: 1300,
  lowPrice: 1200,
  volume: 100,
  quoteVolume: 9876.54,
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

  Future<void> pumpTile(final WidgetTester tester) async {
    await pumpApp(
      tester,
      const QuoteTileWidget(quote: _rising),
      overrides: overrides(),
    );
    await tester.pumpAndSettle();
  }

  group('QuoteTileWidget', () {
    testWidgets('shows the symbol, the price and the change', (
      final WidgetTester tester,
    ) async {
      await pumpTile(tester);

      expect(find.text('BTCUSDT'), findsOneWidget);
      expect(find.text('1234.50'), findsOneWidget);
      // A rise is signed, so it cannot be read as a fall.
      expect(find.text('+2.50%'), findsOneWidget);
    });

    testWidgets('shows the volume in the language of the app', (
      final WidgetTester tester,
    ) async {
      await pumpTile(tester);

      final BuildContext context = tester.element(find.text('BTCUSDT'));
      expect(
        find.text(AppLocalizations.of(context).volumeLabel('9876.54')),
        findsOneWidget,
      );
    });

    testWidgets('signs a fall with no plus, and colours it red', (
      final WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        QuoteTileWidget(quote: _rising.copyWith(priceChangePct: -1.25)),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text('-1.25%'), findsOneWidget);
      final Text change = tester.widget<Text>(find.text('-1.25%'));
      expect(change.style?.color, Colors.red);
    });

    testWidgets('draws a hollow star while the quote is not a favorite', (
      final WidgetTester tester,
    ) async {
      await pumpTile(tester);

      expect(find.byIcon(Icons.star_outline), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('draws a filled star once the quote is a favorite', (
      final WidgetTester tester,
    ) async {
      when(() => favoritesRepository.getFavorites()).thenAnswer(
        (_) async => const Right<Failure, List<FavoriteEntity>>(
          <FavoriteEntity>[FavoriteEntity(symbol: 'BTCUSDT')],
        ),
      );

      await pumpTile(tester);

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.star_outline), findsNothing);
    });
  });
}
