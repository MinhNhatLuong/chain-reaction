import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell.freezed.dart';
part 'cell.g.dart';

/// Represents a single cell on the game grid.
///
/// Cells are immutable and contain position, capacity, atom count, and owner.
@freezed
abstract class Cell with _$Cell {
  // Added for custom getters

  @Assert('capacity > 0', 'Capacity must be positive')
  @Assert('atomCount >= 0', 'Atom count cannot be negative')
  const factory Cell({
    required int x,
    required int y,

    /// Maximum atoms before explosion (1=corner, 2=edge, 3=center).
    required int capacity,

    /// Current number of atoms in this cell.
    @Default(0) int atomCount,

    /// ID of the player who owns this cell, or null if empty.
    String? ownerId,
  }) = _Cell;

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
  const Cell._();

  /// Whether the cell is empty (no atoms).
  bool get isEmpty => atomCount == 0;

  /// Whether the cell is about to explode.
  bool get isAtCriticalMass => atomCount > capacity;
}
