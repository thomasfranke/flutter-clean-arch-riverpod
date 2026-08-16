// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiClientDomainFailure value)?  apiClient,TResult Function( ApiClientNotFoundDomainFailure value)?  apiNotFound,TResult Function( ApiNetworkDomainFailure value)?  apiNetwork,TResult Function( ApiServerDomainFailure value)?  apiServer,TResult Function( ParseDomainFailure value)?  parse,TResult Function( SharedPreferencesDomainFailure value)?  storage,TResult Function( UnexpectedDomainFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiClientDomainFailure() when apiClient != null:
return apiClient(_that);case ApiClientNotFoundDomainFailure() when apiNotFound != null:
return apiNotFound(_that);case ApiNetworkDomainFailure() when apiNetwork != null:
return apiNetwork(_that);case ApiServerDomainFailure() when apiServer != null:
return apiServer(_that);case ParseDomainFailure() when parse != null:
return parse(_that);case SharedPreferencesDomainFailure() when storage != null:
return storage(_that);case UnexpectedDomainFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiClientDomainFailure value)  apiClient,required TResult Function( ApiClientNotFoundDomainFailure value)  apiNotFound,required TResult Function( ApiNetworkDomainFailure value)  apiNetwork,required TResult Function( ApiServerDomainFailure value)  apiServer,required TResult Function( ParseDomainFailure value)  parse,required TResult Function( SharedPreferencesDomainFailure value)  storage,required TResult Function( UnexpectedDomainFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case ApiClientDomainFailure():
return apiClient(_that);case ApiClientNotFoundDomainFailure():
return apiNotFound(_that);case ApiNetworkDomainFailure():
return apiNetwork(_that);case ApiServerDomainFailure():
return apiServer(_that);case ParseDomainFailure():
return parse(_that);case SharedPreferencesDomainFailure():
return storage(_that);case UnexpectedDomainFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiClientDomainFailure value)?  apiClient,TResult? Function( ApiClientNotFoundDomainFailure value)?  apiNotFound,TResult? Function( ApiNetworkDomainFailure value)?  apiNetwork,TResult? Function( ApiServerDomainFailure value)?  apiServer,TResult? Function( ParseDomainFailure value)?  parse,TResult? Function( SharedPreferencesDomainFailure value)?  storage,TResult? Function( UnexpectedDomainFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case ApiClientDomainFailure() when apiClient != null:
return apiClient(_that);case ApiClientNotFoundDomainFailure() when apiNotFound != null:
return apiNotFound(_that);case ApiNetworkDomainFailure() when apiNetwork != null:
return apiNetwork(_that);case ApiServerDomainFailure() when apiServer != null:
return apiServer(_that);case ParseDomainFailure() when parse != null:
return parse(_that);case SharedPreferencesDomainFailure() when storage != null:
return storage(_that);case UnexpectedDomainFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? e)?  apiClient,TResult Function( String? e)?  apiNotFound,TResult Function( String? e)?  apiNetwork,TResult Function( String? e)?  apiServer,TResult Function()?  parse,TResult Function()?  storage,TResult Function( String? e)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiClientDomainFailure() when apiClient != null:
return apiClient(_that.e);case ApiClientNotFoundDomainFailure() when apiNotFound != null:
return apiNotFound(_that.e);case ApiNetworkDomainFailure() when apiNetwork != null:
return apiNetwork(_that.e);case ApiServerDomainFailure() when apiServer != null:
return apiServer(_that.e);case ParseDomainFailure() when parse != null:
return parse();case SharedPreferencesDomainFailure() when storage != null:
return storage();case UnexpectedDomainFailure() when unexpected != null:
return unexpected(_that.e);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? e)  apiClient,required TResult Function( String? e)  apiNotFound,required TResult Function( String? e)  apiNetwork,required TResult Function( String? e)  apiServer,required TResult Function()  parse,required TResult Function()  storage,required TResult Function( String? e)  unexpected,}) {final _that = this;
switch (_that) {
case ApiClientDomainFailure():
return apiClient(_that.e);case ApiClientNotFoundDomainFailure():
return apiNotFound(_that.e);case ApiNetworkDomainFailure():
return apiNetwork(_that.e);case ApiServerDomainFailure():
return apiServer(_that.e);case ParseDomainFailure():
return parse();case SharedPreferencesDomainFailure():
return storage();case UnexpectedDomainFailure():
return unexpected(_that.e);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? e)?  apiClient,TResult? Function( String? e)?  apiNotFound,TResult? Function( String? e)?  apiNetwork,TResult? Function( String? e)?  apiServer,TResult? Function()?  parse,TResult? Function()?  storage,TResult? Function( String? e)?  unexpected,}) {final _that = this;
switch (_that) {
case ApiClientDomainFailure() when apiClient != null:
return apiClient(_that.e);case ApiClientNotFoundDomainFailure() when apiNotFound != null:
return apiNotFound(_that.e);case ApiNetworkDomainFailure() when apiNetwork != null:
return apiNetwork(_that.e);case ApiServerDomainFailure() when apiServer != null:
return apiServer(_that.e);case ParseDomainFailure() when parse != null:
return parse();case SharedPreferencesDomainFailure() when storage != null:
return storage();case UnexpectedDomainFailure() when unexpected != null:
return unexpected(_that.e);case _:
  return null;

}
}

}

/// @nodoc


class ApiClientDomainFailure implements Failure {
  const ApiClientDomainFailure([this.e]);
  

 final  String? e;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientDomainFailureCopyWith<ApiClientDomainFailure> get copyWith => _$ApiClientDomainFailureCopyWithImpl<ApiClientDomainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientDomainFailure&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'Failure.apiClient(e: $e)';
}


}

