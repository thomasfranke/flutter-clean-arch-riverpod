// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_client_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HttpClientFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpClientFailure()';
}


}

/// @nodoc
class $HttpClientFailureCopyWith<$Res>  {
$HttpClientFailureCopyWith(HttpClientFailure _, $Res Function(HttpClientFailure) __);
}


/// Adds pattern-matching-related methods to [HttpClientFailure].
extension HttpClientFailurePatterns on HttpClientFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HttpClientNetworkFailure value)?  network,TResult Function( HttpClientClientFailure value)?  client,TResult Function( HttpClientServerFailure value)?  server,TResult Function( HttpClientUnknownFailure value)?  unknown,TResult Function( HttpClientParseFailure value)?  parse,TResult Function( HttpClientNotFoundFailure value)?  notFound,TResult Function( HttpClientCancelledFailure value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HttpClientNetworkFailure() when network != null:
return network(_that);case HttpClientClientFailure() when client != null:
return client(_that);case HttpClientServerFailure() when server != null:
return server(_that);case HttpClientUnknownFailure() when unknown != null:
return unknown(_that);case HttpClientParseFailure() when parse != null:
return parse(_that);case HttpClientNotFoundFailure() when notFound != null:
return notFound(_that);case HttpClientCancelledFailure() when cancelled != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HttpClientNetworkFailure value)  network,required TResult Function( HttpClientClientFailure value)  client,required TResult Function( HttpClientServerFailure value)  server,required TResult Function( HttpClientUnknownFailure value)  unknown,required TResult Function( HttpClientParseFailure value)  parse,required TResult Function( HttpClientNotFoundFailure value)  notFound,required TResult Function( HttpClientCancelledFailure value)  cancelled,}){
final _that = this;
switch (_that) {
case HttpClientNetworkFailure():
return network(_that);case HttpClientClientFailure():
return client(_that);case HttpClientServerFailure():
return server(_that);case HttpClientUnknownFailure():
return unknown(_that);case HttpClientParseFailure():
return parse(_that);case HttpClientNotFoundFailure():
return notFound(_that);case HttpClientCancelledFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HttpClientNetworkFailure value)?  network,TResult? Function( HttpClientClientFailure value)?  client,TResult? Function( HttpClientServerFailure value)?  server,TResult? Function( HttpClientUnknownFailure value)?  unknown,TResult? Function( HttpClientParseFailure value)?  parse,TResult? Function( HttpClientNotFoundFailure value)?  notFound,TResult? Function( HttpClientCancelledFailure value)?  cancelled,}){
final _that = this;
switch (_that) {
case HttpClientNetworkFailure() when network != null:
return network(_that);case HttpClientClientFailure() when client != null:
return client(_that);case HttpClientServerFailure() when server != null:
return server(_that);case HttpClientUnknownFailure() when unknown != null:
return unknown(_that);case HttpClientParseFailure() when parse != null:
return parse(_that);case HttpClientNotFoundFailure() when notFound != null:
return notFound(_that);case HttpClientCancelledFailure() when cancelled != null:
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
case HttpClientNetworkFailure() when network != null:
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientClientFailure() when client != null:
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientServerFailure() when server != null:
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientUnknownFailure() when unknown != null:
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientParseFailure() when parse != null:
return parse();case HttpClientNotFoundFailure() when notFound != null:
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientCancelledFailure() when cancelled != null:
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
case HttpClientNetworkFailure():
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientClientFailure():
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientServerFailure():
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientUnknownFailure():
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientParseFailure():
return parse();case HttpClientNotFoundFailure():
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientCancelledFailure():
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
case HttpClientNetworkFailure() when network != null:
return network(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientClientFailure() when client != null:
return client(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientServerFailure() when server != null:
return server(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientUnknownFailure() when unknown != null:
return unknown(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientParseFailure() when parse != null:
return parse();case HttpClientNotFoundFailure() when notFound != null:
return notFound(_that.error,_that.errorMessage,_that.response,_that.statusCode);case HttpClientCancelledFailure() when cancelled != null:
return cancelled(_that.error,_that.errorMessage,_that.response,_that.statusCode);case _:
  return null;

}
}

}

/// @nodoc


class HttpClientNetworkFailure implements HttpClientFailure {
  const HttpClientNetworkFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientNetworkFailureCopyWith<HttpClientNetworkFailure> get copyWith => _$HttpClientNetworkFailureCopyWithImpl<HttpClientNetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientNetworkFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.network(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientNetworkFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientNetworkFailureCopyWith(HttpClientNetworkFailure value, $Res Function(HttpClientNetworkFailure) _then) = _$HttpClientNetworkFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientNetworkFailureCopyWithImpl<$Res>
    implements $HttpClientNetworkFailureCopyWith<$Res> {
  _$HttpClientNetworkFailureCopyWithImpl(this._self, this._then);

  final HttpClientNetworkFailure _self;
  final $Res Function(HttpClientNetworkFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientNetworkFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class HttpClientClientFailure implements HttpClientFailure {
  const HttpClientClientFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientClientFailureCopyWith<HttpClientClientFailure> get copyWith => _$HttpClientClientFailureCopyWithImpl<HttpClientClientFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientClientFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.client(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientClientFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientClientFailureCopyWith(HttpClientClientFailure value, $Res Function(HttpClientClientFailure) _then) = _$HttpClientClientFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientClientFailureCopyWithImpl<$Res>
    implements $HttpClientClientFailureCopyWith<$Res> {
  _$HttpClientClientFailureCopyWithImpl(this._self, this._then);

  final HttpClientClientFailure _self;
  final $Res Function(HttpClientClientFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientClientFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class HttpClientServerFailure implements HttpClientFailure {
  const HttpClientServerFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientServerFailureCopyWith<HttpClientServerFailure> get copyWith => _$HttpClientServerFailureCopyWithImpl<HttpClientServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientServerFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.server(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientServerFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientServerFailureCopyWith(HttpClientServerFailure value, $Res Function(HttpClientServerFailure) _then) = _$HttpClientServerFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientServerFailureCopyWithImpl<$Res>
    implements $HttpClientServerFailureCopyWith<$Res> {
  _$HttpClientServerFailureCopyWithImpl(this._self, this._then);

  final HttpClientServerFailure _self;
  final $Res Function(HttpClientServerFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientServerFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class HttpClientUnknownFailure implements HttpClientFailure {
  const HttpClientUnknownFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientUnknownFailureCopyWith<HttpClientUnknownFailure> get copyWith => _$HttpClientUnknownFailureCopyWithImpl<HttpClientUnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientUnknownFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.unknown(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientUnknownFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientUnknownFailureCopyWith(HttpClientUnknownFailure value, $Res Function(HttpClientUnknownFailure) _then) = _$HttpClientUnknownFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientUnknownFailureCopyWithImpl<$Res>
    implements $HttpClientUnknownFailureCopyWith<$Res> {
  _$HttpClientUnknownFailureCopyWithImpl(this._self, this._then);

  final HttpClientUnknownFailure _self;
  final $Res Function(HttpClientUnknownFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientUnknownFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class HttpClientParseFailure implements HttpClientFailure {
  const HttpClientParseFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientParseFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpClientFailure.parse()';
}


}




/// @nodoc


class HttpClientNotFoundFailure implements HttpClientFailure {
  const HttpClientNotFoundFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientNotFoundFailureCopyWith<HttpClientNotFoundFailure> get copyWith => _$HttpClientNotFoundFailureCopyWithImpl<HttpClientNotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientNotFoundFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.notFound(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientNotFoundFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientNotFoundFailureCopyWith(HttpClientNotFoundFailure value, $Res Function(HttpClientNotFoundFailure) _then) = _$HttpClientNotFoundFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientNotFoundFailureCopyWithImpl<$Res>
    implements $HttpClientNotFoundFailureCopyWith<$Res> {
  _$HttpClientNotFoundFailureCopyWithImpl(this._self, this._then);

  final HttpClientNotFoundFailure _self;
  final $Res Function(HttpClientNotFoundFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientNotFoundFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class HttpClientCancelledFailure implements HttpClientFailure {
  const HttpClientCancelledFailure({this.error, this.errorMessage, this.response, this.statusCode});
  

 final  String? error;
 final  String? errorMessage;
 final  Response<dynamic>? response;
 final  int? statusCode;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpClientCancelledFailureCopyWith<HttpClientCancelledFailure> get copyWith => _$HttpClientCancelledFailureCopyWithImpl<HttpClientCancelledFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpClientCancelledFailure&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.response, response) || other.response == response)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,error,errorMessage,response,statusCode);

@override
String toString() {
  return 'HttpClientFailure.cancelled(error: $error, errorMessage: $errorMessage, response: $response, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $HttpClientCancelledFailureCopyWith<$Res> implements $HttpClientFailureCopyWith<$Res> {
  factory $HttpClientCancelledFailureCopyWith(HttpClientCancelledFailure value, $Res Function(HttpClientCancelledFailure) _then) = _$HttpClientCancelledFailureCopyWithImpl;
@useResult
$Res call({
 String? error, String? errorMessage, Response<dynamic>? response, int? statusCode
});




}
/// @nodoc
class _$HttpClientCancelledFailureCopyWithImpl<$Res>
    implements $HttpClientCancelledFailureCopyWith<$Res> {
  _$HttpClientCancelledFailureCopyWithImpl(this._self, this._then);

  final HttpClientCancelledFailure _self;
  final $Res Function(HttpClientCancelledFailure) _then;

/// Create a copy of HttpClientFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? errorMessage = freezed,Object? response = freezed,Object? statusCode = freezed,}) {
  return _then(HttpClientCancelledFailure(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response<dynamic>?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
