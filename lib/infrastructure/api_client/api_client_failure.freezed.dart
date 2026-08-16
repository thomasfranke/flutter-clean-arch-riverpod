// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_client_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiClientFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiClientFailure()';
}


}

/// @nodoc
class $ApiClientFailureCopyWith<$Res>  {
$ApiClientFailureCopyWith(ApiClientFailure _, $Res Function(ApiClientFailure) __);
}


/// Adds pattern-matching-related methods to [ApiClientFailure].
extension ApiClientFailurePatterns on ApiClientFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiClientNetworkFailure value)?  network,TResult Function( ApiClientClientFailure value)?  client,TResult Function( ApiClientServerFailure value)?  server,TResult Function( ApiClientUnknownFailure value)?  unknown,TResult Function( ApiClientParseFailure value)?  parse,TResult Function( ApiClientNotFoundFailure value)?  notFound,TResult Function( ApiClientCancelledFailure value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiClientNetworkFailure() when network != null:
return network(_that);case ApiClientClientFailure() when client != null:
return client(_that);case ApiClientServerFailure() when server != null:
return server(_that);case ApiClientUnknownFailure() when unknown != null:
return unknown(_that);case ApiClientParseFailure() when parse != null:
return parse(_that);case ApiClientNotFoundFailure() when notFound != null:
return notFound(_that);case ApiClientCancelledFailure() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiClientNetworkFailure value)  network,required TResult Function( ApiClientClientFailure value)  client,required TResult Function( ApiClientServerFailure value)  server,required TResult Function( ApiClientUnknownFailure value)  unknown,required TResult Function( ApiClientParseFailure value)  parse,required TResult Function( ApiClientNotFoundFailure value)  notFound,required TResult Function( ApiClientCancelledFailure value)  cancelled,}){
final _that = this;
switch (_that) {
case ApiClientNetworkFailure():
return network(_that);case ApiClientClientFailure():
return client(_that);case ApiClientServerFailure():
return server(_that);case ApiClientUnknownFailure():
return unknown(_that);case ApiClientParseFailure():
return parse(_that);case ApiClientNotFoundFailure():
return notFound(_that);case ApiClientCancelledFailure():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiClientNetworkFailure value)?  network,TResult? Function( ApiClientClientFailure value)?  client,TResult? Function( ApiClientServerFailure value)?  server,TResult? Function( ApiClientUnknownFailure value)?  unknown,TResult? Function( ApiClientParseFailure value)?  parse,TResult? Function( ApiClientNotFoundFailure value)?  notFound,TResult? Function( ApiClientCancelledFailure value)?  cancelled,}){
final _that = this;
switch (_that) {
case ApiClientNetworkFailure() when network != null:
return network(_that);case ApiClientClientFailure() when client != null:
return client(_that);case ApiClientServerFailure() when server != null:
return server(_that);case ApiClientUnknownFailure() when unknown != null:
return unknown(_that);case ApiClientParseFailure() when parse != null:
return parse(_that);case ApiClientNotFoundFailure() when notFound != null:
return notFound(_that);case ApiClientCancelledFailure() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  network,TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  client,TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  server,TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  unknown,TResult Function()?  parse,TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  notFound,TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiClientNetworkFailure() when network != null:
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientClientFailure() when client != null:
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientServerFailure() when server != null:
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientUnknownFailure() when unknown != null:
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientParseFailure() when parse != null:
return parse();case ApiClientNotFoundFailure() when notFound != null:
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientCancelledFailure() when cancelled != null:
return cancelled(_that.error,_that.errorMessage,_that.response,_that.statusCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  network,required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  client,required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  server,required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  unknown,required TResult Function()  parse,required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  notFound,required TResult Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)  cancelled,}) {final _that = this;
switch (_that) {
case ApiClientNetworkFailure():
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientClientFailure():
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientServerFailure():
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientUnknownFailure():
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientParseFailure():
return parse();case ApiClientNotFoundFailure():
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientCancelledFailure():
return cancelled(_that.error,_that.errorMessage,_that.response,_that.statusCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  network,TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  client,TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  server,TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  unknown,TResult? Function()?  parse,TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  notFound,TResult? Function( String? error,  String? errorMessage,  Response<dynamic>? response,  int? statusCode)?  cancelled,}) {final _that = this;
switch (_that) {
case ApiClientNetworkFailure() when network != null:
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientClientFailure() when client != null:
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientServerFailure() when server != null:
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientUnknownFailure() when unknown != null:
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientParseFailure() when parse != null:
return parse();case ApiClientNotFoundFailure() when notFound != null:
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case ApiClientCancelledFailure() when cancelled != null:
return cancelled(_that.error,_that.errorMessage,_that.response,_that.statusCode);case _:
  return null;

}
}

}

/// @nodoc


