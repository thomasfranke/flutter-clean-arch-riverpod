import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/auto_route.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// List tile widget that displays information about a single crypto quote,
/// including the symbol, last price, price change percentage, and quote volume.
/// Tapping on the tile navigates to a detail screen for the selected quote.
/// A star icon allows the user to toggle the quote as a favorite.
class QuoteTile extends ConsumerWidget {
  /// Creates a new instance of [QuoteTile] with the given [quote].
  const QuoteTile({required this.quote, super.key});

  /// The crypto quote to display in this tile.
  final CryptoQuoteEntity quote;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isPositive = quote.priceChangePct >= 0;

    final FavoritesState favoritesState = ref.watch(favoritesProvider);
    final bool isFavorite = switch (favoritesState) {
      FavoritesStateSuccess(:final List<FavoriteEntity> favorites) =>
        favorites.any((final FavoriteEntity f) => f.symbol == quote.symbol),
      _ => false,
    };

    return ListTile(
      title: Text(quote.symbol),
      subtitle: Text('Vol: ${quote.quoteVolume.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                quote.lastPrice.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '''${isPositive ? '+' : ''}${quote.priceChangePct.toStringAsFixed(2)}%''',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_outline,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () => ref
                .read(favoritesProvider.notifier)
                .toggleFavorite(quote.symbol),
          ),
        ],
      ),
      onTap: () async {
        await context.router.push(CryptoQuoteDetailRoute(quote: quote));
      },
    );
  }
}
