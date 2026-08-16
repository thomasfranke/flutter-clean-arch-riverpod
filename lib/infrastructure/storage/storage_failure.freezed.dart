// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StorageFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure()';
}


}

/// @nodoc
class $StorageFailureCopyWith<$Res>  {
$StorageFailureCopyWith(StorageFailure _, $Res Function(StorageFailure) __);
}


/// Adds pattern-matching-related methods to [StorageFailure].
extension StorageFailurePatterns on StorageFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StorageWriteFailure value)?  write,TResult Function( StorageReadFailure value)?  read,TResult Function( StorageRemoveFailure value)?  remove,TResult Function( StorageClearFailure value)?  clear,TResult Function( StorageUnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StorageWriteFailure() when write != null:
return write(_that);case StorageReadFailure() when read != null:
return read(_that);case StorageRemoveFailure() when remove != null:
return remove(_that);case StorageClearFailure() when clear != null:
return clear(_that);case StorageUnexpectedFailure() when unexpected != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StorageWriteFailure value)  write,required TResult Function( StorageReadFailure value)  read,required TResult Function( StorageRemoveFailure value)  remove,required TResult Function( StorageClearFailure value)  clear,required TResult Function( StorageUnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case StorageWriteFailure():
return write(_that);case StorageReadFailure():
return read(_that);case StorageRemoveFailure():
return remove(_that);case StorageClearFailure():
return clear(_that);case StorageUnexpectedFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StorageWriteFailure value)?  write,TResult? Function( StorageReadFailure value)?  read,TResult? Function( StorageRemoveFailure value)?  remove,TResult? Function( StorageClearFailure value)?  clear,TResult? Function( StorageUnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case StorageWriteFailure() when write != null:
return write(_that);case StorageReadFailure() when read != null:
return read(_that);case StorageRemoveFailure() when remove != null:
return remove(_that);case StorageClearFailure() when clear != null:
return clear(_that);case StorageUnexpectedFailure() when unexpected != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  write,TResult Function()?  read,TResult Function()?  remove,TResult Function()?  clear,TResult Function()?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StorageWriteFailure() when write != null:
return write();case StorageReadFailure() when read != null:
return read();case StorageRemoveFailure() when remove != null:
return remove();case StorageClearFailure() when clear != null:
return clear();case StorageUnexpectedFailure() when unexpected != null:
return unexpected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  write,required TResult Function()  read,required TResult Function()  remove,required TResult Function()  clear,required TResult Function()  unexpected,}) {final _that = this;
switch (_that) {
case StorageWriteFailure():
return write();case StorageReadFailure():
return read();case StorageRemoveFailure():
return remove();case StorageClearFailure():
return clear();case StorageUnexpectedFailure():
return unexpected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  write,TResult? Function()?  read,TResult? Function()?  remove,TResult? Function()?  clear,TResult? Function()?  unexpected,}) {final _that = this;
switch (_that) {
case StorageWriteFailure() when write != null:
return write();case StorageReadFailure() when read != null:
return read();case StorageRemoveFailure() when remove != null:
return remove();case StorageClearFailure() when clear != null:
return clear();case StorageUnexpectedFailure() when unexpected != null:
return unexpected();case _:
  return null;

}
}

}

/// @nodoc


class StorageWriteFailure implements StorageFailure {
  const StorageWriteFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageWriteFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure.write()';
}


}




/// @nodoc


class StorageReadFailure implements StorageFailure {
  const StorageReadFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageReadFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure.read()';
}


}




/// @nodoc


class StorageRemoveFailure implements StorageFailure {
  const StorageRemoveFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageRemoveFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure.remove()';
}


}




/// @nodoc


class StorageClearFailure implements StorageFailure {
  const StorageClearFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageClearFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure.clear()';
}


}




/// @nodoc


class StorageUnexpectedFailure implements StorageFailure {
  const StorageUnexpectedFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageUnexpectedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StorageFailure.unexpected()';
}


}




// dart format on
