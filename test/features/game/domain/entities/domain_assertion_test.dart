import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain Assertions', () {
    group('Cell', () {
      test('throws assertions error if capacity is not positive', () {
        expect(
          () => Cell(x: 0, y: 0, capacity: 0),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => Cell(x: 0, y: 0, capacity: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertions error if atomCount is negative', () {
        expect(
          () => Cell(x: 0, y: 0, capacity: 1, atomCount: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('creates valid cell', () {
        expect(
          () => const Cell(x: 0, y: 0, capacity: 1),
          returnsNormally,
        );
      });
    });

    group('Player', () {
      test('throws assertions error if id is empty', () {
        expect(
          () => Player(id: '', name: 'Name', color: 0xFF000000),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertions error if name is empty', () {
        expect(
          () => Player(id: '1', name: '', color: 0xFF000000),
          throwsA(isA<AssertionError>()),
        );
      });

      test('creates valid player', () {
        expect(
          () => Player(id: '1', name: 'Name', color: 0xFF000000),
          returnsNormally,
        );
      });
    });

    group('GameState', () {
      final validPlayer = Player(
        id: '1',
        name: 'P1',
        color: 0xFF000000,
      );
      final validGrid = [
        [const Cell(x: 0, y: 0, capacity: 1)],
      ];

      test('throws assertions error if grid is empty', () {
        expect(
          () => GameState(
            grid: [],
            players: [validPlayer],
            startTime: DateTime.now(),
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertions error if players list is empty', () {
        expect(
          () => GameState(
            grid: validGrid,
            players: [],
            startTime: DateTime.now(),
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertions error if currentPlayerIndex is invalid', () {
        expect(
          () => GameState(
            grid: validGrid,
            players: [validPlayer],
            startTime: DateTime.now(),
            currentPlayerIndex: -1,
          ),
          throwsA(isA<AssertionError>()),
        );

        expect(
          () => GameState(
            grid: validGrid,
            players: [validPlayer],
            startTime: DateTime.now(),
            currentPlayerIndex: 1, // Index out of bounds
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('creates valid GameState', () {
        expect(
          () => GameState(
            grid: validGrid,
            players: [validPlayer],
            startTime: DateTime.now(),
          ),
          returnsNormally,
        );
      });
    });
  });
}
