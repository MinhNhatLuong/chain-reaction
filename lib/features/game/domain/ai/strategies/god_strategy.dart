import 'dart:math';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

/// Strongest AI tier.
///
/// Uses depth-limited minimax with alpha-beta pruning and deterministic
/// move ordering for high tactical strength.
class GodStrategy extends AIStrategy {
  GodStrategy(this._rules);
  final GameRules _rules;

  static const double _winScore = 100000;
  static const int _maxDepth = 3;

  @override
  Future<Point<int>> getMove(
    GameState state,
    Player player,
    Random random,
  ) async {
    // Keep response time human-like while still strong.
    final thinkingTime = 350 + random.nextInt(351); // 350 to 700ms
    await Future<void>.delayed(Duration(milliseconds: thinkingTime));

    final validMoves = getValidMoves(state, player);
    if (validMoves.isEmpty) throw const AIException('No valid moves');
    if (validMoves.length == 1) return validMoves.first;

    final depth = _chooseDepth(validMoves.length);
    final orderedMoves = _orderedMoves(
      state: state,
      moves: validMoves,
      mover: player,
      maximizing: true,
      aiPlayer: player,
    );

    Point<int>? bestMove;
    var bestScore = double.negativeInfinity;
    var alpha = double.negativeInfinity;
    const beta = double.infinity;

    for (final candidate in orderedMoves) {
      // Always take immediate wins.
      if (_isWin(candidate.nextState, player)) {
        return candidate.move;
      }

      final nextPlayer = _getNextPlayer(
        candidate.nextState,
        player,
        nextTurnCount: state.turnCount + 1,
      );

      final score = nextPlayer == null
          ? _evaluateState(candidate.nextState, player)
          : _search(
              state: candidate.nextState,
              activePlayer: nextPlayer,
              aiPlayer: player,
              depth: depth - 1,
              alpha: alpha,
              beta: beta,
              turnCount: state.turnCount + 1,
            );

      if (score > bestScore) {
        bestScore = score;
        bestMove = candidate.move;
        alpha = max(alpha, bestScore);
      }
    }

    return bestMove ?? orderedMoves.first.move;
  }

  int _chooseDepth(int moveCount) {
    // Adaptive depth keeps "God" strong without pathological slow turns.
    if (moveCount <= 10) return _maxDepth;
    if (moveCount <= 20) return _maxDepth;
    return 2;
  }

