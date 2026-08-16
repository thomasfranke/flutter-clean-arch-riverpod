// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto_quote_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CryptoQuoteDTO {

/// The symbol of the cryptocurrency pair (e.g., "BTCUSDT").
 String? get symbol;/// The price change over the last 24 hours.
 String? get priceChange;/// The percentage price change over the last 24 hours.
 String? get priceChangePercent;/// The weighted average price over the last 24 hours.
 String? get weightedAvgPrice;/// The previous closing price.
 String? get prevClosePrice;/// The current price.
 String? get lastPrice;/// The quantity of the last trade.
 String? get lastQty;/// The highest bid price.
 String? get bidPrice;/// The quantity of the highest bid.
 String? get bidQty;/// The lowest ask price.
 String? get askPrice;/// The quantity of the lowest ask.
 String? get askQty;/// The opening price 24 hours ago.
 String? get openPrice;/// The highest price over the last 24 hours.
 String? get highPrice;/// The lowest price over the last 24 hours.
 String? get lowPrice;/// The total traded base asset volume over the last 24 hours.
 String? get volume;/// The total traded quote asset volume over the last 24 hours.
 String? get quoteVolume;/// The open time of the 24-hour period.
 int? get openTime;/// The close time of the 24-hour period.
 int? get closeTime;/// The first trade ID in the 24-hour period.
 int? get firstId;/// The last trade ID in the 24-hour period.
 int? get lastId;/// The total number of trades over the last 24 hours.
 int? get count;
/// Create a copy of CryptoQuoteDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoQuoteDTOCopyWith<CryptoQuoteDTO> get copyWith => _$CryptoQuoteDTOCopyWithImpl<CryptoQuoteDTO>(this as CryptoQuoteDTO, _$identity);

  /// Serializes this CryptoQuoteDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteDTO&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePercent, priceChangePercent) || other.priceChangePercent == priceChangePercent)&&(identical(other.weightedAvgPrice, weightedAvgPrice) || other.weightedAvgPrice == weightedAvgPrice)&&(identical(other.prevClosePrice, prevClosePrice) || other.prevClosePrice == prevClosePrice)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.lastQty, lastQty) || other.lastQty == lastQty)&&(identical(other.bidPrice, bidPrice) || other.bidPrice == bidPrice)&&(identical(other.bidQty, bidQty) || other.bidQty == bidQty)&&(identical(other.askPrice, askPrice) || other.askPrice == askPrice)&&(identical(other.askQty, askQty) || other.askQty == askQty)&&(identical(other.openPrice, openPrice) || other.openPrice == openPrice)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.firstId, firstId) || other.firstId == firstId)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,symbol,priceChange,priceChangePercent,weightedAvgPrice,prevClosePrice,lastPrice,lastQty,bidPrice,bidQty,askPrice,askQty,openPrice,highPrice,lowPrice,volume,quoteVolume,openTime,closeTime,firstId,lastId,count]);

@override
String toString() {
  return 'CryptoQuoteDTO(symbol: $symbol, priceChange: $priceChange, priceChangePercent: $priceChangePercent, weightedAvgPrice: $weightedAvgPrice, prevClosePrice: $prevClosePrice, lastPrice: $lastPrice, lastQty: $lastQty, bidPrice: $bidPrice, bidQty: $bidQty, askPrice: $askPrice, askQty: $askQty, openPrice: $openPrice, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume, openTime: $openTime, closeTime: $closeTime, firstId: $firstId, lastId: $lastId, count: $count)';
}


}

