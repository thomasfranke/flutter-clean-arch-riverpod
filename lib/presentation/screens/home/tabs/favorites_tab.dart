import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tab that displays the user's favorite crypto quotes, filtered from the
/// complete list of quotes by the user's saved favorites.
class FavoritesTab extends ConsumerWidget {
  /// Creates a new instance of [FavoritesTab] with the given list of [quotes].
  const FavoritesTab({required this.quotes, super.key});

  /// The complete list of crypto quotes to filter favorites from.
  final List<CryptoQuoteEntity> quotes;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final FavoritesState favoritesState = ref.watch(favoritesProvider);

    return switch (favoritesState) {
      FavoritesStateInitial() || FavoritesStateLoading() => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      FavoritesStateFailure(:final Failure failure) => Center(
        child: Text(failure.toString()),
      ),
      FavoritesStateSuccess(:final List<FavoriteEntity> favorites) =>
        _buildList(ref, favorites),
    };
  }

  Widget _buildList(final WidgetRef ref, final List<FavoriteEntity> favorites) {
    final List<CryptoQuoteEntity> favoriteQuotes = quotes
        .where(
          (final CryptoQuoteEntity q) =>
              favorites.any((final FavoriteEntity f) => f.symbol == q.symbol),
        )
        .toList();

    if (favoriteQuotes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.star_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum favorito ainda', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return QuoteList(
      quotes: favoriteQuotes,
      onRefresh: () => ref.read(cryptoQuoteProvider.notifier).fetchQuotes(),
    );
  }
}
