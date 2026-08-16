// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto_quote_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CryptoQuoteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CryptoQuoteState()';
}


}

/// @nodoc
class $CryptoQuoteStateCopyWith<$Res>  {
$CryptoQuoteStateCopyWith(CryptoQuoteState _, $Res Function(CryptoQuoteState) __);
}


/// Adds pattern-matching-related methods to [CryptoQuoteState].
extension CryptoQuoteStatePatterns on CryptoQuoteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CryptoQuoteStateInitial value)?  initial,TResult Function( CryptoQuoteStateLoading value)?  loading,TResult Function( CryptoQuoteStateSuccess value)?  success,TResult Function( CryptoQuoteStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CryptoQuoteStateInitial() when initial != null:
return initial(_that);case CryptoQuoteStateLoading() when loading != null:
return loading(_that);case CryptoQuoteStateSuccess() when success != null:
return success(_that);case CryptoQuoteStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CryptoQuoteStateInitial value)  initial,required TResult Function( CryptoQuoteStateLoading value)  loading,required TResult Function( CryptoQuoteStateSuccess value)  success,required TResult Function( CryptoQuoteStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case CryptoQuoteStateInitial():
return initial(_that);case CryptoQuoteStateLoading():
return loading(_that);case CryptoQuoteStateSuccess():
return success(_that);case CryptoQuoteStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CryptoQuoteStateInitial value)?  initial,TResult? Function( CryptoQuoteStateLoading value)?  loading,TResult? Function( CryptoQuoteStateSuccess value)?  success,TResult? Function( CryptoQuoteStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CryptoQuoteStateInitial() when initial != null:
return initial(_that);case CryptoQuoteStateLoading() when loading != null:
return loading(_that);case CryptoQuoteStateSuccess() when success != null:
return success(_that);case CryptoQuoteStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CryptoQuoteEntity> quotes)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CryptoQuoteStateInitial() when initial != null:
return initial();case CryptoQuoteStateLoading() when loading != null:
return loading();case CryptoQuoteStateSuccess() when success != null:
return success(_that.quotes);case CryptoQuoteStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CryptoQuoteEntity> quotes)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case CryptoQuoteStateInitial():
return initial();case CryptoQuoteStateLoading():
return loading();case CryptoQuoteStateSuccess():
return success(_that.quotes);case CryptoQuoteStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CryptoQuoteEntity> quotes)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case CryptoQuoteStateInitial() when initial != null:
return initial();case CryptoQuoteStateLoading() when loading != null:
return loading();case CryptoQuoteStateSuccess() when success != null:
return success(_that.quotes);case CryptoQuoteStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CryptoQuoteStateInitial implements CryptoQuoteState {
  const CryptoQuoteStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CryptoQuoteState.initial()';
}


}




/// @nodoc


class CryptoQuoteStateLoading implements CryptoQuoteState {
  const CryptoQuoteStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CryptoQuoteState.loading()';
}


}




/// @nodoc


class CryptoQuoteStateSuccess implements CryptoQuoteState {
  const CryptoQuoteStateSuccess(final  List<CryptoQuoteEntity> quotes): _quotes = quotes;
  

 final  List<CryptoQuoteEntity> _quotes;
 List<CryptoQuoteEntity> get quotes {
  if (_quotes is EqualUnmodifiableListView) return _quotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quotes);
}


/// Create a copy of CryptoQuoteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoQuoteStateSuccessCopyWith<CryptoQuoteStateSuccess> get copyWith => _$CryptoQuoteStateSuccessCopyWithImpl<CryptoQuoteStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteStateSuccess&&const DeepCollectionEquality().equals(other._quotes, _quotes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_quotes));

@override
String toString() {
  return 'CryptoQuoteState.success(quotes: $quotes)';
}


}

/// @nodoc
abstract mixin class $CryptoQuoteStateSuccessCopyWith<$Res> implements $CryptoQuoteStateCopyWith<$Res> {
  factory $CryptoQuoteStateSuccessCopyWith(CryptoQuoteStateSuccess value, $Res Function(CryptoQuoteStateSuccess) _then) = _$CryptoQuoteStateSuccessCopyWithImpl;
@useResult
$Res call({
 List<CryptoQuoteEntity> quotes
});




}
/// @nodoc
class _$CryptoQuoteStateSuccessCopyWithImpl<$Res>
    implements $CryptoQuoteStateSuccessCopyWith<$Res> {
  _$CryptoQuoteStateSuccessCopyWithImpl(this._self, this._then);

  final CryptoQuoteStateSuccess _self;
  final $Res Function(CryptoQuoteStateSuccess) _then;

/// Create a copy of CryptoQuoteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? quotes = null,}) {
  return _then(CryptoQuoteStateSuccess(
null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<CryptoQuoteEntity>,
  ));
}


}

/// @nodoc


class CryptoQuoteStateFailure implements CryptoQuoteState {
  const CryptoQuoteStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of CryptoQuoteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoQuoteStateFailureCopyWith<CryptoQuoteStateFailure> get copyWith => _$CryptoQuoteStateFailureCopyWithImpl<CryptoQuoteStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuoteStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CryptoQuoteState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CryptoQuoteStateFailureCopyWith<$Res> implements $CryptoQuoteStateCopyWith<$Res> {
  factory $CryptoQuoteStateFailureCopyWith(CryptoQuoteStateFailure value, $Res Function(CryptoQuoteStateFailure) _then) = _$CryptoQuoteStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CryptoQuoteStateFailureCopyWithImpl<$Res>
    implements $CryptoQuoteStateFailureCopyWith<$Res> {
  _$CryptoQuoteStateFailureCopyWithImpl(this._self, this._then);

  final CryptoQuoteStateFailure _self;
  final $Res Function(CryptoQuoteStateFailure) _then;

/// Create a copy of CryptoQuoteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CryptoQuoteStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of CryptoQuoteState
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
