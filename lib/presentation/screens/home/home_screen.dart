import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/crypto_quote/crypto_quote_state.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/favorites_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/tabs/quotes_tab.dart';
import 'package:flutter_clean_arch_riverpod/presentation/screens/home/widgets/drawer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen displaying a list of crypto quotes with loading and
/// error states.
@RoutePage()
class HomeScreen extends ConsumerWidget {
  /// Creates a new instance of [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final CryptoQuoteState state = ref.watch(cryptoQuoteProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crypto Quotes'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.show_chart),
                text: AppLocalizations.of(context).quotes,
              ),
              Tab(
                icon: const Icon(Icons.star_outline),
                text: AppLocalizations.of(context).favorites,
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: switch (state) {
          CryptoQuoteStateInitial() || CryptoQuoteStateLoading() =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          CryptoQuoteStateFailure(:final Failure failure) => Center(
            child: Text(failure.toString()),
          ),
          CryptoQuoteStateSuccess(:final List<CryptoQuoteEntity> quotes) =>
            TabBarView(
              children: <Widget>[
                QuotesTab(quotes: quotes),
                FavoritesTab(quotes: quotes),
              ],
            ),
        },
      ),
    );
  }
}
