// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShopEvent()';
}


}

/// @nodoc
class $ShopEventCopyWith<$Res>  {
$ShopEventCopyWith(ShopEvent _, $Res Function(ShopEvent) __);
}


/// Adds pattern-matching-related methods to [ShopEvent].
extension ShopEventPatterns on ShopEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PurchaseCompleted value)?  purchaseCompleted,TResult Function( PurchaseError value)?  purchaseError,TResult Function( ValidationComplete value)?  validationComplete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PurchaseCompleted() when purchaseCompleted != null:
return purchaseCompleted(_that);case PurchaseError() when purchaseError != null:
return purchaseError(_that);case ValidationComplete() when validationComplete != null:
return validationComplete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PurchaseCompleted value)  purchaseCompleted,required TResult Function( PurchaseError value)  purchaseError,required TResult Function( ValidationComplete value)  validationComplete,}){
final _that = this;
switch (_that) {
case PurchaseCompleted():
return purchaseCompleted(_that);case PurchaseError():
return purchaseError(_that);case ValidationComplete():
return validationComplete(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PurchaseCompleted value)?  purchaseCompleted,TResult? Function( PurchaseError value)?  purchaseError,TResult? Function( ValidationComplete value)?  validationComplete,}){
final _that = this;
switch (_that) {
case PurchaseCompleted() when purchaseCompleted != null:
return purchaseCompleted(_that);case PurchaseError() when purchaseError != null:
return purchaseError(_that);case ValidationComplete() when validationComplete != null:
return validationComplete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String productId)?  purchaseCompleted,TResult Function( String message)?  purchaseError,TResult Function( String productId,  bool isValid)?  validationComplete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PurchaseCompleted() when purchaseCompleted != null:
return purchaseCompleted(_that.productId);case PurchaseError() when purchaseError != null:
return purchaseError(_that.message);case ValidationComplete() when validationComplete != null:
return validationComplete(_that.productId,_that.isValid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String productId)  purchaseCompleted,required TResult Function( String message)  purchaseError,required TResult Function( String productId,  bool isValid)  validationComplete,}) {final _that = this;
switch (_that) {
case PurchaseCompleted():
return purchaseCompleted(_that.productId);case PurchaseError():
return purchaseError(_that.message);case ValidationComplete():
return validationComplete(_that.productId,_that.isValid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String productId)?  purchaseCompleted,TResult? Function( String message)?  purchaseError,TResult? Function( String productId,  bool isValid)?  validationComplete,}) {final _that = this;
switch (_that) {
case PurchaseCompleted() when purchaseCompleted != null:
return purchaseCompleted(_that.productId);case PurchaseError() when purchaseError != null:
return purchaseError(_that.message);case ValidationComplete() when validationComplete != null:
return validationComplete(_that.productId,_that.isValid);case _:
  return null;

}
}

}

/// @nodoc


class PurchaseCompleted implements ShopEvent {
  const PurchaseCompleted(this.productId);
  

 final  String productId;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseCompletedCopyWith<PurchaseCompleted> get copyWith => _$PurchaseCompletedCopyWithImpl<PurchaseCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseCompleted&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'ShopEvent.purchaseCompleted(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $PurchaseCompletedCopyWith<$Res> implements $ShopEventCopyWith<$Res> {
  factory $PurchaseCompletedCopyWith(PurchaseCompleted value, $Res Function(PurchaseCompleted) _then) = _$PurchaseCompletedCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$PurchaseCompletedCopyWithImpl<$Res>
    implements $PurchaseCompletedCopyWith<$Res> {
  _$PurchaseCompletedCopyWithImpl(this._self, this._then);

  final PurchaseCompleted _self;
  final $Res Function(PurchaseCompleted) _then;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(PurchaseCompleted(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PurchaseError implements ShopEvent {
  const PurchaseError(this.message);
  

 final  String message;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseErrorCopyWith<PurchaseError> get copyWith => _$PurchaseErrorCopyWithImpl<PurchaseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ShopEvent.purchaseError(message: $message)';
}


}

/// @nodoc
abstract mixin class $PurchaseErrorCopyWith<$Res> implements $ShopEventCopyWith<$Res> {
  factory $PurchaseErrorCopyWith(PurchaseError value, $Res Function(PurchaseError) _then) = _$PurchaseErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PurchaseErrorCopyWithImpl<$Res>
    implements $PurchaseErrorCopyWith<$Res> {
  _$PurchaseErrorCopyWithImpl(this._self, this._then);

  final PurchaseError _self;
  final $Res Function(PurchaseError) _then;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PurchaseError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationComplete implements ShopEvent {
  const ValidationComplete(this.productId, {required this.isValid});
  

 final  String productId;
 final  bool isValid;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationCompleteCopyWith<ValidationComplete> get copyWith => _$ValidationCompleteCopyWithImpl<ValidationComplete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationComplete&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.isValid, isValid) || other.isValid == isValid));
}


@override
int get hashCode => Object.hash(runtimeType,productId,isValid);

@override
String toString() {
  return 'ShopEvent.validationComplete(productId: $productId, isValid: $isValid)';
}


}

/// @nodoc
abstract mixin class $ValidationCompleteCopyWith<$Res> implements $ShopEventCopyWith<$Res> {
  factory $ValidationCompleteCopyWith(ValidationComplete value, $Res Function(ValidationComplete) _then) = _$ValidationCompleteCopyWithImpl;
@useResult
$Res call({
 String productId, bool isValid
});




}
/// @nodoc
class _$ValidationCompleteCopyWithImpl<$Res>
    implements $ValidationCompleteCopyWith<$Res> {
  _$ValidationCompleteCopyWithImpl(this._self, this._then);

  final ValidationComplete _self;
  final $Res Function(ValidationComplete) _then;

/// Create a copy of ShopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? isValid = null,}) {
  return _then(ValidationComplete(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
