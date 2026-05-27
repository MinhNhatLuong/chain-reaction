// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cell _$CellFromJson(Map<String, dynamic> json) => _Cell(
  x: (json['x'] as num).toInt(),
  y: (json['y'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
  atomCount: (json['atomCount'] as num?)?.toInt() ?? 0,
  ownerId: json['ownerId'] as String?,
);

Map<String, dynamic> _$CellToJson(_Cell instance) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'capacity': instance.capacity,
  'atomCount': instance.atomCount,
  'ownerId': instance.ownerId,
};
