// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flying_atom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlyingAtom implements DiagnosticableTreeMixin {

 String get id; int get fromX; int get fromY; int get toX; int get toY; int get color;
/// Create a copy of FlyingAtom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlyingAtomCopyWith<FlyingAtom> get copyWith => _$FlyingAtomCopyWithImpl<FlyingAtom>(this as FlyingAtom, _$identity);

  /// Serializes this FlyingAtom to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FlyingAtom'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('fromX', fromX))..add(DiagnosticsProperty('fromY', fromY))..add(DiagnosticsProperty('toX', toX))..add(DiagnosticsProperty('toY', toY))..add(DiagnosticsProperty('color', color));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlyingAtom&&(identical(other.id, id) || other.id == id)&&(identical(other.fromX, fromX) || other.fromX == fromX)&&(identical(other.fromY, fromY) || other.fromY == fromY)&&(identical(other.toX, toX) || other.toX == toX)&&(identical(other.toY, toY) || other.toY == toY)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromX,fromY,toX,toY,color);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FlyingAtom(id: $id, fromX: $fromX, fromY: $fromY, toX: $toX, toY: $toY, color: $color)';
}


}

/// @nodoc
abstract mixin class $FlyingAtomCopyWith<$Res>  {
  factory $FlyingAtomCopyWith(FlyingAtom value, $Res Function(FlyingAtom) _then) = _$FlyingAtomCopyWithImpl;
@useResult
$Res call({
 String id, int fromX, int fromY, int toX, int toY, int color
});




}
/// @nodoc
class _$FlyingAtomCopyWithImpl<$Res>
    implements $FlyingAtomCopyWith<$Res> {
  _$FlyingAtomCopyWithImpl(this._self, this._then);

  final FlyingAtom _self;
  final $Res Function(FlyingAtom) _then;

/// Create a copy of FlyingAtom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromX = null,Object? fromY = null,Object? toX = null,Object? toY = null,Object? color = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromX: null == fromX ? _self.fromX : fromX // ignore: cast_nullable_to_non_nullable
as int,fromY: null == fromY ? _self.fromY : fromY // ignore: cast_nullable_to_non_nullable
as int,toX: null == toX ? _self.toX : toX // ignore: cast_nullable_to_non_nullable
as int,toY: null == toY ? _self.toY : toY // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlyingAtom].
extension FlyingAtomPatterns on FlyingAtom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlyingAtom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlyingAtom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlyingAtom value)  $default,){
final _that = this;
switch (_that) {
case _FlyingAtom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlyingAtom value)?  $default,){
final _that = this;
switch (_that) {
case _FlyingAtom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int fromX,  int fromY,  int toX,  int toY,  int color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlyingAtom() when $default != null:
return $default(_that.id,_that.fromX,_that.fromY,_that.toX,_that.toY,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int fromX,  int fromY,  int toX,  int toY,  int color)  $default,) {final _that = this;
switch (_that) {
case _FlyingAtom():
return $default(_that.id,_that.fromX,_that.fromY,_that.toX,_that.toY,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int fromX,  int fromY,  int toX,  int toY,  int color)?  $default,) {final _that = this;
switch (_that) {
case _FlyingAtom() when $default != null:
return $default(_that.id,_that.fromX,_that.fromY,_that.toX,_that.toY,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlyingAtom with DiagnosticableTreeMixin implements FlyingAtom {
  const _FlyingAtom({required this.id, required this.fromX, required this.fromY, required this.toX, required this.toY, required this.color});
  factory _FlyingAtom.fromJson(Map<String, dynamic> json) => _$FlyingAtomFromJson(json);

@override final  String id;
@override final  int fromX;
@override final  int fromY;
@override final  int toX;
@override final  int toY;
@override final  int color;

/// Create a copy of FlyingAtom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlyingAtomCopyWith<_FlyingAtom> get copyWith => __$FlyingAtomCopyWithImpl<_FlyingAtom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlyingAtomToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FlyingAtom'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('fromX', fromX))..add(DiagnosticsProperty('fromY', fromY))..add(DiagnosticsProperty('toX', toX))..add(DiagnosticsProperty('toY', toY))..add(DiagnosticsProperty('color', color));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlyingAtom&&(identical(other.id, id) || other.id == id)&&(identical(other.fromX, fromX) || other.fromX == fromX)&&(identical(other.fromY, fromY) || other.fromY == fromY)&&(identical(other.toX, toX) || other.toX == toX)&&(identical(other.toY, toY) || other.toY == toY)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromX,fromY,toX,toY,color);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FlyingAtom(id: $id, fromX: $fromX, fromY: $fromY, toX: $toX, toY: $toY, color: $color)';
}


}

/// @nodoc
abstract mixin class _$FlyingAtomCopyWith<$Res> implements $FlyingAtomCopyWith<$Res> {
  factory _$FlyingAtomCopyWith(_FlyingAtom value, $Res Function(_FlyingAtom) _then) = __$FlyingAtomCopyWithImpl;
@override @useResult
$Res call({
 String id, int fromX, int fromY, int toX, int toY, int color
});




}
/// @nodoc
class __$FlyingAtomCopyWithImpl<$Res>
    implements _$FlyingAtomCopyWith<$Res> {
  __$FlyingAtomCopyWithImpl(this._self, this._then);

  final _FlyingAtom _self;
  final $Res Function(_FlyingAtom) _then;

/// Create a copy of FlyingAtom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromX = null,Object? fromY = null,Object? toX = null,Object? toY = null,Object? color = null,}) {
  return _then(_FlyingAtom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromX: null == fromX ? _self.fromX : fromX // ignore: cast_nullable_to_non_nullable
as int,fromY: null == fromY ? _self.fromY : fromY // ignore: cast_nullable_to_non_nullable
as int,toX: null == toX ? _self.toX : toX // ignore: cast_nullable_to_non_nullable
as int,toY: null == toY ? _self.toY : toY // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
