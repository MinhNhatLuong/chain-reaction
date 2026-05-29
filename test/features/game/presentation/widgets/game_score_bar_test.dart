import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/presentation/widgets/game_score_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses dark text on light score segments', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: GameScoreBar(
              gameState: _gameStateWithOwners(
                const ['player_1', 'player_2', 'player_2', null],
              ),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('1')).style?.color, Colors.black);
    expect(tester.widget<Text>(find.text('2')).style?.color, Colors.white);
  });

  testWidgets('centers labels in their score segments from exact counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: GameScoreBar(
              gameState: _gameStateWithOwners(
                const ['player_1', 'player_2', 'player_2', null],
              ),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    expect(tester.getCenter(find.text('1')).dx, closeTo(400 / 6, 0.5));
    expect(tester.getCenter(find.text('2')).dx, closeTo(400 * 2 / 3, 0.5));
  });
}

GameState _gameStateWithOwners(List<String?> owners) {
  return GameState(
    grid: [
      for (var index = 0; index < owners.length; index++)
        [
          Cell(
            x: index,
            y: 0,
            capacity: 1,
            atomCount: owners[index] == null ? 0 : 1,
            ownerId: owners[index],
          ),
        ],
    ],
    players: [
      Player(
        id: 'player_1',
        name: 'Player 1',
        color: Colors.white.toARGB32(),
      ),
      Player(
        id: 'player_2',
        name: 'Player 2',
        color: Colors.red.toARGB32(),
      ),
    ],
    startTime: DateTime(2026),
  );
}