/// @nodoc
abstract mixin class $ApiClientDomainFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiClientDomainFailureCopyWith(ApiClientDomainFailure value, $Res Function(ApiClientDomainFailure) _then) = _$ApiClientDomainFailureCopyWithImpl;
@useResult
$Res call({
 String? e
});




}
/// @nodoc
class _$ApiClientDomainFailureCopyWithImpl<$Res>
    implements $ApiClientDomainFailureCopyWith<$Res> {
  _$ApiClientDomainFailureCopyWithImpl(this._self, this._then);

  final ApiClientDomainFailure _self;
  final $Res Function(ApiClientDomainFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = freezed,}) {
  return _then(ApiClientDomainFailure(
freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ApiClientNotFoundDomainFailure implements Failure {
  const ApiClientNotFoundDomainFailure([this.e]);
  

 final  String? e;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientNotFoundDomainFailureCopyWith<ApiClientNotFoundDomainFailure> get copyWith => _$ApiClientNotFoundDomainFailureCopyWithImpl<ApiClientNotFoundDomainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientNotFoundDomainFailure&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'Failure.apiNotFound(e: $e)';
}


}

/// @nodoc
abstract mixin class $ApiClientNotFoundDomainFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiClientNotFoundDomainFailureCopyWith(ApiClientNotFoundDomainFailure value, $Res Function(ApiClientNotFoundDomainFailure) _then) = _$ApiClientNotFoundDomainFailureCopyWithImpl;
@useResult
$Res call({
 String? e
});




}
/// @nodoc
class _$ApiClientNotFoundDomainFailureCopyWithImpl<$Res>
    implements $ApiClientNotFoundDomainFailureCopyWith<$Res> {
  _$ApiClientNotFoundDomainFailureCopyWithImpl(this._self, this._then);

  final ApiClientNotFoundDomainFailure _self;
  final $Res Function(ApiClientNotFoundDomainFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = freezed,}) {
  return _then(ApiClientNotFoundDomainFailure(
freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ApiNetworkDomainFailure implements Failure {
  const ApiNetworkDomainFailure([this.e]);
  

 final  String? e;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiNetworkDomainFailureCopyWith<ApiNetworkDomainFailure> get copyWith => _$ApiNetworkDomainFailureCopyWithImpl<ApiNetworkDomainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiNetworkDomainFailure&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'Failure.apiNetwork(e: $e)';
}


}

/// @nodoc
abstract mixin class $ApiNetworkDomainFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiNetworkDomainFailureCopyWith(ApiNetworkDomainFailure value, $Res Function(ApiNetworkDomainFailure) _then) = _$ApiNetworkDomainFailureCopyWithImpl;
@useResult
$Res call({
 String? e
});




}
/// @nodoc
class _$ApiNetworkDomainFailureCopyWithImpl<$Res>
    implements $ApiNetworkDomainFailureCopyWith<$Res> {
  _$ApiNetworkDomainFailureCopyWithImpl(this._self, this._then);

  final ApiNetworkDomainFailure _self;
  final $Res Function(ApiNetworkDomainFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = freezed,}) {
  return _then(ApiNetworkDomainFailure(
freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ApiServerDomainFailure implements Failure {
  const ApiServerDomainFailure([this.e]);
  

 final  String? e;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiServerDomainFailureCopyWith<ApiServerDomainFailure> get copyWith => _$ApiServerDomainFailureCopyWithImpl<ApiServerDomainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiServerDomainFailure&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'Failure.apiServer(e: $e)';
}


}

/// @nodoc
abstract mixin class $ApiServerDomainFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiServerDomainFailureCopyWith(ApiServerDomainFailure value, $Res Function(ApiServerDomainFailure) _then) = _$ApiServerDomainFailureCopyWithImpl;
@useResult
$Res call({
 String? e
});




}
/// @nodoc
class _$ApiServerDomainFailureCopyWithImpl<$Res>
    implements $ApiServerDomainFailureCopyWith<$Res> {
  _$ApiServerDomainFailureCopyWithImpl(this._self, this._then);

  final ApiServerDomainFailure _self;
  final $Res Function(ApiServerDomainFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = freezed,}) {
  return _then(ApiServerDomainFailure(
freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ParseDomainFailure implements Failure {
  const ParseDomainFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseDomainFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.parse()';
}


}




/// @nodoc


class SharedPreferencesDomainFailure implements Failure {
  const SharedPreferencesDomainFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedPreferencesDomainFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.storage()';
}


}




/// @nodoc


class UnexpectedDomainFailure implements Failure {
  const UnexpectedDomainFailure([this.e]);
  

 final  String? e;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedDomainFailureCopyWith<UnexpectedDomainFailure> get copyWith => _$UnexpectedDomainFailureCopyWithImpl<UnexpectedDomainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedDomainFailure&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'Failure.unexpected(e: $e)';
}


}

/// @nodoc
abstract mixin class $UnexpectedDomainFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnexpectedDomainFailureCopyWith(UnexpectedDomainFailure value, $Res Function(UnexpectedDomainFailure) _then) = _$UnexpectedDomainFailureCopyWithImpl;
@useResult
$Res call({
 String? e
});




}
/// @nodoc
class _$UnexpectedDomainFailureCopyWithImpl<$Res>
    implements $UnexpectedDomainFailureCopyWith<$Res> {
  _$UnexpectedDomainFailureCopyWithImpl(this._self, this._then);

  final UnexpectedDomainFailure _self;
  final $Res Function(UnexpectedDomainFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = freezed,}) {
  return _then(UnexpectedDomainFailure(
freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
