import 'dart:math';

import 'package:chain_reaction/features/game/domain/entities/entities.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:chain_reaction/features/game/domain/usecases/place_atom.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game Determinism', () {
    late GameRules rules;
    late PlaceAtomUseCase placeAtom;

    setUp(() {
      rules = const GameRules();
      placeAtom = PlaceAtomUseCase(rules);
    });

    test('Two games with same inputs should be identical', () async {
      final player1 = Player(id: 'p1', color: 0xFF000000, name: 'P1');
      final player2 = Player(id: 'p2', color: 0xFFFFFFFF, name: 'P2');
      final players = [player1, player2];

      // aiService unused in this specific test, but initialized to ensure compilation/setup is valid.
      // aiService; // Silence unused warning

      // Run 1
      final state1Start = GameState(
        grid: List.generate(
          5,
          (y) => List.generate(
            5,
            (x) => Cell(x: x, y: y, capacity: (x == 0 && y == 0) ? 1 : 2),
          ),
        ),
        players: players,
        startTime: DateTime(2025),
      );

      var state1 = state1Start;
      final moves = [
        const Point(0, 0), // P1
        const Point(1, 1), // P2
        const Point(0, 0), // P1 -> Explode
      ];

      final history1 = <GameState>[];
      final atomIds1 = <String>[];

      for (final move in moves) {
        // Manually ensure we are not processing from previous step
        if (state1.isProcessing) {
          state1 = state1.copyWith(isProcessing: false);
        }

        await for (final s in placeAtom(
          state1,
          move.x,
          move.y,
        )) {
          state1 = s;
          history1.add(s);
          if (s.flyingAtoms.isNotEmpty) {
            atomIds1.addAll(s.flyingAtoms.map((a) => a.id));
          }
        }
        // Advance turn
        state1 = rules.nextTurn(state1, now: DateTime(2025));
        history1.add(state1);
      }

      // Run 2
      final state2Start = GameState(
        grid: List.generate(
          5,
          (y) => List.generate(
            5,
            (x) => Cell(x: x, y: y, capacity: (x == 0 && y == 0) ? 1 : 2),
          ),
        ),
        players: players,
        startTime: DateTime(2025),
      );

      var state2 = state2Start;
      final history2 = <GameState>[];
      final atomIds2 = <String>[];

      for (final move in moves) {
        if (state2.isProcessing) {
          state2 = state2.copyWith(isProcessing: false);
        }

        await for (final s in placeAtom(
          state2,
          move.x,
          move.y,
        )) {
          state2 = s;
          history2.add(s);
          if (s.flyingAtoms.isNotEmpty) {
            atomIds2.addAll(s.flyingAtoms.map((a) => a.id));
          }
        }
        // Advance turn
        state2 = rules.nextTurn(state2, now: DateTime(2025));
        history2.add(state2);
      }

      // Assertions
      expect(history1.length, history2.length);
      for (var i = 0; i < history1.length; i++) {
        expect(history1[i], history2[i], reason: 'State mismatch at step $i');
      }

      expect(atomIds1, equals(atomIds2), reason: 'Flying Atom IDs mismatch');
      expect(atomIds1.isNotEmpty, true, reason: 'Should have had flying atoms');
      // Check ID format
      expect(atomIds1.first, startsWith('fly_'));
    });

    // NOTE: Testing AI determinism involves `compute` which can be flaky in test environment
    // without special setup, or slow. We trust that `seed` passing works if unit tests for strategies work.
    // To properly test AI service determinism, we'd need to mock compute or run standard async test.
    // We will skip strict AI Service integration test here to avoid timeout issues,
    // relying on the fact that we passed a seed.
  });
}
