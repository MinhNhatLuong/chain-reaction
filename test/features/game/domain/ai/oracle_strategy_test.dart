import 'dart:math';

import 'package:chain_reaction/features/game/domain/ai/strategies/oracle_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OracleStrategy', () {
    test('takes an immediate winning explosion', () async {
      const rules = GameRules();
      final aiPlayer = Player(id: 'p1', name: 'AI', color: 0xFF000000);
      final opponent = Player(id: 'p2', name: 'Human', color: 0xFFFFFFFF);
      final grid = [
        [
          const Cell(x: 0, y: 0, capacity: 1, atomCount: 1, ownerId: 'p1'),
          const Cell(x: 1, y: 0, capacity: 1),
        ],
        [
          const Cell(x: 0, y: 1, capacity: 1, atomCount: 1, ownerId: 'p2'),
          const Cell(x: 1, y: 1, capacity: 1),
        ],
      ];
      final state = GameState(
        grid: grid,
        players: [aiPlayer, opponent],
        startTime: DateTime(2000),
        turnCount: 3,
      );

      final move = await OracleStrategy(rules).getMove(
        state,
        aiPlayer,
        Random(1),
      );

      expect(move, const Point<int>(0, 0));
    });
  });
}
