import 'dart:collection';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/features/game/domain/entities/entities.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

/// Use case for placing an atom on the grid.
///
/// Returns a Stream of GameState updates to animate chain reactions.
class PlaceAtomUseCase {
  const PlaceAtomUseCase(this._rules);
  final GameRules _rules;

  /// Places an atom at the given coordinates.
  ///
  /// Returns a stream of intermediate states for animating chain reactions.
  /// The stream will be empty if the move is invalid.
  Stream<GameState> call(
    GameState state,
    int x,
    int y,
  ) async* {
    if (!_rules.isValidMove(state, x, y)) return;

    final currentPlayer = state.currentPlayer;
    final grid = _copyGrid(state.grid);

    // Add atom to the cell
    grid[y][x] = grid[y][x].copyWith(
      atomCount: grid[y][x].atomCount + 1,
      ownerId: currentPlayer.id,
    );

    final needsExplosion = grid[y][x].isAtCriticalMass;

    final workingState = state.copyWith(
      grid: grid,
      isProcessing: true,
      totalMoves: state.totalMoves + 1,
    );

    yield workingState;

    if (needsExplosion) {
      yield* _propagateExplosions(
        workingState,
        Queue<Cell>.from([grid[y][x]]),
      );
    }
  }

  /// Handles chain explosions using a queue-based approach with flight animation phases.
  Stream<GameState> _propagateExplosions(
    GameState state,
    Queue<Cell> explosionQueue,
  ) async* {
    final grid = _copyGrid(state.grid);
    final rows = grid.length;
    final cols = grid[0].length;
    final currentOwnerId = state.currentPlayer.id;
    final currentPlayer = state.currentPlayer; // Used for color

    while (explosionQueue.isNotEmpty) {
      // 1. Identify Cells Exploding in this Wave
      final explodingCell = explosionQueue.removeFirst();
      final cx = explodingCell.x;
      final cy = explodingCell.y;

      if (!grid[cy][cx].isAtCriticalMass) continue;

      // 2. Prepare Explosion Data
      final neighbors = _rules.getNeighbors(cx, cy, rows, cols);
      final atomsToRemove = neighbors.length; // 2, 3, or 4

      final newAtomCount = grid[cy][cx].atomCount - atomsToRemove;

      // 3. Phase 1: Remove atoms from source, Spawn Flying Atoms
      grid[cy][cx] = grid[cy][cx].copyWith(
        atomCount: newAtomCount,
        ownerId: newAtomCount <= 0 ? null : grid[cy][cx].ownerId,
      );

      final flyingAtoms = <FlyingAtom>[];
      var neighborIndex = 0;
      for (final n in neighbors) {
        flyingAtoms.add(
          FlyingAtom(
            // Deterministic ID: "fly_moveCount_fromX_fromY_neighborIndex"
            id: 'fly_${state.totalMoves}_${cx}_${cy}_$neighborIndex',
            fromX: cx,
            fromY: cy,
            toX: n.x,
            toY: n.y,
            color: currentPlayer.color,
          ),
        );
        neighborIndex++;
      }

      // Yield State: Source empty, atoms flying
      yield state.copyWith(grid: _copyGrid(grid), flyingAtoms: flyingAtoms);

      // Wait for flight
      await Future<void>.delayed(
        const Duration(milliseconds: AppDimensions.flightDurationMs),
      ); // Flight duration

      // 4. Phase 2: Land Atoms
      for (final n in neighbors) {
        final neighbor = grid[n.y][n.x];
        grid[n.y][n.x] = neighbor.copyWith(
          atomCount: neighbor.atomCount + 1,
          ownerId: currentOwnerId, // Conquered!
        );

        if (grid[n.y][n.x].isAtCriticalMass) {
          explosionQueue.add(grid[n.y][n.x]);
        }
      }

      final landedState = state.copyWith(
        grid: _copyGrid(grid),
        flyingAtoms: [], // Clear flying atoms
      );

      // Stop propagation immediately once winner is determined.
      final winner = _winnerAfterExplosionWave(state, grid);
      if (winner != null) {
        yield landedState.copyWith(
          winner: winner,
          isGameOver: true,
          isProcessing: false,
          endTime: DateTime.now(),
        );
        return;
      }

      // Yield State: Atoms landed (flying cleared)
      yield landedState;
    }
  }

  Player? _winnerAfterExplosionWave(
    GameState state,
    List<List<Cell>> grid,
  ) {
    final ownersOnBoard = <String>{};
    for (final row in grid) {
      for (final cell in row) {
        final ownerId = cell.ownerId;
        if (ownerId != null) {
          ownersOnBoard.add(ownerId);
        }
      }
    }

    final effectiveTurnCount = state.turnCount + 1;
    if (ownersOnBoard.length != 1 ||
        effectiveTurnCount <= state.players.length) {
      return null;
    }

    final winnerId = ownersOnBoard.first;
    for (final player in state.players) {
      if (player.id == winnerId) {
        return player;
      }
    }
    return null;
  }

  /// Creates a deep copy of the grid.
  List<List<Cell>> _copyGrid(List<List<Cell>> grid) {
    return grid.map(List<Cell>.from).toList();
  }
}

/// Static helper for checking valid moves without instantiating the use case.
class MoveValidator {
  const MoveValidator._();

  /// Checks if a move is valid for the current player.
  static bool isValidMove(
    GameState state,
    int x,
    int y, {
    bool checkProcessing = true,
  }) {
    if (state.isGameOver) return false;
    if (checkProcessing && state.isProcessing) return false;
    if (y < 0 || y >= state.rows || x < 0 || x >= state.cols) return false;
    final cell = state.grid[y][x];
    return cell.ownerId == null || cell.ownerId == state.currentPlayer.id;
  }
}