/// @nodoc
abstract mixin class $CryptoQuoteDTOCopyWith<$Res>  {
  factory $CryptoQuoteDTOCopyWith(CryptoQuoteDTO value, $Res Function(CryptoQuoteDTO) _then) = _$CryptoQuoteDTOCopyWithImpl;
@useResult
$Res call({
 String? symbol, String? priceChange, String? priceChangePercent, String? weightedAvgPrice, String? prevClosePrice, String? lastPrice, String? lastQty, String? bidPrice, String? bidQty, String? askPrice, String? askQty, String? openPrice, String? highPrice, String? lowPrice, String? volume, String? quoteVolume, int? openTime, int? closeTime, int? firstId, int? lastId, int? count
});




}
/// @nodoc
class _$CryptoQuoteDTOCopyWithImpl<$Res>
    implements $CryptoQuoteDTOCopyWith<$Res> {
  _$CryptoQuoteDTOCopyWithImpl(this._self, this._then);

  final CryptoQuoteDTO _self;
  final $Res Function(CryptoQuoteDTO) _then;

/// Create a copy of CryptoQuoteDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = freezed,Object? priceChange = freezed,Object? priceChangePercent = freezed,Object? weightedAvgPrice = freezed,Object? prevClosePrice = freezed,Object? lastPrice = freezed,Object? lastQty = freezed,Object? bidPrice = freezed,Object? bidQty = freezed,Object? askPrice = freezed,Object? askQty = freezed,Object? openPrice = freezed,Object? highPrice = freezed,Object? lowPrice = freezed,Object? volume = freezed,Object? quoteVolume = freezed,Object? openTime = freezed,Object? closeTime = freezed,Object? firstId = freezed,Object? lastId = freezed,Object? count = freezed,}) {
  return _then(_self.copyWith(
symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,priceChange: freezed == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as String?,priceChangePercent: freezed == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as String?,weightedAvgPrice: freezed == weightedAvgPrice ? _self.weightedAvgPrice : weightedAvgPrice // ignore: cast_nullable_to_non_nullable
as String?,prevClosePrice: freezed == prevClosePrice ? _self.prevClosePrice : prevClosePrice // ignore: cast_nullable_to_non_nullable
as String?,lastPrice: freezed == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as String?,lastQty: freezed == lastQty ? _self.lastQty : lastQty // ignore: cast_nullable_to_non_nullable
as String?,bidPrice: freezed == bidPrice ? _self.bidPrice : bidPrice // ignore: cast_nullable_to_non_nullable
as String?,bidQty: freezed == bidQty ? _self.bidQty : bidQty // ignore: cast_nullable_to_non_nullable
as String?,askPrice: freezed == askPrice ? _self.askPrice : askPrice // ignore: cast_nullable_to_non_nullable
as String?,askQty: freezed == askQty ? _self.askQty : askQty // ignore: cast_nullable_to_non_nullable
as String?,openPrice: freezed == openPrice ? _self.openPrice : openPrice // ignore: cast_nullable_to_non_nullable
as String?,highPrice: freezed == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as String?,lowPrice: freezed == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as String?,volume: freezed == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String?,quoteVolume: freezed == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as String?,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int?,firstId: freezed == firstId ? _self.firstId : firstId // ignore: cast_nullable_to_non_nullable
as int?,lastId: freezed == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CryptoQuoteDTO].
extension CryptoQuoteDTOPatterns on CryptoQuoteDTO {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CryptoQuoteDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CryptoQuoteDTO() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CryptoQuoteDTO value)  $default,){
final _that = this;
switch (_that) {
case _CryptoQuoteDTO():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CryptoQuoteDTO value)?  $default,){
final _that = this;
switch (_that) {
case _CryptoQuoteDTO() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? symbol,  String? priceChange,  String? priceChangePercent,  String? weightedAvgPrice,  String? prevClosePrice,  String? lastPrice,  String? lastQty,  String? bidPrice,  String? bidQty,  String? askPrice,  String? askQty,  String? openPrice,  String? highPrice,  String? lowPrice,  String? volume,  String? quoteVolume,  int? openTime,  int? closeTime,  int? firstId,  int? lastId,  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CryptoQuoteDTO() when $default != null:
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? symbol,  String? priceChange,  String? priceChangePercent,  String? weightedAvgPrice,  String? prevClosePrice,  String? lastPrice,  String? lastQty,  String? bidPrice,  String? bidQty,  String? askPrice,  String? askQty,  String? openPrice,  String? highPrice,  String? lowPrice,  String? volume,  String? quoteVolume,  int? openTime,  int? closeTime,  int? firstId,  int? lastId,  int? count)  $default,) {final _that = this;
switch (_that) {
case _CryptoQuoteDTO():
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? symbol,  String? priceChange,  String? priceChangePercent,  String? weightedAvgPrice,  String? prevClosePrice,  String? lastPrice,  String? lastQty,  String? bidPrice,  String? bidQty,  String? askPrice,  String? askQty,  String? openPrice,  String? highPrice,  String? lowPrice,  String? volume,  String? quoteVolume,  int? openTime,  int? closeTime,  int? firstId,  int? lastId,  int? count)?  $default,) {final _that = this;
switch (_that) {
case _CryptoQuoteDTO() when $default != null:
return $default(_that.symbol,_that.priceChange,_that.priceChangePercent,_that.weightedAvgPrice,_that.prevClosePrice,_that.lastPrice,_that.lastQty,_that.bidPrice,_that.bidQty,_that.askPrice,_that.askQty,_that.openPrice,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume,_that.openTime,_that.closeTime,_that.firstId,_that.lastId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CryptoQuoteDTO implements CryptoQuoteDTO {
  const _CryptoQuoteDTO({required this.symbol, required this.priceChange, required this.priceChangePercent, required this.weightedAvgPrice, required this.prevClosePrice, required this.lastPrice, required this.lastQty, required this.bidPrice, required this.bidQty, required this.askPrice, required this.askQty, required this.openPrice, required this.highPrice, required this.lowPrice, required this.volume, required this.quoteVolume, required this.openTime, required this.closeTime, required this.firstId, required this.lastId, required this.count});
  factory _CryptoQuoteDTO.fromJson(Map<String, dynamic> json) => _$CryptoQuoteDTOFromJson(json);

/// The symbol of the cryptocurrency pair (e.g., "BTCUSDT").
@override final  String? symbol;
/// The price change over the last 24 hours.
@override final  String? priceChange;
/// The percentage price change over the last 24 hours.
@override final  String? priceChangePercent;
/// The weighted average price over the last 24 hours.
@override final  String? weightedAvgPrice;
/// The previous closing price.
@override final  String? prevClosePrice;
/// The current price.
@override final  String? lastPrice;
/// The quantity of the last trade.
@override final  String? lastQty;
/// The highest bid price.
@override final  String? bidPrice;
/// The quantity of the highest bid.
@override final  String? bidQty;
/// The lowest ask price.
@override final  String? askPrice;
/// The quantity of the lowest ask.
@override final  String? askQty;
/// The opening price 24 hours ago.
@override final  String? openPrice;
/// The highest price over the last 24 hours.
@override final  String? highPrice;
/// The lowest price over the last 24 hours.
@override final  String? lowPrice;
/// The total traded base asset volume over the last 24 hours.
@override final  String? volume;
/// The total traded quote asset volume over the last 24 hours.
@override final  String? quoteVolume;
/// The open time of the 24-hour period.
@override final  int? openTime;
/// The close time of the 24-hour period.
@override final  int? closeTime;
/// The first trade ID in the 24-hour period.
@override final  int? firstId;
/// The last trade ID in the 24-hour period.
@override final  int? lastId;
/// The total number of trades over the last 24 hours.
@override final  int? count;

/// Create a copy of CryptoQuoteDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CryptoQuoteDTOCopyWith<_CryptoQuoteDTO> get copyWith => __$CryptoQuoteDTOCopyWithImpl<_CryptoQuoteDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CryptoQuoteDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CryptoQuoteDTO&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePercent, priceChangePercent) || other.priceChangePercent == priceChangePercent)&&(identical(other.weightedAvgPrice, weightedAvgPrice) || other.weightedAvgPrice == weightedAvgPrice)&&(identical(other.prevClosePrice, prevClosePrice) || other.prevClosePrice == prevClosePrice)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.lastQty, lastQty) || other.lastQty == lastQty)&&(identical(other.bidPrice, bidPrice) || other.bidPrice == bidPrice)&&(identical(other.bidQty, bidQty) || other.bidQty == bidQty)&&(identical(other.askPrice, askPrice) || other.askPrice == askPrice)&&(identical(other.askQty, askQty) || other.askQty == askQty)&&(identical(other.openPrice, openPrice) || other.openPrice == openPrice)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.firstId, firstId) || other.firstId == firstId)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,symbol,priceChange,priceChangePercent,weightedAvgPrice,prevClosePrice,lastPrice,lastQty,bidPrice,bidQty,askPrice,askQty,openPrice,highPrice,lowPrice,volume,quoteVolume,openTime,closeTime,firstId,lastId,count]);

@override
String toString() {
  return 'CryptoQuoteDTO(symbol: $symbol, priceChange: $priceChange, priceChangePercent: $priceChangePercent, weightedAvgPrice: $weightedAvgPrice, prevClosePrice: $prevClosePrice, lastPrice: $lastPrice, lastQty: $lastQty, bidPrice: $bidPrice, bidQty: $bidQty, askPrice: $askPrice, askQty: $askQty, openPrice: $openPrice, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume, openTime: $openTime, closeTime: $closeTime, firstId: $firstId, lastId: $lastId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CryptoQuoteDTOCopyWith<$Res> implements $CryptoQuoteDTOCopyWith<$Res> {
  factory _$CryptoQuoteDTOCopyWith(_CryptoQuoteDTO value, $Res Function(_CryptoQuoteDTO) _then) = __$CryptoQuoteDTOCopyWithImpl;
@override @useResult
$Res call({
 String? symbol, String? priceChange, String? priceChangePercent, String? weightedAvgPrice, String? prevClosePrice, String? lastPrice, String? lastQty, String? bidPrice, String? bidQty, String? askPrice, String? askQty, String? openPrice, String? highPrice, String? lowPrice, String? volume, String? quoteVolume, int? openTime, int? closeTime, int? firstId, int? lastId, int? count
});




}
/// @nodoc
class __$CryptoQuoteDTOCopyWithImpl<$Res>
    implements _$CryptoQuoteDTOCopyWith<$Res> {
  __$CryptoQuoteDTOCopyWithImpl(this._self, this._then);

  final _CryptoQuoteDTO _self;
  final $Res Function(_CryptoQuoteDTO) _then;

/// Create a copy of CryptoQuoteDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = freezed,Object? priceChange = freezed,Object? priceChangePercent = freezed,Object? weightedAvgPrice = freezed,Object? prevClosePrice = freezed,Object? lastPrice = freezed,Object? lastQty = freezed,Object? bidPrice = freezed,Object? bidQty = freezed,Object? askPrice = freezed,Object? askQty = freezed,Object? openPrice = freezed,Object? highPrice = freezed,Object? lowPrice = freezed,Object? volume = freezed,Object? quoteVolume = freezed,Object? openTime = freezed,Object? closeTime = freezed,Object? firstId = freezed,Object? lastId = freezed,Object? count = freezed,}) {
  return _then(_CryptoQuoteDTO(
symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,priceChange: freezed == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as String?,priceChangePercent: freezed == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as String?,weightedAvgPrice: freezed == weightedAvgPrice ? _self.weightedAvgPrice : weightedAvgPrice // ignore: cast_nullable_to_non_nullable
as String?,prevClosePrice: freezed == prevClosePrice ? _self.prevClosePrice : prevClosePrice // ignore: cast_nullable_to_non_nullable
as String?,lastPrice: freezed == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as String?,lastQty: freezed == lastQty ? _self.lastQty : lastQty // ignore: cast_nullable_to_non_nullable
as String?,bidPrice: freezed == bidPrice ? _self.bidPrice : bidPrice // ignore: cast_nullable_to_non_nullable
as String?,bidQty: freezed == bidQty ? _self.bidQty : bidQty // ignore: cast_nullable_to_non_nullable
as String?,askPrice: freezed == askPrice ? _self.askPrice : askPrice // ignore: cast_nullable_to_non_nullable
as String?,askQty: freezed == askQty ? _self.askQty : askQty // ignore: cast_nullable_to_non_nullable
as String?,openPrice: freezed == openPrice ? _self.openPrice : openPrice // ignore: cast_nullable_to_non_nullable
as String?,highPrice: freezed == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as String?,lowPrice: freezed == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as String?,volume: freezed == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String?,quoteVolume: freezed == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as String?,openTime: freezed == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int?,closeTime: freezed == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int?,firstId: freezed == firstId ? _self.firstId : firstId // ignore: cast_nullable_to_non_nullable
as int?,lastId: freezed == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
