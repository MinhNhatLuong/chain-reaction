import 'dart:math';
import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

class GreedyStrategy extends AIStrategy {
  @override
  Future<Point<int>> getMove(
    GameState state,
    Player player,
    Random random,
  ) async {
    // Variable thinking time to feel more natural
    final thinkingTime = 300 + random.nextInt(401); // 300 to 700ms
    await Future<void>.delayed(Duration(milliseconds: thinkingTime));
    final validMoves = getValidMoves(state, player);
    if (validMoves.isEmpty) throw const AIException('No valid moves');

    // 1. Critical Attack: If a move causes an explosion immediately, do it.
    // Bonus: If it explodes AND captures neighbors, that's even better, but pure Greedy just loves explosions.
    final explodingMoves = validMoves.where((move) {
      final cell = state.grid[move.y][move.x];
      return cell.atomCount == cell.capacity;
    }).toList();

    if (explodingMoves.isNotEmpty) {
      return explodingMoves[random.nextInt(explodingMoves.length)];
    }

    // 2. Safe Moves: Filter out moves that are adjacent to critical ENEMY cells.
    // We don't want to place an atom next to an enemy that is about to explode,
    // because they will likely just steal our atom on their turn.
    final safeMoves = validMoves.where((move) {
      return !_isNextToCriticalEnemy(state, move, player);
    }).toList();

    // If all moves are dangerous, we just have to pick one from all valid moves.
    final candidateMoves = safeMoves.isNotEmpty ? safeMoves : validMoves;

    // 3. Reinforcement: Prefer adding to our own existing cells to reach critical mass faster.
    final reinforcementMoves = candidateMoves.where((m) {
      return state.grid[m.y][m.x].ownerId == player.id;
    }).toList();

    if (reinforcementMoves.isNotEmpty) {
      return reinforcementMoves[random.nextInt(reinforcementMoves.length)];
    }

    // 4. Fallback: Random safe move (or random unsafemove if no choice)
    return candidateMoves[random.nextInt(candidateMoves.length)];
  }

  bool _isNextToCriticalEnemy(GameState state, Point<int> move, Player player) {
    // Check neighbors
    // Note: We need neighbor logic here. Simple check.
    final neighbors = <Point<int>>[];
    if (move.x > 0) neighbors.add(Point(move.x - 1, move.y));
    if (move.x < state.cols - 1) neighbors.add(Point(move.x + 1, move.y));
    if (move.y > 0) neighbors.add(Point(move.x, move.y - 1));
    if (move.y < state.rows - 1) neighbors.add(Point(move.x, move.y + 1));

    for (final n in neighbors) {
      final cell = state.grid[n.y][n.x];
      // Enemy cell is primed to explode on its next move.
      if (cell.ownerId != null &&
          cell.ownerId != player.id &&
          cell.atomCount >= cell.capacity) {
        return true;
      }
    }
    return false;
  }
}
