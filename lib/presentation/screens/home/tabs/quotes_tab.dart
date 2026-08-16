import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/quote_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tab that displays a list of crypto quotes with a search bar for filtering by
/// symbol and pull-to-refresh functionality.
class QuotesTab extends ConsumerStatefulWidget {
  /// Creates a new instance of [QuotesTab] with the given list of [quotes].
  const QuotesTab({required this.quotes, super.key});

  /// The list of crypto quotes to display in this tab.
  final List<CryptoQuoteEntity> quotes;

  @override
  ConsumerState<QuotesTab> createState() => _QuotesTabState();
}

class _QuotesTabState extends ConsumerState<QuotesTab> {
  final TextEditingController _controller = TextEditingController();
  List<CryptoQuoteEntity> _filtered = <CryptoQuoteEntity>[];

  @override
  void initState() {
    super.initState();
    _filtered = widget.quotes;
    _controller.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    final String query = _controller.text.trim().toUpperCase();
    setState(() {
      _filtered = query.isEmpty
          ? widget.quotes
          : widget.quotes
                .where((final CryptoQuoteEntity q) => q.symbol.contains(query))
                .toList();
    });
  }

  @override
  Widget build(final BuildContext context) => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).filterBySymbol,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      Expanded(
        child: QuoteList(
          quotes: _filtered,
          onRefresh: () => ref.read(cryptoQuoteProvider.notifier).fetchQuotes(),
        ),
      ),
    ],
  );
}
