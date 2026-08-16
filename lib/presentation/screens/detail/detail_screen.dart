import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/kline_chart_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail screen for displaying comprehensive information about a specific
/// crypto quote, including price, percentage change, and volume details.
@RoutePage()
class CryptoQuoteDetailScreen extends ConsumerWidget {
  /// Creates an instance of [CryptoQuoteDetailScreen].
  const CryptoQuoteDetailScreen({required this.quote, super.key});

  /// The crypto quote to display details for.
  final CryptoQuoteEntity quote;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isPositive = quote.priceChangePct >= 0;
    final Color changeColor = isPositive ? Colors.green : Colors.red;
    final String changeSign = isPositive ? '+' : '';

    final FavoritesState favoritesState = ref.watch(favoritesProvider);
    final bool isFavorite = switch (favoritesState) {
      FavoritesStateSuccess(:final List<FavoriteEntity> favorites) =>
        favorites.any((final FavoriteEntity f) => f.symbol == quote.symbol),
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(quote.symbol),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_outline,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () => ref
                .read(favoritesProvider.notifier)
                .toggleFavorite(quote.symbol),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _PriceHeader(
            quote: quote,
            isPositive: isPositive,
            changeColor: changeColor,
            changeSign: changeSign,
          ),
          const SizedBox(height: 24),
          _RangeBar(quote: quote),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Histórico de Preço',
            children: <Widget>[KlineChart(symbol: quote.symbol)],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: AppLocalizations.of(context).priceChange24h,
            children: <Widget>[
              _DetailRow(
                label: AppLocalizations.of(context).absoluteChange,
                value: '$changeSign${quote.priceChange.toStringAsFixed(8)}',
                valueColor: changeColor,
              ),
              _DetailRow(
                label: AppLocalizations.of(context).high24h,
                value: quote.highPrice.toStringAsFixed(8),
              ),
              _DetailRow(
                label: AppLocalizations.of(context).low24h,
                value: quote.lowPrice.toStringAsFixed(8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: AppLocalizations.of(context).baseVolume,
            children: <Widget>[
              _DetailRow(
                label: AppLocalizations.of(context).baseVolume,
                value: quote.volume.toStringAsFixed(4),
              ),
              _DetailRow(
                label: AppLocalizations.of(context).quoteVolume,
                value: quote.quoteVolume.toStringAsFixed(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Large price header with symbol, current price, percentage change and
/// trend chip.
class _PriceHeader extends StatelessWidget {
  const _PriceHeader({
    required this.quote,
    required this.isPositive,
    required this.changeColor,
    required this.changeSign,
  });

  final CryptoQuoteEntity quote;
  final bool isPositive;
  final Color changeColor;
  final String changeSign;

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        quote.symbol,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
      ),
      const SizedBox(height: 4),
      Text(
        quote.lastPrice.toStringAsFixed(8),
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        children: <Widget>[
          _TrendChip(
            isPositive: isPositive,
            changeColor: changeColor,
            changeSign: changeSign,
            priceChangePct: quote.priceChangePct,
          ),
        ],
      ),
    ],
  );
}

/// Chip indicating price trend direction and percentage.
class _TrendChip extends StatelessWidget {
  const _TrendChip({
    required this.isPositive,
    required this.changeColor,
    required this.changeSign,
    required this.priceChangePct,
  });

  final bool isPositive;
  final Color changeColor;
  final String changeSign;
  final double priceChangePct;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: changeColor.withAlpha(31),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: changeColor,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '$changeSign${priceChangePct.toStringAsFixed(2)}%',
          style: TextStyle(
            color: changeColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

/// Visual bar showing where the current price sits between the 24h low and
/// high.
class _RangeBar extends StatelessWidget {
  const _RangeBar({required this.quote});

  final CryptoQuoteEntity quote;

  @override
  Widget build(final BuildContext context) {
    final double range = quote.highPrice - quote.lowPrice;
    final double progress = range > 0
        ? ((quote.lastPrice - quote.lowPrice) / range).clamp(0.0, 1.0)
        : 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Range 24h',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.red.withAlpha(31),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              quote.lowPrice.toStringAsFixed(4),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            Text(
              quote.highPrice.toStringAsFixed(4),
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

/// Card grouping related detail rows under a section title.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(final BuildContext context) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.withAlpha(31)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
}

/// A single label/value row inside a section card.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    ),
  );
}
