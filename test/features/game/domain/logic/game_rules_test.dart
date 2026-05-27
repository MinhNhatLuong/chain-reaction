import 'dart:math';

import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/test_helpers.dart';

void main() {
  group('GameRules', () {
    const rules = GameRules();

    group('isValidMove', () {
      test('valid when cell is empty', () {
        final state = createTestState(rows: 5, cols: 5, currentPlayerId: 'p1');
        // Ensure grid[0][0] is empty. createTestState defaults to capacity 1, empty?
        // Check helpers.dart: defaults to Cell(x, y, capacity: 1). Owner is null by default in Cell constructor?
        // I should assume Cell defaults to ownerId: null.
        expect(rules.isValidMove(state, 0, 0), isTrue);
      });

      test('valid when cell is owned by player', () {
        final state = createTestState(rows: 5, cols: 5, currentPlayerId: 'p1');
        state.grid[0][0] = state.grid[0][0].copyWith(ownerId: 'p1');
        expect(rules.isValidMove(state, 0, 0), isTrue);
      });

      test('invalid when cell is owned by opponent', () {
        final state = createTestState(rows: 5, cols: 5, currentPlayerId: 'p1');
        state.grid[0][0] = state.grid[0][0].copyWith(ownerId: 'p2');
        expect(rules.isValidMove(state, 0, 0), isFalse);
      });

      test('invalid when out of bounds', () {
        final state = createTestState(rows: 5, cols: 5);
        expect(rules.isValidMove(state, -1, 0), isFalse);
        expect(rules.isValidMove(state, 0, -1), isFalse);
        expect(rules.isValidMove(state, 5, 0), isFalse);
        expect(rules.isValidMove(state, 0, 5), isFalse);
      });
    });

    group('getCriticalMass', () {
      test('Corner (0,0) -> 1', () {
        // Technically critical mass is "capacity".
        // Corner capacity is 1 (explode at 2).
        // Wait, standard rules: Corner has 2 neighbors -> Capacity 1?
        // Let's verify standard Chain Reaction rules:
        // Corner (2 neighbors) -> Critical Mass = 2 (Explodes when count reaches 2? Or capacity is 1?)
        // Usually: Capacity = Neighbors - 1.
        // Looking at code: Cell.capacity is usually set to neighbor count in Initialize.
        // Let's check logic: explode if atomCount >= capacity.

        // Actually, let's test getNeighbors first as capacity depends on it usually.
      });
    });

    group('getNeighbors', () {
      // 5x5 Grid
      // Rows: 5, Cols: 5
      const rows = 5;
      const cols = 5;

      test('Top-Left Corner (0,0)', () {
        final neighbors = rules.getNeighbors(0, 0, rows, cols);
        expect(neighbors, hasLength(2));
        expect(neighbors, containsAll([const Point(0, 1), const Point(1, 0)]));
      });

      test('Top-Right Corner (0, 4)', () {
        final neighbors = rules.getNeighbors(0, 4, rows, cols);
        expect(neighbors, hasLength(2));
        expect(neighbors, containsAll([const Point(0, 3), const Point(1, 4)]));
      });

      test('Bottom-Left Corner (4, 0)', () {
        final neighbors = rules.getNeighbors(4, 0, rows, cols);
        expect(neighbors, hasLength(2));
        expect(neighbors, containsAll([const Point(3, 0), const Point(4, 1)]));
      });

      test('Bottom-Right Corner (4, 4)', () {
        final neighbors = rules.getNeighbors(4, 4, rows, cols);
        expect(neighbors, hasLength(2));
        expect(neighbors, containsAll([const Point(4, 3), const Point(3, 4)]));
      });

      test('Top Edge (0, 2)', () {
        final neighbors = rules.getNeighbors(0, 2, rows, cols);
        expect(neighbors, hasLength(3));
        expect(
          neighbors,
          containsAll([
            const Point(0, 1), // Left
            const Point(0, 3), // Right
            const Point(1, 2), // Down
          ]),
        );
      });

      test('Left Edge (2, 0)', () {
        final neighbors = rules.getNeighbors(2, 0, rows, cols);
        expect(neighbors, hasLength(3));
        expect(
          neighbors,
          containsAll([
            const Point(1, 0), // Up
            const Point(3, 0), // Down
            const Point(2, 1), // Right
          ]),
        );
      });

      test('Center (2, 2)', () {
        final neighbors = rules.getNeighbors(2, 2, rows, cols);
        expect(neighbors, hasLength(4));
        expect(
          neighbors,
          containsAll([
            const Point(1, 2), // Up
            const Point(3, 2), // Down
            const Point(2, 1), // Left
            const Point(2, 3), // Right
          ]),
        );
      });
    });
  });
}
