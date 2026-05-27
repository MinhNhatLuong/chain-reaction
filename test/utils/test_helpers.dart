import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

GameState createTestState({
  required int rows,
  required int cols,
  String? currentPlayerId,
  bool isGameOver = false,
  List<List<Cell>>? grid,
}) {
  final players = [
    Player(id: 'p1', name: 'P1', color: 0xFF000000),
    Player(id: 'p2', name: 'P2', color: 0xFFFFFFFF),
  ];

  final effectiveGrid =
      grid ??
      List.generate(
        rows,
        (y) => List.generate(
          cols,
          (x) => Cell(x: x, y: y, capacity: 1), // simplified capacity
        ),
      );

  final playerIndex = players.indexWhere(
    (p) => p.id == (currentPlayerId ?? 'p1'),
  );

  return GameState(
    grid: effectiveGrid,
    players: players,
    currentPlayerIndex: playerIndex == -1 ? 0 : playerIndex,
    isGameOver: isGameOver,
    startTime: DateTime(2000),
  );
}
