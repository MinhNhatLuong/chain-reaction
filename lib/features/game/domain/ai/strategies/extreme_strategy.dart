import 'dart:math';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

/// An "Extreme" AI that uses Minimax (Depth 2) with alpha-beta pruning.
/// It simulates its own move, and then anticipates the opponent's best
/// counter-move.
class ExtremeStrategy extends AIStrategy {
  ExtremeStrategy(this._rules);
  final GameRules _rules;

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

    // If only one move, just take it (early exit)
    if (validMoves.length == 1) return validMoves.first;

    Point<int>? bestMove;
    var maxScore = double.negativeInfinity;
    var alpha = double.negativeInfinity;

    for (final move in validMoves) {
      // 1. Simulate AI Move
      final stateAfterAi = _simulateMove(state, move, player);

      // Check for immediate win (Always take these, even if lapsing)
      if (_isWin(stateAfterAi, player)) {
        return move; // Instant win, take it!
      }

      // 2. Minimax Step: Anticipate Opponent's Best Response
      var minOpponentScore = double.infinity;
      final opponent = _getNextPlayer(
        stateAfterAi,
        player,
        nextTurnCount: state.turnCount + 1,
      );

      if (opponent != null) {
        final opponentMoves = getValidMoves(stateAfterAi, opponent);

        if (opponentMoves.isEmpty) {
          minOpponentScore = 1000.0; // Good for me
        } else {
          for (final oppMove in opponentMoves) {
            final stateAfterOpp = _simulateMove(
              stateAfterAi,
              oppMove,
              opponent,
            );

            if (_isWin(stateAfterOpp, opponent)) {
              minOpponentScore = double.negativeInfinity;
              break;
            }

            final score = _evaluateState(stateAfterOpp, player);
            if (score < minOpponentScore) {
              minOpponentScore = score;
            }

            // Alpha-beta pruning at minimizing layer.
            if (minOpponentScore <= alpha) {
              break;
            }
          }
        }
      } else {
        minOpponentScore = 10000.0;
      }

      final moveScore = minOpponentScore;

      if (moveScore > maxScore) {
        maxScore = moveScore;
        bestMove = move;
        alpha = maxScore;
      } else if (moveScore == maxScore && random.nextBool()) {
        // Keep play less deterministic when scores are exactly tied.
        bestMove = move;
      }
    }

    return bestMove ?? validMoves[random.nextInt(validMoves.length)];
  }

  // --- Helpers ---

  bool _isWin(GameState state, Player player) {
    return state.activeOwnerIds.length == 1 &&
        state.activeOwnerIds.first == player.id;
  }

  Player? _getNextPlayer(
    GameState state,
    Player current, {
    required int nextTurnCount,
  }) {
    final startIdx = state.players.indexWhere((p) => p.id == current.id);
    if (startIdx == -1) return null;

    final count = state.players.length;
    for (var i = 1; i < count; i++) {
      final nextIdx = (startIdx + i) % count;
      final p = state.players[nextIdx];
      final hasCells = state.cellCountForPlayer(p.id) > 0;
      final isEarlyRound = nextTurnCount <= count;
      if (hasCells || isEarlyRound) {
        return p;
      }
    }
    return null;
  }

  double _evaluateState(GameState state, Player player) {
    if (_isWin(state, player)) return 10000;

    final myCount = state.cellCountForPlayer(player.id);
    if (myCount == 0) return double.negativeInfinity;

    double score = 0;
    var myAtoms = 0;
    var enemyAtoms = 0;
    var myCells = 0;
    var enemyCells = 0;
    var myThreats = 0;

    for (final row in state.grid) {
      for (final cell in row) {
        if (cell.ownerId == player.id) {
          myAtoms += cell.atomCount;
          myCells++;
          if (cell.atomCount == cell.capacity) myThreats++;
        } else if (cell.ownerId != null) {
          enemyAtoms += cell.atomCount;
          enemyCells++;
        }
      }
    }

    score += (myAtoms - enemyAtoms) * 2.0;
    score += (myCells - enemyCells) * 5.0;
    score += myThreats * 1.0;

    return score;
  }

  /// Simulates a move using GameRules.
  /// This logic is now consistent with the UI game engine.
  GameState _simulateMove(GameState state, Point<int> move, Player player) {
    final grid = state.grid.map(List<Cell>.from).toList();
    final queue = <Cell>[];

    // Apply initial move
    final cell = grid[move.y][move.x];
    grid[move.y][move.x] = cell.copyWith(
      atomCount: cell.atomCount + 1,
      ownerId: player.id,
    );

    if (grid[move.y][move.x].isAtCriticalMass) {
      queue.add(grid[move.y][move.x]);
    }

    var safetyCounter = 0;
    // Process entire chain reaction synchronously
    while (queue.isNotEmpty && safetyCounter < 2000) {
      safetyCounter++;
      final explodingCell = queue.removeAt(0);

      // Re-fetch because it might have changed in a previous step (though in queue logic usually we process specific snapshot)
      // Actually, we must fetch from grid to get current state
      final currentCell = grid[explodingCell.y][explodingCell.x];
      if (!currentCell.isAtCriticalMass) continue;

      final result = _rules.processExplosion(
        grid: grid,
        explodingCell: currentCell,
        playerId: player.id,
      );

      // queue.addAll(result.newlyCriticalCells);
      // We need to be careful not to add duplicates if using a simple List
      // But standard BFS/queue is fine.
      queue.addAll(result.newlyCriticalCells);
    }

    return state.copyWith(grid: grid);
  }
}