  double _search({
    required GameState state,
    required Player activePlayer,
    required Player aiPlayer,
    required int depth,
    required double alpha,
    required double beta,
    required int turnCount,
  }) {
    if (depth <= 0) return _evaluateState(state, aiPlayer);

    if (_isWin(state, aiPlayer)) return _winScore + depth;
    if (state.cellCountForPlayer(aiPlayer.id) == 0) return -_winScore - depth;

    final validMoves = getValidMoves(state, activePlayer);
    if (validMoves.isEmpty) {
      final next = _getNextPlayer(
        state,
        activePlayer,
        nextTurnCount: turnCount + 1,
      );
      if (next == null) return _evaluateState(state, aiPlayer);
      return _search(
        state: state,
        activePlayer: next,
        aiPlayer: aiPlayer,
        depth: depth - 1,
        alpha: alpha,
        beta: beta,
        turnCount: turnCount + 1,
      );
    }

    final maximizing = activePlayer.id == aiPlayer.id;
    final ordered = _orderedMoves(
      state: state,
      moves: validMoves,
      mover: activePlayer,
      maximizing: maximizing,
      aiPlayer: aiPlayer,
    );

    if (maximizing) {
      var value = double.negativeInfinity;
      var localAlpha = alpha;

      for (final candidate in ordered) {
        if (_isWin(candidate.nextState, aiPlayer)) {
          return _winScore + depth;
        }

        final next = _getNextPlayer(
          candidate.nextState,
          activePlayer,
          nextTurnCount: turnCount + 1,
        );
        final score = next == null
            ? _evaluateState(candidate.nextState, aiPlayer)
            : _search(
                state: candidate.nextState,
                activePlayer: next,
                aiPlayer: aiPlayer,
                depth: depth - 1,
                alpha: localAlpha,
                beta: beta,
                turnCount: turnCount + 1,
              );

        value = max(value, score);
        localAlpha = max(localAlpha, value);
        if (localAlpha >= beta) break;
      }
      return value;
    }

    var value = double.infinity;
    var localBeta = beta;

    for (final candidate in ordered) {
      if (_isWin(candidate.nextState, activePlayer)) {
        return -_winScore - depth;
      }

      final next = _getNextPlayer(
        candidate.nextState,
        activePlayer,
        nextTurnCount: turnCount + 1,
      );
      final score = next == null
          ? _evaluateState(candidate.nextState, aiPlayer)
          : _search(
              state: candidate.nextState,
              activePlayer: next,
              aiPlayer: aiPlayer,
              depth: depth - 1,
              alpha: alpha,
              beta: localBeta,
              turnCount: turnCount + 1,
            );

      value = min(value, score);
      localBeta = min(localBeta, value);
      if (alpha >= localBeta) break;
    }

    return value;
  }

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
      final candidate = state.players[nextIdx];
      final hasCells = state.cellCountForPlayer(candidate.id) > 0;
      final isEarlyRound = nextTurnCount <= count;
      if (hasCells || isEarlyRound) return candidate;
    }
    return null;
  }

  double _evaluateState(GameState state, Player aiPlayer) {
    if (_isWin(state, aiPlayer)) return _winScore;
    if (state.cellCountForPlayer(aiPlayer.id) == 0) return -_winScore;

    var myAtoms = 0;
    var enemyAtoms = 0;
    var myCells = 0;
    var enemyCells = 0;
    var myPrimed = 0;
    var enemyPrimed = 0;
    var vulnerableCells = 0;

    for (var y = 0; y < state.rows; y++) {
      for (var x = 0; x < state.cols; x++) {
        final cell = state.grid[y][x];
        if (cell.ownerId == aiPlayer.id) {
          myAtoms += cell.atomCount;
          myCells++;
          if (cell.atomCount >= cell.capacity) myPrimed++;

          for (final n in _neighbors(state, Point(x, y))) {
            final nCell = state.grid[n.y][n.x];
            if (nCell.ownerId != null &&
                nCell.ownerId != aiPlayer.id &&
                nCell.atomCount >= nCell.capacity) {
              vulnerableCells++;
              break;
            }
          }
        } else if (cell.ownerId != null) {
          enemyAtoms += cell.atomCount;
          enemyCells++;
          if (cell.atomCount >= cell.capacity) enemyPrimed++;
        }
      }
    }

    var score = 0.0;
    score += (myCells - enemyCells) * 8.0;
    score += (myAtoms - enemyAtoms) * 2.0;
    score += (myPrimed - enemyPrimed) * 3.0;
    score -= vulnerableCells * 5.0;

    return score;
  }

  List<_CandidateMove> _orderedMoves({
    required GameState state,
    required List<Point<int>> moves,
    required Player mover,
    required bool maximizing,
    required Player aiPlayer,
  }) {
    final candidates = <_CandidateMove>[];
    for (final move in moves) {
      final nextState = _simulateMove(state, move, mover);
      final tacticalScore = _evaluateState(nextState, aiPlayer);
      candidates.add(
        _CandidateMove(
          move: move,
          nextState: nextState,
          score: tacticalScore,
        ),
      );
    }

    candidates.sort((a, b) {
      final byScore = maximizing
          ? b.score.compareTo(a.score)
          : a.score.compareTo(b.score);
      if (byScore != 0) return byScore;
      if (a.move.y != b.move.y) return a.move.y.compareTo(b.move.y);
      return a.move.x.compareTo(b.move.x);
    });
    return candidates;
  }

  GameState _simulateMove(GameState state, Point<int> move, Player player) {
    final grid = state.grid.map(List<Cell>.from).toList();
    final queue = <Cell>[];

    final cell = grid[move.y][move.x];
    grid[move.y][move.x] = cell.copyWith(
      atomCount: cell.atomCount + 1,
      ownerId: player.id,
    );

    if (grid[move.y][move.x].isAtCriticalMass) {
      queue.add(grid[move.y][move.x]);
    }

    var safetyCounter = 0;
    while (queue.isNotEmpty && safetyCounter < 2500) {
      safetyCounter++;
      final explodingCell = queue.removeAt(0);
      final currentCell = grid[explodingCell.y][explodingCell.x];
      if (!currentCell.isAtCriticalMass) continue;

      final result = _rules.processExplosion(
        grid: grid,
        explodingCell: currentCell,
        playerId: player.id,
      );
      queue.addAll(result.newlyCriticalCells);
    }

    return state.copyWith(grid: grid);
  }

  List<Point<int>> _neighbors(GameState state, Point<int> point) {
    final neighbors = <Point<int>>[];
    if (point.x > 0) neighbors.add(Point(point.x - 1, point.y));
    if (point.x < state.cols - 1) neighbors.add(Point(point.x + 1, point.y));
    if (point.y > 0) neighbors.add(Point(point.x, point.y - 1));
    if (point.y < state.rows - 1) neighbors.add(Point(point.x, point.y + 1));
    return neighbors;
  }
}

class _CandidateMove {
  _CandidateMove({
    required this.move,
    required this.nextState,
    required this.score,
  });

  final Point<int> move;
  final GameState nextState;
  final double score;
}
