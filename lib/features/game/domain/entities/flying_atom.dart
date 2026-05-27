import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Required for code generation
part 'flying_atom.freezed.dart';
part 'flying_atom.g.dart';

/// Represents an atom currently traveling between cells during an explosion.

@freezed
abstract class FlyingAtom with _$FlyingAtom {
  const factory FlyingAtom({
    required String id,
    required int fromX,
    required int fromY,
    required int toX,
    required int toY,
    required int color,
  }) = _FlyingAtom;

  factory FlyingAtom.fromJson(Map<String, dynamic> json) =>
      _$FlyingAtomFromJson(json);
}
