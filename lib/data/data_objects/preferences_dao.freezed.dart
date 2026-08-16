// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_dao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreferencesDAO {

 String? get locale; bool? get darkMode; double? get fontScale;
/// Create a copy of PreferencesDAO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesDAOCopyWith<PreferencesDAO> get copyWith => _$PreferencesDAOCopyWithImpl<PreferencesDAO>(this as PreferencesDAO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesDAO&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale));
}


@override
int get hashCode => Object.hash(runtimeType,locale,darkMode,fontScale);

@override
String toString() {
  return 'PreferencesDAO(locale: $locale, darkMode: $darkMode, fontScale: $fontScale)';
}


}

/// @nodoc
abstract mixin class $PreferencesDAOCopyWith<$Res>  {
  factory $PreferencesDAOCopyWith(PreferencesDAO value, $Res Function(PreferencesDAO) _then) = _$PreferencesDAOCopyWithImpl;
@useResult
$Res call({
 String? locale, bool? darkMode, double? fontScale
});




}
/// @nodoc
class _$PreferencesDAOCopyWithImpl<$Res>
    implements $PreferencesDAOCopyWith<$Res> {
  _$PreferencesDAOCopyWithImpl(this._self, this._then);

  final PreferencesDAO _self;
  final $Res Function(PreferencesDAO) _then;

/// Create a copy of PreferencesDAO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = freezed,Object? darkMode = freezed,Object? fontScale = freezed,}) {
  return _then(_self.copyWith(
locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,darkMode: freezed == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool?,fontScale: freezed == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesDAO].
extension PreferencesDAOPatterns on PreferencesDAO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesDAO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesDAO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesDAO value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesDAO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesDAO value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesDAO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? locale,  bool? darkMode,  double? fontScale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesDAO() when $default != null:
return $default(_that.locale,_that.darkMode,_that.fontScale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? locale,  bool? darkMode,  double? fontScale)  $default,) {final _that = this;
switch (_that) {
case _PreferencesDAO():
return $default(_that.locale,_that.darkMode,_that.fontScale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? locale,  bool? darkMode,  double? fontScale)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesDAO() when $default != null:
return $default(_that.locale,_that.darkMode,_that.fontScale);case _:
  return null;

}
}

}

/// @nodoc


class _PreferencesDAO implements PreferencesDAO {
  const _PreferencesDAO({required this.locale, required this.darkMode, required this.fontScale});
  

@override final  String? locale;
@override final  bool? darkMode;
@override final  double? fontScale;

/// Create a copy of PreferencesDAO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesDAOCopyWith<_PreferencesDAO> get copyWith => __$PreferencesDAOCopyWithImpl<_PreferencesDAO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesDAO&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale));
}


@override
int get hashCode => Object.hash(runtimeType,locale,darkMode,fontScale);

@override
String toString() {
  return 'PreferencesDAO(locale: $locale, darkMode: $darkMode, fontScale: $fontScale)';
}


}

/// @nodoc
abstract mixin class _$PreferencesDAOCopyWith<$Res> implements $PreferencesDAOCopyWith<$Res> {
  factory _$PreferencesDAOCopyWith(_PreferencesDAO value, $Res Function(_PreferencesDAO) _then) = __$PreferencesDAOCopyWithImpl;
@override @useResult
$Res call({
 String? locale, bool? darkMode, double? fontScale
});




}
/// @nodoc
class __$PreferencesDAOCopyWithImpl<$Res>
    implements _$PreferencesDAOCopyWith<$Res> {
  __$PreferencesDAOCopyWithImpl(this._self, this._then);

  final _PreferencesDAO _self;
  final $Res Function(_PreferencesDAO) _then;

/// Create a copy of PreferencesDAO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = freezed,Object? darkMode = freezed,Object? fontScale = freezed,}) {
  return _then(_PreferencesDAO(
locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,darkMode: freezed == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool?,fontScale: freezed == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
