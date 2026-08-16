// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreferencesEntity {

 String get locale; bool get darkMode; double get fontScale;
/// Create a copy of PreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesEntityCopyWith<PreferencesEntity> get copyWith => _$PreferencesEntityCopyWithImpl<PreferencesEntity>(this as PreferencesEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesEntity&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale));
}


@override
int get hashCode => Object.hash(runtimeType,locale,darkMode,fontScale);

@override
String toString() {
  return 'PreferencesEntity(locale: $locale, darkMode: $darkMode, fontScale: $fontScale)';
}


}

/// @nodoc
abstract mixin class $PreferencesEntityCopyWith<$Res>  {
  factory $PreferencesEntityCopyWith(PreferencesEntity value, $Res Function(PreferencesEntity) _then) = _$PreferencesEntityCopyWithImpl;
@useResult
$Res call({
 String locale, bool darkMode, double fontScale
});




}
/// @nodoc
class _$PreferencesEntityCopyWithImpl<$Res>
    implements $PreferencesEntityCopyWith<$Res> {
  _$PreferencesEntityCopyWithImpl(this._self, this._then);

  final PreferencesEntity _self;
  final $Res Function(PreferencesEntity) _then;

/// Create a copy of PreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? darkMode = null,Object? fontScale = null,}) {
  return _then(_self.copyWith(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,fontScale: null == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesEntity].
extension PreferencesEntityPatterns on PreferencesEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesEntity value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locale,  bool darkMode,  double fontScale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locale,  bool darkMode,  double fontScale)  $default,) {final _that = this;
switch (_that) {
case _PreferencesEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locale,  bool darkMode,  double fontScale)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesEntity() when $default != null:
return $default(_that.locale,_that.darkMode,_that.fontScale);case _:
  return null;

}
}

}

/// @nodoc


class _PreferencesEntity implements PreferencesEntity {
  const _PreferencesEntity({required this.locale, required this.darkMode, required this.fontScale});
  

@override final  String locale;
@override final  bool darkMode;
@override final  double fontScale;

/// Create a copy of PreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesEntityCopyWith<_PreferencesEntity> get copyWith => __$PreferencesEntityCopyWithImpl<_PreferencesEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesEntity&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale));
}


@override
int get hashCode => Object.hash(runtimeType,locale,darkMode,fontScale);

@override
String toString() {
  return 'PreferencesEntity(locale: $locale, darkMode: $darkMode, fontScale: $fontScale)';
}


}

/// @nodoc
abstract mixin class _$PreferencesEntityCopyWith<$Res> implements $PreferencesEntityCopyWith<$Res> {
  factory _$PreferencesEntityCopyWith(_PreferencesEntity value, $Res Function(_PreferencesEntity) _then) = __$PreferencesEntityCopyWithImpl;
@override @useResult
$Res call({
 String locale, bool darkMode, double fontScale
});




}
/// @nodoc
class __$PreferencesEntityCopyWithImpl<$Res>
    implements _$PreferencesEntityCopyWith<$Res> {
  __$PreferencesEntityCopyWithImpl(this._self, this._then);

  final _PreferencesEntity _self;
  final $Res Function(_PreferencesEntity) _then;

/// Create a copy of PreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? darkMode = null,Object? fontScale = null,}) {
  return _then(_PreferencesEntity(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,fontScale: null == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
