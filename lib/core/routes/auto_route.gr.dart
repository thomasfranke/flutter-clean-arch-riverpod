// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'auto_route.dart';

/// generated route for
/// [CryptoQuoteDetailScreen]
class CryptoQuoteDetailRoute extends PageRouteInfo<CryptoQuoteDetailRouteArgs> {
  CryptoQuoteDetailRoute({
    required CryptoQuoteEntity quote,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CryptoQuoteDetailRoute.name,
         args: CryptoQuoteDetailRouteArgs(quote: quote, key: key),
         initialChildren: children,
       );

  static const String name = 'CryptoQuoteDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CryptoQuoteDetailRouteArgs>();
      return CryptoQuoteDetailScreen(quote: args.quote, key: args.key);
    },
  );
}

class CryptoQuoteDetailRouteArgs {
  const CryptoQuoteDetailRouteArgs({required this.quote, this.key});

  final CryptoQuoteEntity quote;

  final Key? key;

  @override
  String toString() {
    return 'CryptoQuoteDetailRouteArgs{quote: $quote, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CryptoQuoteDetailRouteArgs) return false;
    return quote == other.quote && key == other.key;
  }

  @override
  int get hashCode => quote.hashCode ^ key.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [PreferencesScreen]
class PreferencesRoute extends PageRouteInfo<void> {
  const PreferencesRoute({List<PageRouteInfo>? children})
    : super(PreferencesRoute.name, initialChildren: children);

  static const String name = 'PreferencesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PreferencesScreen();
    },
  );
}
