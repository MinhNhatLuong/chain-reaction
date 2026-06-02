import 'dart:math';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

/// A time-bounded search AI above God difficulty.
///
/// Oracle uses iterative deepening minimax with alpha-beta pruning,
/// transposition caching, and tactical extensions for explosive moves.
class OracleStrategy extends AIStrategy {
  OracleStrategy(this._rules);
  final GameRules _rules;

  static const double _winScore = 1000000;
  static const int _maxDepth = 6;
  static const int _extensionLimit = 2;
  static const Duration _timeBudget = Duration(milliseconds: 1500);

  final Map<String, _CacheEntry> _cache = {};
  late Stopwatch _clock;

  @override
  Future<Point<int>> getMove(
    GameState state,
    Player player,
    Random random,
  ) async {
    final thinkingTime = 300 + random.nextInt(251);
    await Future<void>.delayed(Duration(milliseconds: thinkingTime));

    final validMoves = getValidMoves(state, player);
    if (validMoves.isEmpty) throw const AIException('No valid moves');
    if (validMoves.length == 1) return validMoves.first;

    _cache.clear();
    _clock = Stopwatch()..start();

    var bestMove = _orderedMoves(
      state: state,
      moves: validMoves,
      mover: player,
      maximizing: true,
      aiPlayer: player,
    ).first.move;

    for (var depth = 1; depth <= _maxDepth; depth++) {
      final result = _searchRoot(
        state: state,
        player: player,
        depth: depth,
      );

      if (result == null) break;
      bestMove = result.move;
    }

    return bestMove;
  }

  _RootResult? _searchRoot({
    required GameState state,
    required Player player,
    required int depth,
  }) {
    final moves = _orderedMoves(
      state: state,
      moves: getValidMoves(state, player),
      mover: player,
      maximizing: true,
      aiPlayer: player,
    );

    Point<int>? bestMove;
    var bestScore = double.negativeInfinity;
    var alpha = double.negativeInfinity;
    const beta = double.infinity;

    for (final candidate in moves) {
      if (_isOutOfTime) return null;

      if (_isWin(candidate.nextState, player)) {
        return _RootResult(candidate.move, _winScore + depth);
      }

      final next = _getNextPlayer(
        candidate.nextState,
        player,
        nextTurnCount: state.turnCount + 1,
      );

      final nextDepth = _depthAfterMove(
        depth,
        candidate,
        extensionsRemaining: _extensionLimit,
      );

      final score = next == null
          ? _evaluateState(candidate.nextState, player)
          : _search(
              state: candidate.nextState,
              activePlayer: next,
              aiPlayer: player,
              depth: nextDepth,
              alpha: alpha,
              beta: beta,
              turnCount: state.turnCount + 1,
              extensionsRemaining: candidate.isTactical
                  ? _extensionLimit - 1
                  : _extensionLimit,
            );

      if (score == null) return null;

      if (score > bestScore) {
        bestScore = score;
        bestMove = candidate.move;
        alpha = max(alpha, bestScore);
      }
    }

    if (bestMove == null) return null;
    return _RootResult(bestMove, bestScore);
  }

  double? _search({
    required GameState state,
    required Player activePlayer,
    required Player aiPlayer,
    required int depth,
    required double alpha,
    required double beta,
    required int turnCount,
    required int extensionsRemaining,
  }) {
    if (_isOutOfTime) return null;

    if (_isWin(state, aiPlayer)) return _winScore + depth;
    if (state.cellCountForPlayer(aiPlayer.id) == 0) return -_winScore - depth;
    if (depth <= 0) return _evaluateState(state, aiPlayer);

    final cacheKey = _cacheKey(state, activePlayer, aiPlayer, depth, turnCount);
    final cached = _cache[cacheKey];
    if (cached != null && cached.depth >= depth) return cached.score;

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
        extensionsRemaining: extensionsRemaining,
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

    final score = maximizing
        ? _maximize(
            ordered: ordered,
            activePlayer: activePlayer,
            aiPlayer: aiPlayer,
            depth: depth,
            alpha: alpha,
            beta: beta,
            turnCount: turnCount,
            extensionsRemaining: extensionsRemaining,
          )
        : _minimize(
            ordered: ordered,
            activePlayer: activePlayer,
            aiPlayer: aiPlayer,
            depth: depth,
            alpha: alpha,
            beta: beta,
            turnCount: turnCount,
            extensionsRemaining: extensionsRemaining,
          );

    if (score != null) {
      _cache[cacheKey] = _CacheEntry(depth: depth, score: score);
    }
    return score;
  }

  double? _maximize({
    required List<_CandidateMove> ordered,
    required Player activePlayer,
    required Player aiPlayer,
    required int depth,
    required double alpha,
    required double beta,
    required int turnCount,
    required int extensionsRemaining,
  }) {
    var value = double.negativeInfinity;
    var localAlpha = alpha;

    for (final candidate in ordered) {
      if (_isOutOfTime) return null;
      if (_isWin(candidate.nextState, aiPlayer)) return _winScore + depth;

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
              depth: _depthAfterMove(
                depth,
                candidate,
                extensionsRemaining: extensionsRemaining,
              ),
              alpha: localAlpha,
              beta: beta,
              turnCount: turnCount + 1,
              extensionsRemaining: _nextExtensions(
                candidate,
                extensionsRemaining,
              ),
            );

      if (score == null) return null;

      value = max(value, score);
      localAlpha = max(localAlpha, value);
      if (localAlpha >= beta) break;
    }

