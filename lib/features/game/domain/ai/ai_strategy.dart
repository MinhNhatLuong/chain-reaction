import 'dart:math';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

abstract class AIStrategy {
  Future<Point<int>> getMove(GameState state, Player player, Random random);

  /// Helper to get all valid moves for a player
  List<Point<int>> getValidMoves(GameState state, Player player) {
    final moves = <Point<int>>[];
    for (var y = 0; y < state.rows; y++) {
      for (var x = 0; x < state.cols; x++) {
        final cell = state.grid[y][x];
        if (cell.ownerId == null || cell.ownerId == player.id) {
          moves.add(Point(x, y));
        }
      }
    }
    return moves;
  }
}
