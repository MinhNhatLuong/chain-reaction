import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/flying_atom.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Represents the complete state of a game session.
///
/// GameState is immutable; use [copyWith] to derive new states.
@freezed
abstract class GameState with _$GameState {
  @Assert('grid.isNotEmpty', 'Grid cannot be empty')
  @Assert('players.isNotEmpty', 'Players list cannot be empty')
  @Assert(
    'currentPlayerIndex >= 0 && currentPlayerIndex < players.length',
    'Current player index must be valid',
  )
  factory GameState({
    required List<List<Cell>> grid,
    required List<Player> players,

    /// When the game started (for duration calculation).
    required DateTime startTime,
    @Default([]) List<FlyingAtom> flyingAtoms,
    @Default(0) int currentPlayerIndex,
    @Default(false) bool isGameOver,
    Player? winner,

    /// Flag to block input during chain explosions.
    @Default(false) bool isProcessing,

    /// Number of turns elapsed.
    @Default(0) int turnCount,

    /// Total number of moves made by all players.
    @Default(0) int totalMoves,

    /// When the game ended (for duration calculation).
    DateTime? endTime,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
  const GameState._();

  /// The player whose turn it currently is.
  Player get currentPlayer => players[currentPlayerIndex];

  /// Number of rows in the grid.
  int get rows => grid.length;

  /// Number of columns in the grid.
  int get cols => grid.isNotEmpty ? grid[0].length : 0;

  /// Total cells in the grid.
  int get totalCells => rows * cols;

  /// Get the number of cells owned by a specific player.
  int cellCountForPlayer(String playerId) {
    var count = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell.ownerId == playerId) count++;
      }
    }
    return count;
  }

  /// Get cells owned by the winner.
  int get winnerCellCount {
    if (winner == null) return 0;
    return cellCountForPlayer(winner!.id);
  }

  /// Territory percentage for the winner.
  int get territoryPercentage {
    if (totalCells == 0) return 0;
    return ((winnerCellCount / totalCells) * 100).round();
  }

  /// Get all unique owner IDs currently on the board.
  Set<String> get activeOwnerIds {
    final owners = <String>{};
    for (final row in grid) {
      for (final cell in row) {
        if (cell.ownerId != null) {
          owners.add(cell.ownerId!);
        }
      }
    }
    return owners;
  }

  /// Game duration.
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Formatted duration string (MM:SS).
  String get formattedDuration {
    final d = duration;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  String toString() =>
      'GameState(turn: $turnCount, player: ${currentPlayer.name}, gameOver: $isGameOver, flying: ${flyingAtoms.length})';
}
