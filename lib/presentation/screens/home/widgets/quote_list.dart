import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list_tile.dart';

/// Widget that displays a list of crypto quotes with pull-to-refresh
/// functionality.
class QuoteList extends StatelessWidget {
  /// Creates a new instance of [QuoteList].
  const QuoteList({required this.quotes, required this.onRefresh, super.key});

  /// The list of crypto quotes to display.
  final List<CryptoQuoteEntity> quotes;

  /// Callback function to refresh the list of quotes when the user performs
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (final BuildContext context, final int index) {
        final CryptoQuoteEntity quote = quotes[index];
        return QuoteTile(quote: quote);
      },
    ),
  );
}
