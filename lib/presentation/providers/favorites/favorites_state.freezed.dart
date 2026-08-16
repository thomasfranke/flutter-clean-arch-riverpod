// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState()';
}


}

/// @nodoc
class $FavoritesStateCopyWith<$Res>  {
$FavoritesStateCopyWith(FavoritesState _, $Res Function(FavoritesState) __);
}


/// Adds pattern-matching-related methods to [FavoritesState].
extension FavoritesStatePatterns on FavoritesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FavoritesStateInitial value)?  initial,TResult Function( FavoritesStateLoading value)?  loading,TResult Function( FavoritesStateSuccess value)?  success,TResult Function( FavoritesStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FavoritesStateInitial() when initial != null:
return initial(_that);case FavoritesStateLoading() when loading != null:
return loading(_that);case FavoritesStateSuccess() when success != null:
return success(_that);case FavoritesStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FavoritesStateInitial value)  initial,required TResult Function( FavoritesStateLoading value)  loading,required TResult Function( FavoritesStateSuccess value)  success,required TResult Function( FavoritesStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case FavoritesStateInitial():
return initial(_that);case FavoritesStateLoading():
return loading(_that);case FavoritesStateSuccess():
return success(_that);case FavoritesStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FavoritesStateInitial value)?  initial,TResult? Function( FavoritesStateLoading value)?  loading,TResult? Function( FavoritesStateSuccess value)?  success,TResult? Function( FavoritesStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case FavoritesStateInitial() when initial != null:
return initial(_that);case FavoritesStateLoading() when loading != null:
return loading(_that);case FavoritesStateSuccess() when success != null:
return success(_that);case FavoritesStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<FavoriteEntity> favorites)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FavoritesStateInitial() when initial != null:
return initial();case FavoritesStateLoading() when loading != null:
return loading();case FavoritesStateSuccess() when success != null:
return success(_that.favorites);case FavoritesStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<FavoriteEntity> favorites)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case FavoritesStateInitial():
return initial();case FavoritesStateLoading():
return loading();case FavoritesStateSuccess():
return success(_that.favorites);case FavoritesStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<FavoriteEntity> favorites)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case FavoritesStateInitial() when initial != null:
return initial();case FavoritesStateLoading() when loading != null:
return loading();case FavoritesStateSuccess() when success != null:
return success(_that.favorites);case FavoritesStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FavoritesStateInitial implements FavoritesState {
  const FavoritesStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState.initial()';
}


}




/// @nodoc


class FavoritesStateLoading implements FavoritesState {
  const FavoritesStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesState.loading()';
}


}




/// @nodoc


class FavoritesStateSuccess implements FavoritesState {
  const FavoritesStateSuccess(final  List<FavoriteEntity> favorites): _favorites = favorites;
  

 final  List<FavoriteEntity> _favorites;
 List<FavoriteEntity> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}


/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesStateSuccessCopyWith<FavoritesStateSuccess> get copyWith => _$FavoritesStateSuccessCopyWithImpl<FavoritesStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesStateSuccess&&const DeepCollectionEquality().equals(other._favorites, _favorites));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_favorites));

@override
String toString() {
  return 'FavoritesState.success(favorites: $favorites)';
}


}

/// @nodoc
abstract mixin class $FavoritesStateSuccessCopyWith<$Res> implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateSuccessCopyWith(FavoritesStateSuccess value, $Res Function(FavoritesStateSuccess) _then) = _$FavoritesStateSuccessCopyWithImpl;
@useResult
$Res call({
 List<FavoriteEntity> favorites
});




}
/// @nodoc
class _$FavoritesStateSuccessCopyWithImpl<$Res>
    implements $FavoritesStateSuccessCopyWith<$Res> {
  _$FavoritesStateSuccessCopyWithImpl(this._self, this._then);

  final FavoritesStateSuccess _self;
  final $Res Function(FavoritesStateSuccess) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? favorites = null,}) {
  return _then(FavoritesStateSuccess(
null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<FavoriteEntity>,
  ));
}


}

/// @nodoc


class FavoritesStateFailure implements FavoritesState {
  const FavoritesStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesStateFailureCopyWith<FavoritesStateFailure> get copyWith => _$FavoritesStateFailureCopyWithImpl<FavoritesStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FavoritesState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FavoritesStateFailureCopyWith<$Res> implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateFailureCopyWith(FavoritesStateFailure value, $Res Function(FavoritesStateFailure) _then) = _$FavoritesStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FavoritesStateFailureCopyWithImpl<$Res>
    implements $FavoritesStateFailureCopyWith<$Res> {
  _$FavoritesStateFailureCopyWithImpl(this._self, this._then);

  final FavoritesStateFailure _self;
  final $Res Function(FavoritesStateFailure) _then;

/// Create a copy of FavoritesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FavoritesStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FavoritesState
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
