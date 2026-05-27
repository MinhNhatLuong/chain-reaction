// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 HomeStep get currentStep; GameMode get selectedMode; int get playerCount; AIDifficulty get aiDifficulty; int get gridSizeIndex; List<String> get gridSizes;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.selectedMode, selectedMode) || other.selectedMode == selectedMode)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.aiDifficulty, aiDifficulty) || other.aiDifficulty == aiDifficulty)&&(identical(other.gridSizeIndex, gridSizeIndex) || other.gridSizeIndex == gridSizeIndex)&&const DeepCollectionEquality().equals(other.gridSizes, gridSizes));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,selectedMode,playerCount,aiDifficulty,gridSizeIndex,const DeepCollectionEquality().hash(gridSizes));

@override
String toString() {
  return 'HomeState(currentStep: $currentStep, selectedMode: $selectedMode, playerCount: $playerCount, aiDifficulty: $aiDifficulty, gridSizeIndex: $gridSizeIndex, gridSizes: $gridSizes)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 HomeStep currentStep, GameMode selectedMode, int playerCount, AIDifficulty aiDifficulty, int gridSizeIndex, List<String> gridSizes
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? selectedMode = null,Object? playerCount = null,Object? aiDifficulty = null,Object? gridSizeIndex = null,Object? gridSizes = null,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as HomeStep,selectedMode: null == selectedMode ? _self.selectedMode : selectedMode // ignore: cast_nullable_to_non_nullable
as GameMode,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,aiDifficulty: null == aiDifficulty ? _self.aiDifficulty : aiDifficulty // ignore: cast_nullable_to_non_nullable
as AIDifficulty,gridSizeIndex: null == gridSizeIndex ? _self.gridSizeIndex : gridSizeIndex // ignore: cast_nullable_to_non_nullable
as int,gridSizes: null == gridSizes ? _self.gridSizes : gridSizes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeStep currentStep,  GameMode selectedMode,  int playerCount,  AIDifficulty aiDifficulty,  int gridSizeIndex,  List<String> gridSizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentStep,_that.selectedMode,_that.playerCount,_that.aiDifficulty,_that.gridSizeIndex,_that.gridSizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeStep currentStep,  GameMode selectedMode,  int playerCount,  AIDifficulty aiDifficulty,  int gridSizeIndex,  List<String> gridSizes)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.currentStep,_that.selectedMode,_that.playerCount,_that.aiDifficulty,_that.gridSizeIndex,_that.gridSizes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeStep currentStep,  GameMode selectedMode,  int playerCount,  AIDifficulty aiDifficulty,  int gridSizeIndex,  List<String> gridSizes)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentStep,_that.selectedMode,_that.playerCount,_that.aiDifficulty,_that.gridSizeIndex,_that.gridSizes);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({required this.currentStep, required this.selectedMode, required this.playerCount, required this.aiDifficulty, required this.gridSizeIndex, required final  List<String> gridSizes}): _gridSizes = gridSizes,super._();
  

@override final  HomeStep currentStep;
@override final  GameMode selectedMode;
@override final  int playerCount;
@override final  AIDifficulty aiDifficulty;
@override final  int gridSizeIndex;
 final  List<String> _gridSizes;
@override List<String> get gridSizes {
  if (_gridSizes is EqualUnmodifiableListView) return _gridSizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gridSizes);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.selectedMode, selectedMode) || other.selectedMode == selectedMode)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.aiDifficulty, aiDifficulty) || other.aiDifficulty == aiDifficulty)&&(identical(other.gridSizeIndex, gridSizeIndex) || other.gridSizeIndex == gridSizeIndex)&&const DeepCollectionEquality().equals(other._gridSizes, _gridSizes));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,selectedMode,playerCount,aiDifficulty,gridSizeIndex,const DeepCollectionEquality().hash(_gridSizes));

@override
String toString() {
  return 'HomeState(currentStep: $currentStep, selectedMode: $selectedMode, playerCount: $playerCount, aiDifficulty: $aiDifficulty, gridSizeIndex: $gridSizeIndex, gridSizes: $gridSizes)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 HomeStep currentStep, GameMode selectedMode, int playerCount, AIDifficulty aiDifficulty, int gridSizeIndex, List<String> gridSizes
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? selectedMode = null,Object? playerCount = null,Object? aiDifficulty = null,Object? gridSizeIndex = null,Object? gridSizes = null,}) {
  return _then(_HomeState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as HomeStep,selectedMode: null == selectedMode ? _self.selectedMode : selectedMode // ignore: cast_nullable_to_non_nullable
as GameMode,playerCount: null == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int,aiDifficulty: null == aiDifficulty ? _self.aiDifficulty : aiDifficulty // ignore: cast_nullable_to_non_nullable
as AIDifficulty,gridSizeIndex: null == gridSizeIndex ? _self.gridSizeIndex : gridSizeIndex // ignore: cast_nullable_to_non_nullable
as int,gridSizes: null == gridSizes ? _self._gridSizes : gridSizes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
