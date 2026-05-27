// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

 List<List<Cell>> get grid; List<Player> get players;/// When the game started (for duration calculation).
 DateTime get startTime; List<FlyingAtom> get flyingAtoms; int get currentPlayerIndex; bool get isGameOver; Player? get winner;/// Flag to block input during chain explosions.
 bool get isProcessing;/// Number of turns elapsed.
 int get turnCount;/// Total number of moves made by all players.
 int get totalMoves;/// When the game ended (for duration calculation).
 DateTime? get endTime;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&const DeepCollectionEquality().equals(other.grid, grid)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other.flyingAtoms, flyingAtoms)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.winner, winner) || other.winner == winner)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.turnCount, turnCount) || other.turnCount == turnCount)&&(identical(other.totalMoves, totalMoves) || other.totalMoves == totalMoves)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(grid),const DeepCollectionEquality().hash(players),startTime,const DeepCollectionEquality().hash(flyingAtoms),currentPlayerIndex,isGameOver,winner,isProcessing,turnCount,totalMoves,endTime);



}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 List<List<Cell>> grid, List<Player> players, DateTime startTime, List<FlyingAtom> flyingAtoms, int currentPlayerIndex, bool isGameOver, Player? winner, bool isProcessing, int turnCount, int totalMoves, DateTime? endTime
});


$PlayerCopyWith<$Res>? get winner;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grid = null,Object? players = null,Object? startTime = null,Object? flyingAtoms = null,Object? currentPlayerIndex = null,Object? isGameOver = null,Object? winner = freezed,Object? isProcessing = null,Object? turnCount = null,Object? totalMoves = null,Object? endTime = freezed,}) {
  return _then(_self.copyWith(
grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as List<List<Cell>>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,flyingAtoms: null == flyingAtoms ? _self.flyingAtoms : flyingAtoms // ignore: cast_nullable_to_non_nullable
as List<FlyingAtom>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as Player?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,turnCount: null == turnCount ? _self.turnCount : turnCount // ignore: cast_nullable_to_non_nullable
as int,totalMoves: null == totalMoves ? _self.totalMoves : totalMoves // ignore: cast_nullable_to_non_nullable
as int,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res>? get winner {
    if (_self.winner == null) {
    return null;
  }

  return $PlayerCopyWith<$Res>(_self.winner!, (value) {
    return _then(_self.copyWith(winner: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<List<Cell>> grid,  List<Player> players,  DateTime startTime,  List<FlyingAtom> flyingAtoms,  int currentPlayerIndex,  bool isGameOver,  Player? winner,  bool isProcessing,  int turnCount,  int totalMoves,  DateTime? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.grid,_that.players,_that.startTime,_that.flyingAtoms,_that.currentPlayerIndex,_that.isGameOver,_that.winner,_that.isProcessing,_that.turnCount,_that.totalMoves,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<List<Cell>> grid,  List<Player> players,  DateTime startTime,  List<FlyingAtom> flyingAtoms,  int currentPlayerIndex,  bool isGameOver,  Player? winner,  bool isProcessing,  int turnCount,  int totalMoves,  DateTime? endTime)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.grid,_that.players,_that.startTime,_that.flyingAtoms,_that.currentPlayerIndex,_that.isGameOver,_that.winner,_that.isProcessing,_that.turnCount,_that.totalMoves,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<List<Cell>> grid,  List<Player> players,  DateTime startTime,  List<FlyingAtom> flyingAtoms,  int currentPlayerIndex,  bool isGameOver,  Player? winner,  bool isProcessing,  int turnCount,  int totalMoves,  DateTime? endTime)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.grid,_that.players,_that.startTime,_that.flyingAtoms,_that.currentPlayerIndex,_that.isGameOver,_that.winner,_that.isProcessing,_that.turnCount,_that.totalMoves,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState extends GameState {
   _GameState({required final  List<List<Cell>> grid, required final  List<Player> players, required this.startTime, final  List<FlyingAtom> flyingAtoms = const [], this.currentPlayerIndex = 0, this.isGameOver = false, this.winner, this.isProcessing = false, this.turnCount = 0, this.totalMoves = 0, this.endTime}): assert(grid.isNotEmpty, 'Grid cannot be empty'),assert(players.isNotEmpty, 'Players list cannot be empty'),assert(currentPlayerIndex >= 0 && currentPlayerIndex < players.length, 'Current player index must be valid'),_grid = grid,_players = players,_flyingAtoms = flyingAtoms,super._();
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

 final  List<List<Cell>> _grid;
@override List<List<Cell>> get grid {
  if (_grid is EqualUnmodifiableListView) return _grid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grid);
}

 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

/// When the game started (for duration calculation).
@override final  DateTime startTime;
 final  List<FlyingAtom> _flyingAtoms;
@override@JsonKey() List<FlyingAtom> get flyingAtoms {
  if (_flyingAtoms is EqualUnmodifiableListView) return _flyingAtoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flyingAtoms);
}

@override@JsonKey() final  int currentPlayerIndex;
@override@JsonKey() final  bool isGameOver;
@override final  Player? winner;
/// Flag to block input during chain explosions.
@override@JsonKey() final  bool isProcessing;
/// Number of turns elapsed.
@override@JsonKey() final  int turnCount;
/// Total number of moves made by all players.
@override@JsonKey() final  int totalMoves;
/// When the game ended (for duration calculation).
@override final  DateTime? endTime;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&const DeepCollectionEquality().equals(other._grid, _grid)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other._flyingAtoms, _flyingAtoms)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.winner, winner) || other.winner == winner)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.turnCount, turnCount) || other.turnCount == turnCount)&&(identical(other.totalMoves, totalMoves) || other.totalMoves == totalMoves)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_grid),const DeepCollectionEquality().hash(_players),startTime,const DeepCollectionEquality().hash(_flyingAtoms),currentPlayerIndex,isGameOver,winner,isProcessing,turnCount,totalMoves,endTime);



}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 List<List<Cell>> grid, List<Player> players, DateTime startTime, List<FlyingAtom> flyingAtoms, int currentPlayerIndex, bool isGameOver, Player? winner, bool isProcessing, int turnCount, int totalMoves, DateTime? endTime
});


@override $PlayerCopyWith<$Res>? get winner;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grid = null,Object? players = null,Object? startTime = null,Object? flyingAtoms = null,Object? currentPlayerIndex = null,Object? isGameOver = null,Object? winner = freezed,Object? isProcessing = null,Object? turnCount = null,Object? totalMoves = null,Object? endTime = freezed,}) {
  return _then(_GameState(
grid: null == grid ? _self._grid : grid // ignore: cast_nullable_to_non_nullable
as List<List<Cell>>,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,flyingAtoms: null == flyingAtoms ? _self._flyingAtoms : flyingAtoms // ignore: cast_nullable_to_non_nullable
as List<FlyingAtom>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as Player?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,turnCount: null == turnCount ? _self.turnCount : turnCount // ignore: cast_nullable_to_non_nullable
as int,totalMoves: null == totalMoves ? _self.totalMoves : totalMoves // ignore: cast_nullable_to_non_nullable
as int,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res>? get winner {
    if (_self.winner == null) {
    return null;
  }

  return $PlayerCopyWith<$Res>(_self.winner!, (value) {
    return _then(_self.copyWith(winner: value));
  });
}
}

// dart format on
