import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/favorite_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/favorites/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoritesState', () {
    test('should offer the four cases every screen switches over', () {
      // Spelled out rather than read back. The screens are a `switch` over
      // these four, and a case added or dropped changes what a screen has to
      // draw — which is the kind of change worth failing a test.
      expect(const FavoritesState.initial(), isA<FavoritesState>());
      expect(const FavoritesState.loading(), isA<FavoritesState>());
      expect(
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
        isA<FavoritesStateSuccess>(),
      );
      expect(
        const FavoritesState.failure(Failure.parse()),
        isA<FavoritesState>(),
      );
    });

    test('should carry the value the success case was given', () {
      const FavoritesStateSuccess success =
          FavoritesState.success(<FavoriteEntity>[
                FavoriteEntity(symbol: 'BTCUSDT'),
              ])
              as FavoritesStateSuccess;

      expect(success.favorites, const <FavoriteEntity>[
        FavoriteEntity(symbol: 'BTCUSDT'),
      ]);
    });

    test('should carry the failure the failure case was given', () {
      const FavoritesState state = FavoritesState.failure(Failure.storage());

      expect(state, const FavoritesState.failure(Failure.storage()));
      expect(state, isNot(const FavoritesState.failure(Failure.parse())));
    });

    test('should tell the empty cases apart', () {
      // `initial` is "nothing asked yet" and `loading` is "asked, waiting".
      // Equal, a notifier could not keep the last good value by testing for
      // one of them.
      expect(
        const FavoritesState.initial(),
        isNot(const FavoritesState.loading()),
      );
    });

    test('should compare two successes by what they hold', () {
      expect(
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
      );
      expect(
        const FavoritesState.success(<FavoriteEntity>[
          FavoriteEntity(symbol: 'BTCUSDT'),
        ]),
        isNot(
          const FavoritesState.success(<FavoriteEntity>[
            FavoriteEntity(symbol: 'ETHUSDT'),
          ]),
        ),
      );
    });
  });
}
