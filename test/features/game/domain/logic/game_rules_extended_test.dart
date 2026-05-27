import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final players = [
    Player(id: 'p1', name: 'Player 1', color: 0xFF2196F3), // Colors.blue
    Player(id: 'p2', name: 'Player 2', color: 0xFFF44336), // Colors.red
  ];

  group('NextTurnUseCase', () {
    test('should rotate through players correctly', () {
      const rules = GameRules();
      // Mock state: p1 active
      // Fix: Grid cannot be empty
      var state = GameState(
        grid: [
          [const Cell(x: 0, y: 0, capacity: 1)],
        ],
        players: players,
        startTime: DateTime.now(),
      );

      // p1 -> p2
      state = rules.nextTurn(state);
      expect(state.currentPlayer.id, 'p2');
      expect(state.turnCount, 1);

      // p2 -> p1
      state = rules.nextTurn(state);
      expect(state.currentPlayer.id, 'p1');
      expect(state.turnCount, 2);
    });

    test('should skip eliminated players', () {
      const rules = GameRules();
      final p3 = Player(
        id: 'p3',
        name: 'P3',
        color: 0xFF4CAF50,
      ); // Colors.green
      final activePlayers = [...players, p3]; // p1, p2, p3

      // Create grid where p1 and p2 have cells, but p3 does not
      final grid = [
        [
          const Cell(x: 0, y: 0, capacity: 1, atomCount: 1, ownerId: 'p1'),
          const Cell(x: 1, y: 0, capacity: 1, atomCount: 1, ownerId: 'p2'),
        ],
      ];

      var state = GameState(
        grid: grid,
        players: activePlayers,
        currentPlayerIndex: 1, // Currently p2's turn
        turnCount: 10, // Late game (> player count)
        startTime: DateTime.now(),
      );

      // p2 -> p3 (no cells, eliminated) -> p1 (has cells)
      state = rules.nextTurn(state);
      expect(state.currentPlayer.id, 'p1');
    });
  });

  group('CheckWinnerUseCase', () {
    test('should return null if multiple players have atoms', () {
      const rules = GameRules();

      final grid = [
        [
          const Cell(x: 0, y: 0, capacity: 1, atomCount: 1, ownerId: 'p1'),
          const Cell(x: 1, y: 0, capacity: 1, atomCount: 1, ownerId: 'p2'),
        ],
      ];

      final state = GameState(
        grid: grid,
        players: players,
        turnCount: 10,
        startTime: DateTime.now(),
      );

      expect(rules.checkWinner(state), null);
    });
  });
}
