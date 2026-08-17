import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/get_favorites_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/favorites/toggle_favorite_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/quotes/get_crypto_quotes_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/crypto_quotes_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/favorites_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/crypto_quotes_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/favorites_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/crypto_quote_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_http_client.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Composite cross-feature integration flows', () {
    test(
      'favorites and preferences persist independently under the same '
      'SharedPreferencesImpl instance, with no key collisions',
      () async {
        final SharedPreferencesImpl storage =
            await SharedPreferencesImpl.create();

        final ToggleFavoriteUseCase toggleFavorite = ToggleFavoriteUseCase(
          repository: FavoritesRepositoryImpl(
            datasource: FavoritesDatasource(storage: storage),
          ),
        );
        final GetFavoritesUseCase getFavorites = GetFavoritesUseCase(
          repository: FavoritesRepositoryImpl(
            datasource: FavoritesDatasource(storage: storage),
          ),
        );
        final PreferencesRepositoryImpl preferencesRepository =
            PreferencesRepositoryImpl(
              datasource: PreferencesDatasource(storage: storage),
            );
        final UpdateLocaleUseCase updateLocale = UpdateLocaleUseCase(
          repository: preferencesRepository,
        );
        final GetPreferencesUseCase getPreferences = GetPreferencesUseCase(
          repository: preferencesRepository,
        );

        await toggleFavorite('BTCUSDT');
        await updateLocale('es');
        await toggleFavorite('ETHUSDT');

        final Either<Failure, List<FavoriteEntity>> favorites =
            await getFavorites();
        final Either<Failure, PreferencesEntity> preferences =
            await getPreferences();

        expect(
          favorites
              .getOrElse(() => <FavoriteEntity>[])
              .map((final FavoriteEntity e) => e.symbol),
          containsAll(<String>['BTCUSDT', 'ETHUSDT']),
        );
        expect(
          preferences.map((final PreferencesEntity e) => e.locale),
          const Right<Failure, String>('es'),
        );
      },
    );

    test(
      'a symbol favorited after being fetched via GetCryptoQuotesUseCase '
      'shows up through GetFavoritesUseCase, mirroring the quotes-screen -> '
      'favorites-tab user journey',
      () async {
        final FakeHttpClientInterface httpClient = FakeHttpClientInterface()
          ..enqueueSuccess(<Map<String, dynamic>>[
            <String, dynamic>{
              'symbol': 'BTCUSDT',
              'priceChange': '1.0',
              'priceChangePercent': '1.0',
              'weightedAvgPrice': '1.0',
              'prevClosePrice': '1.0',
              'lastPrice': '48000.0',
              'lastQty': '1.0',
              'bidPrice': '1.0',
              'bidQty': '1.0',
              'askPrice': '1.0',
              'askQty': '1.0',
              'openPrice': '1.0',
              'highPrice': '1.0',
              'lowPrice': '1.0',
              'volume': '1.0',
              'quoteVolume': '1.0',
              'openTime': 0,
              'closeTime': 0,
              'firstId': 0,
              'lastId': 0,
              'count': 0,
            },
          ]);
        final GetCryptoQuotesUseCase getQuotes = GetCryptoQuotesUseCase(
          repository: CryptoQuotesRepositoryImpl(
            datasource: CryptoQuoteDatasource(httpClient: httpClient),
          ),
        );

        final SharedPreferencesImpl storage =
            await SharedPreferencesImpl.create();
        final ToggleFavoriteUseCase toggleFavorite = ToggleFavoriteUseCase(
          repository: FavoritesRepositoryImpl(
            datasource: FavoritesDatasource(storage: storage),
          ),
        );
        final GetFavoritesUseCase getFavorites = GetFavoritesUseCase(
          repository: FavoritesRepositoryImpl(
            datasource: FavoritesDatasource(storage: storage),
          ),
        );

        final Either<Failure, List<CryptoQuoteEntity>> quotes =
            await getQuotes();
        final CryptoQuoteEntity quote = quotes
            .getOrElse(() => <CryptoQuoteEntity>[])
            .single;

        await toggleFavorite(quote.symbol);
        final Either<Failure, List<FavoriteEntity>> favorites =
            await getFavorites();

        expect(
          favorites
              .getOrElse(() => <FavoriteEntity>[])
              .map((final FavoriteEntity e) => e.symbol),
          contains('BTCUSDT'),
        );
      },
    );
  });
}
