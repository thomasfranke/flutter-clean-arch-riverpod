// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiRoute {

/// Endpoint path relative to the API base URL.
 String get path;/// HTTP method used by this route.
 HttpMethod get method;
/// Create a copy of ApiRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiRouteCopyWith<ApiRoute> get copyWith => _$ApiRouteCopyWithImpl<ApiRoute>(this as ApiRoute, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiRoute&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,path,method);

@override
String toString() {
  return 'ApiRoute(path: $path, method: $method)';
}


}

/// @nodoc
abstract mixin class $ApiRouteCopyWith<$Res>  {
  factory $ApiRouteCopyWith(ApiRoute value, $Res Function(ApiRoute) _then) = _$ApiRouteCopyWithImpl;
@useResult
$Res call({
 String path, HttpMethod method
});




}
/// @nodoc
class _$ApiRouteCopyWithImpl<$Res>
    implements $ApiRouteCopyWith<$Res> {
  _$ApiRouteCopyWithImpl(this._self, this._then);

  final ApiRoute _self;
  final $Res Function(ApiRoute) _then;

/// Create a copy of ApiRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? method = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HttpMethod,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiRoute].
extension ApiRoutePatterns on ApiRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiRoute value)  $default,){
final _that = this;
switch (_that) {
case _ApiRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiRoute value)?  $default,){
final _that = this;
switch (_that) {
case _ApiRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  HttpMethod method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiRoute() when $default != null:
return $default(_that.path,_that.method);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  HttpMethod method)  $default,) {final _that = this;
switch (_that) {
case _ApiRoute():
return $default(_that.path,_that.method);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  HttpMethod method)?  $default,) {final _that = this;
switch (_that) {
case _ApiRoute() when $default != null:
return $default(_that.path,_that.method);case _:
  return null;

}
}

}

/// @nodoc


class _ApiRoute implements ApiRoute {
  const _ApiRoute(this.path, this.method);
  

/// Endpoint path relative to the API base URL.
@override final  String path;
/// HTTP method used by this route.
@override final  HttpMethod method;

/// Create a copy of ApiRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiRouteCopyWith<_ApiRoute> get copyWith => __$ApiRouteCopyWithImpl<_ApiRoute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiRoute&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,path,method);

@override
String toString() {
  return 'ApiRoute(path: $path, method: $method)';
}


}

/// @nodoc
abstract mixin class _$ApiRouteCopyWith<$Res> implements $ApiRouteCopyWith<$Res> {
  factory _$ApiRouteCopyWith(_ApiRoute value, $Res Function(_ApiRoute) _then) = __$ApiRouteCopyWithImpl;
@override @useResult
$Res call({
 String path, HttpMethod method
});




}
/// @nodoc
class __$ApiRouteCopyWithImpl<$Res>
    implements _$ApiRouteCopyWith<$Res> {
  __$ApiRouteCopyWithImpl(this._self, this._then);

  final _ApiRoute _self;
  final $Res Function(_ApiRoute) _then;

/// Create a copy of ApiRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? method = null,}) {
  return _then(_ApiRoute(
null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HttpMethod,
  ));
}


}

// dart format on
