// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: json['id'] as String,
  name: json['name'] as String,
  color: (json['color'] as num).toInt(),
  type:
      $enumDecodeNullable(_$PlayerTypeEnumMap, json['type']) ??
      PlayerType.human,
  difficulty: $enumDecodeNullable(_$AIDifficultyEnumMap, json['difficulty']),
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'type': _$PlayerTypeEnumMap[instance.type]!,
  'difficulty': _$AIDifficultyEnumMap[instance.difficulty],
};

const _$PlayerTypeEnumMap = {PlayerType.human: 'human', PlayerType.ai: 'ai'};

const _$AIDifficultyEnumMap = {
  AIDifficulty.easy: 'easy',
  AIDifficulty.medium: 'medium',
  AIDifficulty.hard: 'hard',
  AIDifficulty.extreme: 'extreme',
  AIDifficulty.god: 'god',
};
