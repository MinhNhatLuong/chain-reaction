// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cell implements DiagnosticableTreeMixin {

 int get x; int get y;/// Maximum atoms before explosion (1=corner, 2=edge, 3=center).
 int get capacity;/// Current number of atoms in this cell.
 int get atomCount;/// ID of the player who owns this cell, or null if empty.
 String? get ownerId;
/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellCopyWith<Cell> get copyWith => _$CellCopyWithImpl<Cell>(this as Cell, _$identity);

  /// Serializes this Cell to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Cell'))
    ..add(DiagnosticsProperty('x', x))..add(DiagnosticsProperty('y', y))..add(DiagnosticsProperty('capacity', capacity))..add(DiagnosticsProperty('atomCount', atomCount))..add(DiagnosticsProperty('ownerId', ownerId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cell&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.atomCount, atomCount) || other.atomCount == atomCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,capacity,atomCount,ownerId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Cell(x: $x, y: $y, capacity: $capacity, atomCount: $atomCount, ownerId: $ownerId)';
}


}

/// @nodoc
abstract mixin class $CellCopyWith<$Res>  {
  factory $CellCopyWith(Cell value, $Res Function(Cell) _then) = _$CellCopyWithImpl;
@useResult
$Res call({
 int x, int y, int capacity, int atomCount, String? ownerId
});




}
/// @nodoc
class _$CellCopyWithImpl<$Res>
    implements $CellCopyWith<$Res> {
  _$CellCopyWithImpl(this._self, this._then);

  final Cell _self;
  final $Res Function(Cell) _then;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? capacity = null,Object? atomCount = null,Object? ownerId = freezed,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,atomCount: null == atomCount ? _self.atomCount : atomCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cell].
extension CellPatterns on Cell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cell value)  $default,){
final _that = this;
switch (_that) {
case _Cell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cell value)?  $default,){
final _that = this;
switch (_that) {
case _Cell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int x,  int y,  int capacity,  int atomCount,  String? ownerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that.x,_that.y,_that.capacity,_that.atomCount,_that.ownerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int x,  int y,  int capacity,  int atomCount,  String? ownerId)  $default,) {final _that = this;
switch (_that) {
case _Cell():
return $default(_that.x,_that.y,_that.capacity,_that.atomCount,_that.ownerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int x,  int y,  int capacity,  int atomCount,  String? ownerId)?  $default,) {final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that.x,_that.y,_that.capacity,_that.atomCount,_that.ownerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cell extends Cell with DiagnosticableTreeMixin {
  const _Cell({required this.x, required this.y, required this.capacity, this.atomCount = 0, this.ownerId}): assert(capacity > 0, 'Capacity must be positive'),assert(atomCount >= 0, 'Atom count cannot be negative'),super._();
  factory _Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

@override final  int x;
@override final  int y;
/// Maximum atoms before explosion (1=corner, 2=edge, 3=center).
@override final  int capacity;
/// Current number of atoms in this cell.
@override@JsonKey() final  int atomCount;
/// ID of the player who owns this cell, or null if empty.
@override final  String? ownerId;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CellCopyWith<_Cell> get copyWith => __$CellCopyWithImpl<_Cell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CellToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Cell'))
    ..add(DiagnosticsProperty('x', x))..add(DiagnosticsProperty('y', y))..add(DiagnosticsProperty('capacity', capacity))..add(DiagnosticsProperty('atomCount', atomCount))..add(DiagnosticsProperty('ownerId', ownerId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cell&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.atomCount, atomCount) || other.atomCount == atomCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,capacity,atomCount,ownerId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Cell(x: $x, y: $y, capacity: $capacity, atomCount: $atomCount, ownerId: $ownerId)';
}


}

/// @nodoc
abstract mixin class _$CellCopyWith<$Res> implements $CellCopyWith<$Res> {
  factory _$CellCopyWith(_Cell value, $Res Function(_Cell) _then) = __$CellCopyWithImpl;
@override @useResult
$Res call({
 int x, int y, int capacity, int atomCount, String? ownerId
});




}
/// @nodoc
class __$CellCopyWithImpl<$Res>
    implements _$CellCopyWith<$Res> {
  __$CellCopyWithImpl(this._self, this._then);

  final _Cell _self;
  final $Res Function(_Cell) _then;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? capacity = null,Object? atomCount = null,Object? ownerId = freezed,}) {
  return _then(_Cell(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,atomCount: null == atomCount ? _self.atomCount : atomCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
