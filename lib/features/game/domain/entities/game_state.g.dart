// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  grid: (json['grid'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>)
            .map((e) => Cell.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      .toList(),
  players: (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  startTime: DateTime.parse(json['startTime'] as String),
  flyingAtoms:
      (json['flyingAtoms'] as List<dynamic>?)
          ?.map((e) => FlyingAtom.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentPlayerIndex: (json['currentPlayerIndex'] as num?)?.toInt() ?? 0,
  isGameOver: json['isGameOver'] as bool? ?? false,
  winner: json['winner'] == null
      ? null
      : Player.fromJson(json['winner'] as Map<String, dynamic>),
  isProcessing: json['isProcessing'] as bool? ?? false,
  turnCount: (json['turnCount'] as num?)?.toInt() ?? 0,
  totalMoves: (json['totalMoves'] as num?)?.toInt() ?? 0,
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'grid': instance.grid,
      'players': instance.players,
      'startTime': instance.startTime.toIso8601String(),
      'flyingAtoms': instance.flyingAtoms,
      'currentPlayerIndex': instance.currentPlayerIndex,
      'isGameOver': instance.isGameOver,
      'winner': instance.winner,
      'isProcessing': instance.isProcessing,
      'turnCount': instance.turnCount,
      'totalMoves': instance.totalMoves,
      'endTime': instance.endTime?.toIso8601String(),
    };
