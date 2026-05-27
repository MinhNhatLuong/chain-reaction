import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';

import 'package:chain_reaction/features/game/domain/usecases/place_atom.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late PlaceAtomUseCase placeAtom;
  late List<Player> players;
  late GameRules rules;

  setUp(() {
    rules = const GameRules();
    placeAtom = PlaceAtomUseCase(rules);
    players = [
      Player(id: 'p1', name: 'Player 1', color: 0xFF000000),
      Player(id: 'p2', name: 'Player 2', color: 0xFFFFFFFF),
    ];
  });

  group('PlaceAtomUseCase', () {
    test('should place atom on empty cell and update owner', () async {
      final initialState = rules.initializeGame(players, gridSize: 'Small');
      final stream = placeAtom(initialState, 0, 0);

      final states = await stream.toList();
      final finalState = states.last;

      final cell = finalState.grid[0][0];
      expect(cell.atomCount, 1);
      expect(cell.ownerId, players[0].id);
      expect(cell.atomCount == cell.capacity, true);
    });

    test('should increment atom count on own cell', () async {
      var state = rules.initializeGame(players, gridSize: 'Small');

      // Place on 0,1 (Edge, capacity 2)
      var stream = placeAtom(state, 1, 0);
      state = (await stream.last).copyWith(isProcessing: false);

      expect(state.grid[0][1].atomCount, 1);

      stream = placeAtom(state, 1, 0);
      state = (await stream.last).copyWith(isProcessing: false);

      expect(state.grid[0][1].atomCount, 2);
      expect(state.grid[0][1].ownerId, players[0].id);
    });

    test('should trigger explosion on critical mass', () async {
      var state = rules.initializeGame(players, gridSize: 'Small');

      // Seed P2 atom to prevent instant win
      final grid = List<List<Cell>>.from(
        state.grid.map(List<Cell>.from),
      );
      grid[3][0] = grid[3][0].copyWith(atomCount: 1, ownerId: 'p2');
      state = state.copyWith(grid: grid);

      // 1st placement. Reset isProcessing.
      state = (await placeAtom(state, 0, 0).last).copyWith(isProcessing: false);

      // 2nd placement (Explosion)
      final explosionStream = placeAtom(state, 0, 0);
      final states = await explosionStream.toList();

      final finalState = states.last;

      expect(finalState.grid[0][0].atomCount, 0); // Exploded to 0
      expect(finalState.grid[0][1].atomCount, 1); // Neighbor 1
      expect(finalState.grid[1][0].atomCount, 1); // Neighbor 2

      expect(finalState.grid[0][1].ownerId, players[0].id);
      expect(finalState.grid[1][0].ownerId, players[0].id);
    });

    test('should propagate chain reaction', () async {
      var state = rules.initializeGame(players, gridSize: 'Small');

      // Seed P2 atom to prevent instant win
      final grid = List<List<Cell>>.from(
        state.grid.map(List<Cell>.from),
      );
      grid[3][0] = grid[3][0].copyWith(atomCount: 1, ownerId: 'p2');
      state = state.copyWith(grid: grid);

      Future<GameState> play(int x, int y) async {
        return (await placeAtom(
          state,
          x,
          y,
        ).last).copyWith(isProcessing: false);
      }

      // Setup chain conditions
      state = await play(1, 0); // (1,0) count 1
      state = await play(0, 1); // (0,1) count 1
      state = await play(0, 0); // (0,0) count 1
      state = await play(0, 0); // (0,0) count 2 -> Explode (1,0)->2, (0,1)->2

      // Verify state before final trigger
      expect(state.grid[0][0].atomCount, 0);
      expect(state.grid[0][1].atomCount, 2);
      expect(state.grid[1][0].atomCount, 2);

      // Trigger chain at (0,0)
      state = await play(0, 0); // (0,0) count 1

      // Final trigger: explode (0,0). Neighbors (0,1) and (1,0) get +1 -> 3
      // -> EXPLODE!
      final stream = placeAtom(state, 0, 0);
      final reactionStates = await stream.toList();

      expect(reactionStates.length, greaterThan(2));
    });

    test('should not end game during opening explosion phase', () async {
      final threePlayers = [
        Player(id: 'p1', name: 'Player 1', color: 0xFF000000),
        Player(id: 'p2', name: 'Player 2', color: 0xFFFFFFFF),
        Player(id: 'p3', name: 'Player 3', color: 0xFFFF0000),
      ];

      var state = rules.initializeGame(threePlayers, rows: 2, cols: 2);

      // First placement fills the corner up to capacity (no explosion yet).
      state = await placeAtom(state, 0, 0).last;

      // Second placement overflows the corner and triggers an explosion.
      final postExplosion = await placeAtom(state, 0, 0).last;

      expect(postExplosion.isGameOver, isFalse);
      expect(postExplosion.winner, isNull);
    });

    test(
      'should stop chain reaction immediately after winner is determined',
      () async {
        var state = rules.initializeGame(players, rows: 2, cols: 2);
        final grid = List<List<Cell>>.from(
          state.grid.map(List<Cell>.from),
        );

        // Prepare an in-progress board where first explosion wave captures
        // the final opponent cell while additional critical cells are queued.
        grid[0][0] = grid[0][0].copyWith(atomCount: 2, ownerId: 'p1');
        grid[0][1] = grid[0][1].copyWith(atomCount: 2, ownerId: 'p1');
        grid[1][0] = grid[1][0].copyWith(atomCount: 1, ownerId: 'p2');
        grid[1][1] = grid[1][1].copyWith(atomCount: 1, ownerId: 'p1');

        state = state.copyWith(
          grid: grid,
          currentPlayerIndex: 0,
          turnCount: 3, // Opening phase already over for 2 players.
        );

        final states = await placeAtom(state, 0, 0).toList();
        final finalState = states.last;

        expect(finalState.isGameOver, isTrue);
        expect(finalState.winner?.id, 'p1');
        expect(finalState.flyingAtoms, isEmpty);
        expect(states.length, lessThanOrEqualTo(3));
      },
    );
  });
}
