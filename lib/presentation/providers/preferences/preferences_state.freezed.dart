// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreferencesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreferencesState()';
}


}

/// @nodoc
class $PreferencesStateCopyWith<$Res>  {
$PreferencesStateCopyWith(PreferencesState _, $Res Function(PreferencesState) __);
}


/// Adds pattern-matching-related methods to [PreferencesState].
extension PreferencesStatePatterns on PreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PreferencesStateInitial value)?  initial,TResult Function( PreferencesStateLoading value)?  loading,TResult Function( PreferencesStateSuccess value)?  success,TResult Function( PreferencesStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PreferencesStateInitial() when initial != null:
return initial(_that);case PreferencesStateLoading() when loading != null:
return loading(_that);case PreferencesStateSuccess() when success != null:
return success(_that);case PreferencesStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PreferencesStateInitial value)  initial,required TResult Function( PreferencesStateLoading value)  loading,required TResult Function( PreferencesStateSuccess value)  success,required TResult Function( PreferencesStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case PreferencesStateInitial():
return initial(_that);case PreferencesStateLoading():
return loading(_that);case PreferencesStateSuccess():
return success(_that);case PreferencesStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PreferencesStateInitial value)?  initial,TResult? Function( PreferencesStateLoading value)?  loading,TResult? Function( PreferencesStateSuccess value)?  success,TResult? Function( PreferencesStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PreferencesStateInitial() when initial != null:
return initial(_that);case PreferencesStateLoading() when loading != null:
return loading(_that);case PreferencesStateSuccess() when success != null:
return success(_that);case PreferencesStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PreferencesEntity preferences)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PreferencesStateInitial() when initial != null:
return initial();case PreferencesStateLoading() when loading != null:
return loading();case PreferencesStateSuccess() when success != null:
return success(_that.preferences);case PreferencesStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PreferencesEntity preferences)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PreferencesStateInitial():
return initial();case PreferencesStateLoading():
return loading();case PreferencesStateSuccess():
return success(_that.preferences);case PreferencesStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PreferencesEntity preferences)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PreferencesStateInitial() when initial != null:
return initial();case PreferencesStateLoading() when loading != null:
return loading();case PreferencesStateSuccess() when success != null:
return success(_that.preferences);case PreferencesStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PreferencesStateInitial implements PreferencesState {
  const PreferencesStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreferencesState.initial()';
}


}




/// @nodoc


class PreferencesStateLoading implements PreferencesState {
  const PreferencesStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreferencesState.loading()';
}


}




/// @nodoc


class PreferencesStateSuccess implements PreferencesState {
  const PreferencesStateSuccess(this.preferences);
  

 final  PreferencesEntity preferences;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesStateSuccessCopyWith<PreferencesStateSuccess> get copyWith => _$PreferencesStateSuccessCopyWithImpl<PreferencesStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesStateSuccess&&(identical(other.preferences, preferences) || other.preferences == preferences));
}


@override
int get hashCode => Object.hash(runtimeType,preferences);

@override
String toString() {
  return 'PreferencesState.success(preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $PreferencesStateSuccessCopyWith<$Res> implements $PreferencesStateCopyWith<$Res> {
  factory $PreferencesStateSuccessCopyWith(PreferencesStateSuccess value, $Res Function(PreferencesStateSuccess) _then) = _$PreferencesStateSuccessCopyWithImpl;
@useResult
$Res call({
 PreferencesEntity preferences
});


$PreferencesEntityCopyWith<$Res> get preferences;

}
/// @nodoc
class _$PreferencesStateSuccessCopyWithImpl<$Res>
    implements $PreferencesStateSuccessCopyWith<$Res> {
  _$PreferencesStateSuccessCopyWithImpl(this._self, this._then);

  final PreferencesStateSuccess _self;
  final $Res Function(PreferencesStateSuccess) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preferences = null,}) {
  return _then(PreferencesStateSuccess(
null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as PreferencesEntity,
  ));
}

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreferencesEntityCopyWith<$Res> get preferences {
  
  return $PreferencesEntityCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}

/// @nodoc


class PreferencesStateFailure implements PreferencesState {
  const PreferencesStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesStateFailureCopyWith<PreferencesStateFailure> get copyWith => _$PreferencesStateFailureCopyWithImpl<PreferencesStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PreferencesState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PreferencesStateFailureCopyWith<$Res> implements $PreferencesStateCopyWith<$Res> {
  factory $PreferencesStateFailureCopyWith(PreferencesStateFailure value, $Res Function(PreferencesStateFailure) _then) = _$PreferencesStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PreferencesStateFailureCopyWithImpl<$Res>
    implements $PreferencesStateFailureCopyWith<$Res> {
  _$PreferencesStateFailureCopyWithImpl(this._self, this._then);

  final PreferencesStateFailure _self;
  final $Res Function(PreferencesStateFailure) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PreferencesStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PreferencesState
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
