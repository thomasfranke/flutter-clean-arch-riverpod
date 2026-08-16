import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_entity.freezed.dart';

/// Domain entity representing a favorite cryptocurrency, identified by its
/// symbol.
@freezed
abstract class FavoriteEntity with _$FavoriteEntity {
  /// Creates a [FavoriteEntity] instance with the given [symbol].
  const factory FavoriteEntity({required final String symbol}) =
      _FavoriteEntity;
}
