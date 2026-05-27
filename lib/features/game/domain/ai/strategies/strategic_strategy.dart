import 'dart:math';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

/// A strategic AI that evaluates board position.
/// Uses a simplified heuristic approach rather than full Minimax
/// due to the chaotic nature of Chain Reaction explosions which makes
/// state prediction depth extremely computationally expensive.
class StrategicStrategy extends AIStrategy {
  // 75% chance to play the "best" move, 25% chance to play randomly.
  // This simulates human error and prevents the AI from being perfectly ruthless.
  static const double _difficultyFactor = 0.75;

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

    // Simulate human error
    if (random.nextDouble() > _difficultyFactor) {
      return validMoves[random.nextInt(validMoves.length)];
    }

    Point<int>? bestMove;
    var bestScore = double.negativeInfinity;

    // Evaluate each candidate move
    for (final move in validMoves) {
      final score = _evaluateMove(state, move, player);

      // Add a tiny bit of randomness to break ties and feel organic
      final jitter = random.nextDouble() * 2.0;

      if (score + jitter > bestScore) {
        bestScore = score + jitter;
        bestMove = move;
      }
    }

    return bestMove ?? validMoves[random.nextInt(validMoves.length)];
  }

  double _evaluateMove(GameState state, Point<int> move, Player player) {
    // 1. Simulate the move (fast-forward chain reaction)
    final simulatedState = _simulateMove(state, move, player);

    // 2. Evaluate the resulting state
    double score = 0;

    // A. Win Condition (Highest Priority)
    if (simulatedState.activeOwnerIds.length == 1 &&
        simulatedState.activeOwnerIds.first == player.id) {
      return 10000; // Instant win!
    }

    // B. Material Difference (My Atoms - Enemy Atoms)
    var myAtoms = 0;
    var enemyAtoms = 0;
    var myCells = 0;
    var enemyCells = 0;

    for (final row in simulatedState.grid) {
      for (final cell in row) {
        if (cell.ownerId == player.id) {
          myAtoms += cell.atomCount;
          myCells++;
        } else if (cell.ownerId != null) {
          enemyAtoms += cell.atomCount;
          enemyCells++;
        }
      }
    }

    score += (myAtoms - enemyAtoms) * 1.5;
    score += (myCells - enemyCells) * 1.0;

    // C. Chain Reaction Bonus
    // If we caused a huge chain reaction, the move is likely good.
    // We can infer this from the difference in total atoms or ownership shifts.
    final capturedCells = myCells - state.cellCountForPlayer(player.id);
    if (capturedCells > 0) {
      score += capturedCells * 5.0;
    }

    // D. Vulnerability Penalty
    // Check if we left ourselves open next to a critical enemy
    // Note: This is computationally expensive to check perfectly, so we do a quick scan.
    for (var y = 0; y < simulatedState.rows; y++) {
      for (var x = 0; x < simulatedState.cols; x++) {
        final cell = simulatedState.grid[y][x];
        if (cell.ownerId == player.id) {
          // Check neighbors for critical enemies
          final neighbors = _getNeighbors(simulatedState, Point(x, y));
          for (final n in neighbors) {
            final nCell = simulatedState.grid[n.y][n.x];
            // Enemy cell primed at threshold can explode on their turn
            if (nCell.ownerId != null &&
                nCell.ownerId != player.id &&
                nCell.atomCount >= nCell.capacity) {
              score -= 5.0; // Penalty for being next to a bomb
            }
          }
        }
      }
    }

    // E. Corner/Edge Preference (Tie-breakers)
    final isCorner =
        (move.y == 0 || move.y == state.rows - 1) &&
        (move.x == 0 || move.x == state.cols - 1);
    if (isCorner) score += 2.0;

    final isEdge =
        !isCorner &&
        (move.y == 0 ||
            move.y == state.rows - 1 ||
            move.x == 0 ||
            move.x == state.cols - 1);
    if (isEdge) score += 1.0;

    return score;
  }

  /// Simulates a move and returns the resulting GameState (grid only).
  /// Ignores animation phases and flying atoms, processes logic instantly.
  GameState _simulateMove(GameState state, Point<int> move, Player player) {
    // Deep copy grid
    final grid = state.grid.map(List<Cell>.from).toList();
    final queue = <Point<int>>[];

    // Apply initial move
    final cell = grid[move.y][move.x];
    grid[move.y][move.x] = cell.copyWith(
      atomCount: cell.atomCount + 1,
      ownerId: player.id,
    );

    if (grid[move.y][move.x].isAtCriticalMass) {
      queue.add(move);
    }

    // Process explosions loop (Synchronous)
    // Safety break to prevent infinite loops in weird edge cases
    var safetyCounter = 0;
    while (queue.isNotEmpty && safetyCounter < 1000) {
      safetyCounter++;
      final p = queue.removeAt(0);
      final cx = p.x;
      final cy = p.y;

      // Re-check critical mass (it might have changed if processed multiple times, though typically queue handles distincts)
      if (!grid[cy][cx].isAtCriticalMass) continue;

      final neighbors = _getNeighbors(state, Point(cx, cy));
      // In this logic, we just decrement by capacity or neighbors?
      // Standard logic: Lose atoms equal to neighbors (capacity - 1 + 1 presumed? No, capacity is neighbors)
      // Actually capacity is neighbors. So if at critical mass (>= capacity), it explodes.
      // It loses 'capacity' atoms? Or just sends 1 to each neighbor?
      // UseCase logic: `newAtomCount = grid[cy][cx].atomCount - neighbors.length`

      final currentCell = grid[cy][cx];
      grid[cy][cx] = currentCell.copyWith(
        atomCount: currentCell.atomCount - neighbors.length,
        ownerId: (currentCell.atomCount - neighbors.length) <= 0
            ? null
            : currentCell.ownerId,
      );

      for (final n in neighbors) {
        final neighbor = grid[n.y][n.x];
        final nextAtomCount = neighbor.atomCount + 1;
        grid[n.y][n.x] = neighbor.copyWith(
          atomCount: nextAtomCount,
          ownerId: player.id, // Conquered
        );

        // If this neighbor effectively became critical, add to queue
        if (grid[n.y][n.x].isAtCriticalMass) {
          // We can allow re-adding to queue for chain reaction
          // To avoid infinite loops in simulation if logical bugs exist, safetyCounter helps.
          // Typically we don't check if it's already in queue, just add.
          queue.add(n);
        }
      }

      // Quick win check optimization? Unnecessary for 1-ply unless we want early exit.
      // But we need full state for scoring.
    }

    // Return a lightweight state container
    return state.copyWith(grid: grid);
  }

  List<Point<int>> _getNeighbors(GameState state, Point<int> p) {
    final neighbors = <Point<int>>[];
    if (p.x > 0) neighbors.add(Point(p.x - 1, p.y));
    if (p.x < state.cols - 1) neighbors.add(Point(p.x + 1, p.y));
    if (p.y > 0) neighbors.add(Point(p.x, p.y - 1));
    if (p.y < state.rows - 1) neighbors.add(Point(p.x, p.y + 1));
    return neighbors;
  }
}
