// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopState implements DiagnosticableTreeMixin {

 List<String> get ownedThemeIds; List<ProductDetails> get products;
/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopStateCopyWith<ShopState> get copyWith => _$ShopStateCopyWithImpl<ShopState>(this as ShopState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ShopState'))
    ..add(DiagnosticsProperty('ownedThemeIds', ownedThemeIds))..add(DiagnosticsProperty('products', products));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopState&&const DeepCollectionEquality().equals(other.ownedThemeIds, ownedThemeIds)&&const DeepCollectionEquality().equals(other.products, products));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ownedThemeIds),const DeepCollectionEquality().hash(products));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ShopState(ownedThemeIds: $ownedThemeIds, products: $products)';
}


}

/// @nodoc
abstract mixin class $ShopStateCopyWith<$Res>  {
  factory $ShopStateCopyWith(ShopState value, $Res Function(ShopState) _then) = _$ShopStateCopyWithImpl;
@useResult
$Res call({
 List<String> ownedThemeIds, List<ProductDetails> products
});




}
/// @nodoc
class _$ShopStateCopyWithImpl<$Res>
    implements $ShopStateCopyWith<$Res> {
  _$ShopStateCopyWithImpl(this._self, this._then);

  final ShopState _self;
  final $Res Function(ShopState) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownedThemeIds = null,Object? products = null,}) {
  return _then(_self.copyWith(
ownedThemeIds: null == ownedThemeIds ? _self.ownedThemeIds : ownedThemeIds // ignore: cast_nullable_to_non_nullable
as List<String>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopState].
extension ShopStatePatterns on ShopState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopState value)  $default,){
final _that = this;
switch (_that) {
case _ShopState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopState value)?  $default,){
final _that = this;
switch (_that) {
case _ShopState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> ownedThemeIds,  List<ProductDetails> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopState() when $default != null:
return $default(_that.ownedThemeIds,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> ownedThemeIds,  List<ProductDetails> products)  $default,) {final _that = this;
switch (_that) {
case _ShopState():
return $default(_that.ownedThemeIds,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> ownedThemeIds,  List<ProductDetails> products)?  $default,) {final _that = this;
switch (_that) {
case _ShopState() when $default != null:
return $default(_that.ownedThemeIds,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _ShopState extends ShopState with DiagnosticableTreeMixin {
  const _ShopState({final  List<String> ownedThemeIds = const [], final  List<ProductDetails> products = const []}): _ownedThemeIds = ownedThemeIds,_products = products,super._();
  

 final  List<String> _ownedThemeIds;
@override@JsonKey() List<String> get ownedThemeIds {
  if (_ownedThemeIds is EqualUnmodifiableListView) return _ownedThemeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ownedThemeIds);
}

 final  List<ProductDetails> _products;
@override@JsonKey() List<ProductDetails> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopStateCopyWith<_ShopState> get copyWith => __$ShopStateCopyWithImpl<_ShopState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ShopState'))
    ..add(DiagnosticsProperty('ownedThemeIds', ownedThemeIds))..add(DiagnosticsProperty('products', products));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopState&&const DeepCollectionEquality().equals(other._ownedThemeIds, _ownedThemeIds)&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ownedThemeIds),const DeepCollectionEquality().hash(_products));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ShopState(ownedThemeIds: $ownedThemeIds, products: $products)';
}


}

/// @nodoc
abstract mixin class _$ShopStateCopyWith<$Res> implements $ShopStateCopyWith<$Res> {
  factory _$ShopStateCopyWith(_ShopState value, $Res Function(_ShopState) _then) = __$ShopStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> ownedThemeIds, List<ProductDetails> products
});




}
/// @nodoc
class __$ShopStateCopyWithImpl<$Res>
    implements _$ShopStateCopyWith<$Res> {
  __$ShopStateCopyWithImpl(this._self, this._then);

  final _ShopState _self;
  final $Res Function(_ShopState) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownedThemeIds = null,Object? products = null,}) {
  return _then(_ShopState(
ownedThemeIds: null == ownedThemeIds ? _self._ownedThemeIds : ownedThemeIds // ignore: cast_nullable_to_non_nullable
as List<String>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,
  ));
}


}

// dart format on
