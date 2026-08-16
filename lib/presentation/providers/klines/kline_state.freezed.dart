// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KlineState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlineState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KlineState()';
}


}

/// @nodoc
class $KlineStateCopyWith<$Res>  {
$KlineStateCopyWith(KlineState _, $Res Function(KlineState) __);
}


/// Adds pattern-matching-related methods to [KlineState].
extension KlineStatePatterns on KlineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( KlineStateInitial value)?  initial,TResult Function( KlineStateLoading value)?  loading,TResult Function( KlineStateSuccess value)?  success,TResult Function( KlineStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case KlineStateInitial() when initial != null:
return initial(_that);case KlineStateLoading() when loading != null:
return loading(_that);case KlineStateSuccess() when success != null:
return success(_that);case KlineStateFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( KlineStateInitial value)  initial,required TResult Function( KlineStateLoading value)  loading,required TResult Function( KlineStateSuccess value)  success,required TResult Function( KlineStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case KlineStateInitial():
return initial(_that);case KlineStateLoading():
return loading(_that);case KlineStateSuccess():
return success(_that);case KlineStateFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( KlineStateInitial value)?  initial,TResult? Function( KlineStateLoading value)?  loading,TResult? Function( KlineStateSuccess value)?  success,TResult? Function( KlineStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case KlineStateInitial() when initial != null:
return initial(_that);case KlineStateLoading() when loading != null:
return loading(_that);case KlineStateSuccess() when success != null:
return success(_that);case KlineStateFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Kline> klines)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case KlineStateInitial() when initial != null:
return initial();case KlineStateLoading() when loading != null:
return loading();case KlineStateSuccess() when success != null:
return success(_that.klines);case KlineStateFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Kline> klines)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case KlineStateInitial():
return initial();case KlineStateLoading():
return loading();case KlineStateSuccess():
return success(_that.klines);case KlineStateFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Kline> klines)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case KlineStateInitial() when initial != null:
return initial();case KlineStateLoading() when loading != null:
return loading();case KlineStateSuccess() when success != null:
return success(_that.klines);case KlineStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class KlineStateInitial implements KlineState {
  const KlineStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlineStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KlineState.initial()';
}


}




/// @nodoc


class KlineStateLoading implements KlineState {
  const KlineStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlineStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KlineState.loading()';
}


}




/// @nodoc


class KlineStateSuccess implements KlineState {
  const KlineStateSuccess(final  List<Kline> klines): _klines = klines;
  

 final  List<Kline> _klines;
 List<Kline> get klines {
  if (_klines is EqualUnmodifiableListView) return _klines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_klines);
}


/// Create a copy of KlineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KlineStateSuccessCopyWith<KlineStateSuccess> get copyWith => _$KlineStateSuccessCopyWithImpl<KlineStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlineStateSuccess&&const DeepCollectionEquality().equals(other._klines, _klines));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_klines));

@override
String toString() {
  return 'KlineState.success(klines: $klines)';
}


}

/// @nodoc
abstract mixin class $KlineStateSuccessCopyWith<$Res> implements $KlineStateCopyWith<$Res> {
  factory $KlineStateSuccessCopyWith(KlineStateSuccess value, $Res Function(KlineStateSuccess) _then) = _$KlineStateSuccessCopyWithImpl;
@useResult
$Res call({
 List<Kline> klines
});




}
/// @nodoc
class _$KlineStateSuccessCopyWithImpl<$Res>
    implements $KlineStateSuccessCopyWith<$Res> {
  _$KlineStateSuccessCopyWithImpl(this._self, this._then);

  final KlineStateSuccess _self;
  final $Res Function(KlineStateSuccess) _then;

/// Create a copy of KlineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? klines = null,}) {
  return _then(KlineStateSuccess(
null == klines ? _self._klines : klines // ignore: cast_nullable_to_non_nullable
as List<Kline>,
  ));
}


}

/// @nodoc


class KlineStateFailure implements KlineState {
  const KlineStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of KlineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KlineStateFailureCopyWith<KlineStateFailure> get copyWith => _$KlineStateFailureCopyWithImpl<KlineStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KlineStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'KlineState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $KlineStateFailureCopyWith<$Res> implements $KlineStateCopyWith<$Res> {
  factory $KlineStateFailureCopyWith(KlineStateFailure value, $Res Function(KlineStateFailure) _then) = _$KlineStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$KlineStateFailureCopyWithImpl<$Res>
    implements $KlineStateFailureCopyWith<$Res> {
  _$KlineStateFailureCopyWithImpl(this._self, this._then);

  final KlineStateFailure _self;
  final $Res Function(KlineStateFailure) _then;

/// Create a copy of KlineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(KlineStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of KlineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
