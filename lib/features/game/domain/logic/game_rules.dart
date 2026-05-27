import 'dart:math';

import 'package:chain_reaction/core/constants/app_dimensions.dart';

import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

/// Encapsulates the core rules and mechanics of Chain Reaction.
/// This logic is shared between the Game Engine (for UI) and the AI (for simulation).
class GameRules {
  const GameRules();

  /// Calculates cell capacity based on position.
  /// Corners = 1, Edges = 2, Center = 3.
  /// Note: The capacity is the MAX atoms it can hold *stably*.
  /// Explosion happens if atoms > capacity.
  /// Actually, in standard Chain Reaction:
  /// Corner: Critical at 2 (Capacity 1)
  /// Edge: Critical at 3 (Capacity 2)
  /// Center: Critical at 4 (Capacity 3)
  ///
  /// The entity `Cell` defines `capacity` as the max stable count.
  /// `isAtCriticalMass` is `atomCount > capacity`.
  int calculateCapacity(int x, int y, int rows, int cols) {
    final isCornerX = x == 0 || x == cols - 1;
    final isCornerY = y == 0 || y == rows - 1;

    if (isCornerX && isCornerY) return 1; // Corner
    if (isCornerX || isCornerY) return 2; // Edge
    return 3; // Center
  }

  /// Checks if a move is valid for the current player.
  bool isValidMove(GameState state, int x, int y) {
    if (state.isGameOver) return false;
    // We explicitly allow moves during processing in Simulation, but typically not in UI.
    // The caller determines if 'isProcessing' blocks the move.

    if (y < 0 || y >= state.rows || x < 0 || x >= state.cols) return false;

    final cell = state.grid[y][x];
    // Can play on empty cell OR cell owned by self
    return cell.ownerId == null || cell.ownerId == state.currentPlayer.id;
  }

  /// Gets orthogonal neighbors of a cell.
  List<Point<int>> getNeighbors(int x, int y, int rows, int cols) {
    final neighbors = <Point<int>>[];
    if (y > 0) neighbors.add(Point(x, y - 1)); // Top
    if (x < cols - 1) neighbors.add(Point(x + 1, y)); // Right
    if (y < rows - 1) neighbors.add(Point(x, y + 1)); // Bottom
    if (x > 0) neighbors.add(Point(x - 1, y)); // Left
    return neighbors;
  }

  /// Processes a single explosion step on the grid.
  /// Returns the updated grid and a list of cells that became critical in this step.
  ///
  /// [grid] is the current state of the board.
  /// [explodingCell] is the cell that is currently processing its explosion.
  /// [playerId] is the ID of the player causing the chain reaction (the attacker).
  ExplosionResult processExplosion({
    required List<List<Cell>> grid,
    required Cell explodingCell,
    required String playerId,
  }) {
    final rows = grid.length;
    final cols = grid[0].length;
    final cx = explodingCell.x;
    final cy = explodingCell.y;

    final neighbors = getNeighbors(cx, cy, rows, cols);
    final atomsToRemove = neighbors.length; // 2, 3, or 4

    // Decrease atoms in source cell
    final currentSource = grid[cy][cx];
    final newSourceCount = currentSource.atomCount - atomsToRemove;

    grid[cy][cx] = currentSource.copyWith(
      atomCount: newSourceCount,
      ownerId: newSourceCount <= 0 ? null : currentSource.ownerId,
    );

    final newlyCriticalCells = <Cell>[];

    // Add atoms to neighbors
    for (final n in neighbors) {
      final neighbor = grid[n.y][n.x];
      final nextAtomCount = neighbor.atomCount + 1;

      // Conquered!
      grid[n.y][n.x] = neighbor.copyWith(
        atomCount: nextAtomCount,
        ownerId: playerId,
      );

      if (grid[n.y][n.x].isAtCriticalMass) {
        newlyCriticalCells.add(grid[n.y][n.x]);
      }
    }

    return ExplosionResult(
      grid: grid,
      newlyCriticalCells: newlyCriticalCells,
      neighbors: neighbors,
    );
  }

  /// Checks if there's a winner in the current game state.
  Player? checkWinner(GameState state) {
    if (state.isGameOver) return state.winner;

    final ownersOnBoard = state.activeOwnerIds;

    // No winner during early game (first round of moves)
    if (state.turnCount <= state.players.length) return null;

    // Single owner remaining = winner
    if (ownersOnBoard.length == 1) {
      final winnerId = ownersOnBoard.first;
      return state.players.firstWhere((p) => p.id == winnerId);
    }

    return null;
  }

  /// Advances the game to the next player's turn.
  GameState nextTurn(GameState state, {DateTime? now}) {
    final nextTurnCount = state.turnCount + 1;

    // Get active owners on the board
    final ownersOnBoard = state.activeOwnerIds;

    // Winner check: Only one owner remains after initial turns
    if (ownersOnBoard.length == 1 && nextTurnCount > state.players.length) {
      final winnerId = ownersOnBoard.first;
      return state.copyWith(
        winner: state.players.firstWhere((p) => p.id == winnerId),
        isGameOver: true,
        isProcessing: false,
        turnCount: nextTurnCount,
        endTime: now ?? DateTime.now(),
      );
    }

    // Find next valid player
    final playersCount = state.players.length;
    var nextIndex = (state.currentPlayerIndex + 1) % playersCount;
    var loops = 0;

    while (loops < playersCount) {
      final candidate = state.players[nextIndex];

      // Player is alive if they have atoms OR it's early game
      final isAlive =
          ownersOnBoard.contains(candidate.id) ||
          (nextTurnCount <= playersCount);

      if (isAlive) {
        return state.copyWith(
          currentPlayerIndex: nextIndex,
          turnCount: nextTurnCount,
          isProcessing: false,
        );
      }

      nextIndex = (nextIndex + 1) % playersCount;
      loops++;
    }

    // Fallback: game over
    return state.copyWith(
      isGameOver: true,
      winner: state.players[state.currentPlayerIndex],
      isProcessing: false,
      endTime: now ?? DateTime.now(),
    );
  }

  /// Creates a new game state with an initialized grid.
  GameState initializeGame(
    List<Player> players, {
    String? gridSize,
    int? rows,
    int? cols,
    DateTime? startTime,
  }) {
    var r = rows ?? 10;
    var c = cols ?? 6;

    // If gridSize string is provided, use the mapping from AppDimensions
    if (gridSize != null && AppDimensions.gridSizes.containsKey(gridSize)) {
      final size = AppDimensions.gridSizes[gridSize]!;
      r = size.$1;
      c = size.$2;
    }

    final grid = _createGrid(r, c);

    return GameState(
      grid: grid,
      players: players,
      startTime: startTime ?? DateTime.now(),
    );
  }

  /// Creates an empty grid with correct cell capacities.
  List<List<Cell>> _createGrid(int rows, int cols) {
    return List.generate(rows, (y) {
      return List.generate(cols, (x) {
        final capacity = calculateCapacity(x, y, rows, cols);
        return Cell(x: x, y: y, capacity: capacity);
      });
    });
  }
}

class ExplosionResult {
  ExplosionResult({
    required this.grid,
    required this.newlyCriticalCells,
    required this.neighbors,
  });
  final List<List<Cell>> grid;
  final List<Cell> newlyCriticalCells;
  final List<Point<int>> neighbors;
}