    return value;
  }

  double? _minimize({
    required List<_CandidateMove> ordered,
    required Player activePlayer,
    required Player aiPlayer,
    required int depth,
    required double alpha,
    required double beta,
    required int turnCount,
    required int extensionsRemaining,
  }) {
    var value = double.infinity;
    var localBeta = beta;

    for (final candidate in ordered) {
      if (_isOutOfTime) return null;
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
              depth: _depthAfterMove(
                depth,
                candidate,
                extensionsRemaining: extensionsRemaining,
              ),
              alpha: alpha,
              beta: localBeta,
              turnCount: turnCount + 1,
              extensionsRemaining: _nextExtensions(
                candidate,
                extensionsRemaining,
              ),
            );

      if (score == null) return null;

      value = min(value, score);
      localBeta = min(localBeta, value);
      if (alpha >= localBeta) break;
    }

    return value;
  }

  int _depthAfterMove(
    int depth,
    _CandidateMove candidate, {
    required int extensionsRemaining,
  }) {
    final nextDepth = depth - 1;
    if (candidate.isTactical && extensionsRemaining > 0) {
      return nextDepth + 1;
    }
    return nextDepth;
  }

  int _nextExtensions(_CandidateMove candidate, int extensionsRemaining) {
    if (candidate.isTactical && extensionsRemaining > 0) {
      return extensionsRemaining - 1;
    }
    return extensionsRemaining;
  }

  bool get _isOutOfTime => _clock.elapsed >= _timeBudget;

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
    var safePrimed = 0;
    var enemyPrimed = 0;
    var vulnerableCells = 0;
    var mobility = 0;
    var enemyMobility = 0;
    var chainPotential = 0;

    for (var y = 0; y < state.rows; y++) {
      for (var x = 0; x < state.cols; x++) {
        final cell = state.grid[y][x];
        if (cell.ownerId == aiPlayer.id) {
          myAtoms += cell.atomCount;
          myCells++;
          mobility++;

          final vulnerable = _isVulnerableToEnemy(state, Point(x, y), aiPlayer);
          if (cell.atomCount >= cell.capacity && !vulnerable) {
            safePrimed++;
          }
          if (vulnerable) vulnerableCells++;
          chainPotential += _chainPotential(state, Point(x, y), aiPlayer);
        } else if (cell.ownerId == null) {
          mobility++;
          enemyMobility++;
        } else {
          enemyAtoms += cell.atomCount;
          enemyCells++;
          enemyMobility++;
          if (cell.atomCount >= cell.capacity) enemyPrimed++;
        }
      }
    }

    var score = 0.0;
    score += (myCells - enemyCells) * 10.0;
    score += (myAtoms - enemyAtoms) * 2.5;
    score += (safePrimed - enemyPrimed) * 6.0;
    score += (mobility - enemyMobility) * 1.25;
    score += chainPotential * 4.0;
    score -= vulnerableCells * 12.0;

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
      final beforeCellCount = state.cellCountForPlayer(mover.id);
      final source = state.grid[move.y][move.x];
      final nextState = _simulateMove(state, move, mover);
      final afterCellCount = nextState.cellCountForPlayer(mover.id);
      final captures = max(0, afterCellCount - beforeCellCount);
      final explodes = source.atomCount + 1 > source.capacity;
      final tacticalScore =
          _evaluateState(nextState, aiPlayer) +
          (explodes ? 18.0 : 0.0) +
          captures * 12.0;

      candidates.add(
        _CandidateMove(
          move: move,
          nextState: nextState,
          score: tacticalScore,
          isTactical: explodes || captures >= 2 || _isWin(nextState, mover),
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
    while (queue.isNotEmpty && safetyCounter < 3000) {
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

  bool _isVulnerableToEnemy(
    GameState state,
    Point<int> point,
    Player aiPlayer,
  ) {
    for (final n in _neighbors(state, point)) {
      final cell = state.grid[n.y][n.x];
      if (cell.ownerId != null &&
          cell.ownerId != aiPlayer.id &&
          cell.atomCount >= cell.capacity) {
        return true;
      }
    }
    return false;
  }

  int _chainPotential(GameState state, Point<int> point, Player aiPlayer) {
    final cell = state.grid[point.y][point.x];
    if (cell.atomCount < cell.capacity) return 0;

    var potential = 0;
    for (final n in _neighbors(state, point)) {
      final neighbor = state.grid[n.y][n.x];
      if (neighbor.ownerId != aiPlayer.id &&
          neighbor.atomCount + 1 > neighbor.capacity) {
        potential += 2;
      } else if (neighbor.ownerId != aiPlayer.id) {
        potential++;
      }
    }
    return potential;
  }

  List<Point<int>> _neighbors(GameState state, Point<int> point) {
    return _rules.getNeighbors(point.x, point.y, state.rows, state.cols);
  }

  String _cacheKey(
    GameState state,
    Player activePlayer,
    Player aiPlayer,
    int depth,
    int turnCount,
  ) {
    final buffer = StringBuffer()
      ..write(activePlayer.id)
      ..write('|')
      ..write(aiPlayer.id)
      ..write('|')
      ..write(depth)
      ..write('|')
      ..write(turnCount)
      ..write('|');

    for (final row in state.grid) {
      for (final cell in row) {
        buffer
          ..write(cell.ownerId ?? '-')
          ..write(':')
          ..write(cell.atomCount)
          ..write(',');
      }
      buffer.write(';');
    }
    return buffer.toString();
  }
}

class _RootResult {
  _RootResult(this.move, this.score);

  final Point<int> move;
  final double score;
}

class _CacheEntry {
  _CacheEntry({
    required this.depth,
    required this.score,
  });

  final int depth;
  final double score;
}

class _CandidateMove {
  _CandidateMove({
    required this.move,
    required this.nextState,
    required this.score,
    required this.isTactical,
  });

  final Point<int> move;
  final GameState nextState;
  final double score;
  final bool isTactical;
}