class ApiClientNetworkFailure implements ApiClientFailure {
  const ApiClientNetworkFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientNetworkFailureCopyWith<ApiClientNetworkFailure> get copyWith => _$ApiClientNetworkFailureCopyWithImpl<ApiClientNetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientNetworkFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.network(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientNetworkFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientNetworkFailureCopyWith(ApiClientNetworkFailure value, $Res Function(ApiClientNetworkFailure) _then) = _$ApiClientNetworkFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientNetworkFailureCopyWithImpl<$Res>
    implements $ApiClientNetworkFailureCopyWith<$Res> {
  _$ApiClientNetworkFailureCopyWithImpl(this._self, this._then);

  final ApiClientNetworkFailure _self;
  final $Res Function(ApiClientNetworkFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientNetworkFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ApiClientClientFailure implements ApiClientFailure {
  const ApiClientClientFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientClientFailureCopyWith<ApiClientClientFailure> get copyWith => _$ApiClientClientFailureCopyWithImpl<ApiClientClientFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientClientFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.client(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientClientFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientClientFailureCopyWith(ApiClientClientFailure value, $Res Function(ApiClientClientFailure) _then) = _$ApiClientClientFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientClientFailureCopyWithImpl<$Res>
    implements $ApiClientClientFailureCopyWith<$Res> {
  _$ApiClientClientFailureCopyWithImpl(this._self, this._then);

  final ApiClientClientFailure _self;
  final $Res Function(ApiClientClientFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientClientFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ApiClientServerFailure implements ApiClientFailure {
  const ApiClientServerFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientServerFailureCopyWith<ApiClientServerFailure> get copyWith => _$ApiClientServerFailureCopyWithImpl<ApiClientServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientServerFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.server(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientServerFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientServerFailureCopyWith(ApiClientServerFailure value, $Res Function(ApiClientServerFailure) _then) = _$ApiClientServerFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientServerFailureCopyWithImpl<$Res>
    implements $ApiClientServerFailureCopyWith<$Res> {
  _$ApiClientServerFailureCopyWithImpl(this._self, this._then);

  final ApiClientServerFailure _self;
  final $Res Function(ApiClientServerFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientServerFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ApiClientUnknownFailure implements ApiClientFailure {
  const ApiClientUnknownFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientUnknownFailureCopyWith<ApiClientUnknownFailure> get copyWith => _$ApiClientUnknownFailureCopyWithImpl<ApiClientUnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientUnknownFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.unknown(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientUnknownFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientUnknownFailureCopyWith(ApiClientUnknownFailure value, $Res Function(ApiClientUnknownFailure) _then) = _$ApiClientUnknownFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientUnknownFailureCopyWithImpl<$Res>
    implements $ApiClientUnknownFailureCopyWith<$Res> {
  _$ApiClientUnknownFailureCopyWithImpl(this._self, this._then);

  final ApiClientUnknownFailure _self;
  final $Res Function(ApiClientUnknownFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientUnknownFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ApiClientParseFailure implements ApiClientFailure {
  const ApiClientParseFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientParseFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiClientFailure.parse()';
}


}




/// @nodoc


class ApiClientNotFoundFailure implements ApiClientFailure {
  const ApiClientNotFoundFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientNotFoundFailureCopyWith<ApiClientNotFoundFailure> get copyWith => _$ApiClientNotFoundFailureCopyWithImpl<ApiClientNotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientNotFoundFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.notFound(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientNotFoundFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientNotFoundFailureCopyWith(ApiClientNotFoundFailure value, $Res Function(ApiClientNotFoundFailure) _then) = _$ApiClientNotFoundFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientNotFoundFailureCopyWithImpl<$Res>
    implements $ApiClientNotFoundFailureCopyWith<$Res> {
  _$ApiClientNotFoundFailureCopyWithImpl(this._self, this._then);

  final ApiClientNotFoundFailure _self;
  final $Res Function(ApiClientNotFoundFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientNotFoundFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class ApiClientCancelledFailure implements ApiClientFailure {
  const ApiClientCancelledFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiClientCancelledFailureCopyWith<ApiClientCancelledFailure> get copyWith => _$ApiClientCancelledFailureCopyWithImpl<ApiClientCancelledFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiClientCancelledFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'ApiClientFailure.cancelled(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiClientCancelledFailureCopyWith<$Res> implements $ApiClientFailureCopyWith<$Res> {
  factory $ApiClientCancelledFailureCopyWith(ApiClientCancelledFailure value, $Res Function(ApiClientCancelledFailure) _then) = _$ApiClientCancelledFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$ApiClientCancelledFailureCopyWithImpl<$Res>
    implements $ApiClientCancelledFailureCopyWith<$Res> {
  _$ApiClientCancelledFailureCopyWithImpl(this._self, this._then);

  final ApiClientCancelledFailure _self;
  final $Res Function(ApiClientCancelledFailure) _then;

/// Create a copy of ApiClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(ApiClientCancelledFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
