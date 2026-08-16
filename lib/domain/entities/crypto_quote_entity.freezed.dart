// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto_quote_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CryptoQuoteEntity {

 String get symbol; double get lastPrice; double get priceChange; double get priceChangePct; double get highPrice; double get lowPrice; double get volume; double get quoteVolume;
/// Create a copy of CryptoQuoteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoQuoteEntityCopyWith<CryptoQuoteEntity> get copyWith => _$CryptoQuoteEntityCopyWithImpl<CryptoQuoteEntity>(this as CryptoQuoteEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteEntity&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePct, priceChangePct) || other.priceChangePct == priceChangePct)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume));
}


@override
int get hashCode => Object.hash(runtimeType,symbol,lastPrice,priceChange,priceChangePct,highPrice,lowPrice,volume,quoteVolume);

@override
String toString() {
  return 'CryptoQuoteEntity(symbol: $symbol, lastPrice: $lastPrice, priceChange: $priceChange, priceChangePct: $priceChangePct, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume)';
}


}

/// @nodoc
abstract mixin class $CryptoQuoteEntityCopyWith<$Res>  {
  factory $CryptoQuoteEntityCopyWith(CryptoQuoteEntity value, $Res Function(CryptoQuoteEntity) _then) = _$CryptoQuoteEntityCopyWithImpl;
@useResult
$Res call({
 String symbol, double lastPrice, double priceChange, double priceChangePct, double highPrice, double lowPrice, double volume, double quoteVolume
});




}
/// @nodoc
class _$CryptoQuoteEntityCopyWithImpl<$Res>
    implements $CryptoQuoteEntityCopyWith<$Res> {
  _$CryptoQuoteEntityCopyWithImpl(this._self, this._then);

  final CryptoQuoteEntity _self;
  final $Res Function(CryptoQuoteEntity) _then;

/// Create a copy of CryptoQuoteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? lastPrice = null,Object? priceChange = null,Object? priceChangePct = null,Object? highPrice = null,Object? lowPrice = null,Object? volume = null,Object? quoteVolume = null,}) {
  return _then(_self.copyWith(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as double,priceChange: null == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as double,priceChangePct: null == priceChangePct ? _self.priceChangePct : priceChangePct // ignore: cast_nullable_to_non_nullable
as double,highPrice: null == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as double,lowPrice: null == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,quoteVolume: null == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CryptoQuoteEntity].
extension CryptoQuoteEntityPatterns on CryptoQuoteEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CryptoQuoteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CryptoQuoteEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CryptoQuoteEntity value)  $default,){
final _that = this;
switch (_that) {
case _CryptoQuoteEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CryptoQuoteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CryptoQuoteEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  double lastPrice,  double priceChange,  double priceChangePct,  double highPrice,  double lowPrice,  double volume,  double quoteVolume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CryptoQuoteEntity() when $default != null:
return $default(_that.symbol,_that.lastPrice,_that.priceChange,_that.priceChangePct,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  double lastPrice,  double priceChange,  double priceChangePct,  double highPrice,  double lowPrice,  double volume,  double quoteVolume)  $default,) {final _that = this;
switch (_that) {
case _CryptoQuoteEntity():
return $default(_that.symbol,_that.lastPrice,_that.priceChange,_that.priceChangePct,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  double lastPrice,  double priceChange,  double priceChangePct,  double highPrice,  double lowPrice,  double volume,  double quoteVolume)?  $default,) {final _that = this;
switch (_that) {
case _CryptoQuoteEntity() when $default != null:
return $default(_that.symbol,_that.lastPrice,_that.priceChange,_that.priceChangePct,_that.highPrice,_that.lowPrice,_that.volume,_that.quoteVolume);case _:
  return null;

}
}

}

/// @nodoc


class _CryptoQuoteEntity implements CryptoQuoteEntity {
  const _CryptoQuoteEntity({required this.symbol, required this.lastPrice, required this.priceChange, required this.priceChangePct, required this.highPrice, required this.lowPrice, required this.volume, required this.quoteVolume});
  

@override final  String symbol;
@override final  double lastPrice;
@override final  double priceChange;
@override final  double priceChangePct;
@override final  double highPrice;
@override final  double lowPrice;
@override final  double volume;
@override final  double quoteVolume;

/// Create a copy of CryptoQuoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CryptoQuoteEntityCopyWith<_CryptoQuoteEntity> get copyWith => __$CryptoQuoteEntityCopyWithImpl<_CryptoQuoteEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CryptoQuoteEntity&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.priceChange, priceChange) || other.priceChange == priceChange)&&(identical(other.priceChangePct, priceChangePct) || other.priceChangePct == priceChangePct)&&(identical(other.highPrice, highPrice) || other.highPrice == highPrice)&&(identical(other.lowPrice, lowPrice) || other.lowPrice == lowPrice)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.quoteVolume, quoteVolume) || other.quoteVolume == quoteVolume));
}


@override
int get hashCode => Object.hash(runtimeType,symbol,lastPrice,priceChange,priceChangePct,highPrice,lowPrice,volume,quoteVolume);

@override
String toString() {
  return 'CryptoQuoteEntity(symbol: $symbol, lastPrice: $lastPrice, priceChange: $priceChange, priceChangePct: $priceChangePct, highPrice: $highPrice, lowPrice: $lowPrice, volume: $volume, quoteVolume: $quoteVolume)';
}


}

/// @nodoc
abstract mixin class _$CryptoQuoteEntityCopyWith<$Res> implements $CryptoQuoteEntityCopyWith<$Res> {
  factory _$CryptoQuoteEntityCopyWith(_CryptoQuoteEntity value, $Res Function(_CryptoQuoteEntity) _then) = __$CryptoQuoteEntityCopyWithImpl;
@override @useResult
$Res call({
 String symbol, double lastPrice, double priceChange, double priceChangePct, double highPrice, double lowPrice, double volume, double quoteVolume
});




}
/// @nodoc
class __$CryptoQuoteEntityCopyWithImpl<$Res>
    implements _$CryptoQuoteEntityCopyWith<$Res> {
  __$CryptoQuoteEntityCopyWithImpl(this._self, this._then);

  final _CryptoQuoteEntity _self;
  final $Res Function(_CryptoQuoteEntity) _then;

/// Create a copy of CryptoQuoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? lastPrice = null,Object? priceChange = null,Object? priceChangePct = null,Object? highPrice = null,Object? lowPrice = null,Object? volume = null,Object? quoteVolume = null,}) {
  return _then(_CryptoQuoteEntity(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as double,priceChange: null == priceChange ? _self.priceChange : priceChange // ignore: cast_nullable_to_non_nullable
as double,priceChangePct: null == priceChangePct ? _self.priceChangePct : priceChangePct // ignore: cast_nullable_to_non_nullable
as double,highPrice: null == highPrice ? _self.highPrice : highPrice // ignore: cast_nullable_to_non_nullable
as double,lowPrice: null == lowPrice ? _self.lowPrice : lowPrice // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,quoteVolume: null == quoteVolume ? _self.quoteVolume : quoteVolume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
