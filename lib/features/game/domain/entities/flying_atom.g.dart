// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flying_atom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlyingAtom _$FlyingAtomFromJson(Map<String, dynamic> json) => _FlyingAtom(
  id: json['id'] as String,
  fromX: (json['fromX'] as num).toInt(),
  fromY: (json['fromY'] as num).toInt(),
  toX: (json['toX'] as num).toInt(),
  toY: (json['toY'] as num).toInt(),
  color: (json['color'] as num).toInt(),
);

Map<String, dynamic> _$FlyingAtomToJson(_FlyingAtom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromX': instance.fromX,
      'fromY': instance.fromY,
      'toX': instance.toX,
      'toY': instance.toY,
      'color': instance.color,
    };
