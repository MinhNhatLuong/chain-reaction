import 'dart:async';
import 'dart:developer';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/core/services/haptic/haptic_service.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_service.dart';
import 'package:chain_reaction/features/game/domain/domain.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:chain_reaction/features/game/domain/repositories/game_repository.dart';
import 'package:chain_reaction/features/game/presentation/providers/game_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_state_provider.g.dart';

/// Notifier for managing game state.
@riverpod
class GameNotifier extends _$GameNotifier {
  late final PlaceAtomUseCase _placeAtom;
  late final GameRules _gameRules;
  late final AIService _aiService;
  late final GameRepository _gameRepository;
  late final HapticService _hapticService;

  StreamSubscription<GameState>? _explosionSubscription;
  final List<GameState> _history = [];

  @override
  GameState? build() {
    _placeAtom = ref.watch(placeAtomUseCaseProvider);
    _gameRules = ref.watch(gameRulesProvider);
    _aiService = ref.watch(aiServiceProvider);
    _gameRepository = ref.watch(gameRepositoryProvider);
    _hapticService = ref.watch(hapticServiceProvider);

    ref.onDispose(_cancelExplosions);

    return null;
  }

  /// Loads a saved game from persistence.
  Future<bool> loadSavedGame() async {
    final savedState = await _gameRepository.loadGame();
    if (savedState != null) {
      state = savedState;
      return true;
    }
    return false;
  }

  /// Initializes a new game with the given players and grid size.
  void initGame(List<Player> players, {String? gridSize}) {
    _cancelExplosions();
    _history.clear();
    state = _gameRules.initializeGame(players, gridSize: gridSize);
    unawaited(_saveGame());
  }

  /// Places an atom at the given coordinates.
  void placeAtom(int x, int y) {
    final currentState = state;
    if (currentState == null) return;

    _history.add(currentState);
    if (_history.length > 50) {
      _history.removeAt(0);
    }
    _cancelExplosions();

    // Play tap feedback
    if (ref.read(isHapticOnProvider)) unawaited(_hapticService.lightImpact());

    GameState? lastState;
    var hasEmitted = false;

    _explosionSubscription = _placeAtom(currentState, x, y).listen(
      (newState) {
        // Detect explosion start (atoms flying)
        if (newState.flyingAtoms.isNotEmpty &&
            (lastState?.flyingAtoms.isEmpty ?? true)) {
          if (ref.read(isHapticOnProvider)) {
            unawaited(_hapticService.explosionPattern());
          }
        }

        lastState = newState;
        state = newState;
        hasEmitted = true;
      },
      onDone: () {
        if (lastState != null && !lastState!.isGameOver) {
          _advanceTurn();
        } else if (!hasEmitted) {
          if (currentState.currentPlayer.isAI) {
            _advanceTurn();
          } else {
            state = currentState.copyWith(isProcessing: false);
          }
        } else if (lastState != null && lastState!.isGameOver) {
          unawaited(_gameRepository.clearGame());
          if (ref.read(isHapticOnProvider)) {
            unawaited(_hapticService.heavyImpact());
          }
        }
      },
      onError: (error) {
        state = currentState.copyWith(isProcessing: false);
      },
    );
  }

  /// Undo the last move.
  ///
  /// If the previous player was AI, this will recursively undo to reach a human player's turn.
  void undo() {
    final currentState = state;
    if (currentState == null || currentState.isProcessing || _history.isEmpty) {
      return;
    }

    // Pop the last state from history
    final previousState = _history.removeLast();
    state = previousState.copyWith(isProcessing: false);
    unawaited(_saveGame());

    // If we reverted to an AI turn, we must undo again to get back to a human
    // (unless history is now empty, in which case we start over or stay at AI start)
    if (previousState.currentPlayer.isAI && _history.isNotEmpty) {
      undo();
    }
  }

  bool get canUndo => _history.isNotEmpty;

  /// Trigger AI move if it's AI turn
  Future<void> _processAIMove() async {
    final currentState = state;
    if (currentState == null || currentState.isGameOver) return;

    final currentPlayer = currentState.currentPlayer;
    if (!currentPlayer.isAI) return;

    // Set processing to true to block UI
    state = currentState.copyWith(isProcessing: true);

    try {
      final move = await _aiService.getMove(currentState, currentPlayer);

      // Validation check to prevent stuck state
      // We pass checkProcessing: false because isProcessing is currently true (we set it above)
      if (isValidMove(move.x, move.y, checkProcessing: false)) {
        placeAtom(move.x, move.y);
      } else {
        // Fallback: This implies AI returned invalid move.
        // Force turn change to prevent stuck state
        _advanceTurn();
      }
    } on DomainException catch (e) {
      // Known domain failure (e.g. AI logic error).
      // Log it in real app. For now, we behave resiliently by skipping turn.
      log('AI Error: $e');
      _advanceTurn();
    } on Object {
      // On unexpected error, skip AI turn to prevent stuck state
      _advanceTurn();
    }
  }

  /// Advances to the next player's turn.
  void _advanceTurn() {
    final currentState = state;
    if (currentState == null || currentState.isGameOver) return;

    state = _gameRules.nextTurn(currentState, now: DateTime.now());

    // Double-check for winner after turn advancement
    final winner = _gameRules.checkWinner(state!);
    if (winner != null && !state!.isGameOver) {
      state = state!.copyWith(
        isGameOver: true,
        winner: winner,
        isProcessing: false,
        endTime: DateTime.now(),
      );
      unawaited(_gameRepository.clearGame());
    } else {
      unawaited(_saveGame()); // Save state at start of new turn
      // If no winner, check if next player is AI
      if (state!.currentPlayer.isAI) {
        unawaited(_processAIMove());
      }
    }
  }

  Future<void> _saveGame() async {
    if (state != null && !state!.isGameOver) {
      await _gameRepository.saveGame(state!);
    }
  }

  /// Checks if a move is valid.
  bool isValidMove(int x, int y, {bool checkProcessing = true}) {
    return MoveValidator.isValidMove(
      state!,
      x,
      y,
      checkProcessing: checkProcessing,
    );
  }

  /// Resets the game to null state.
  void resetGame() {
    _cancelExplosions();
    _history.clear();
    state = null;
    unawaited(_gameRepository.clearGame());
  }

  void _cancelExplosions() {
    // Only cancel subscription, do not nullify state logic blindly
    unawaited(_explosionSubscription?.cancel());
    _explosionSubscription = null;
  }
}

// Derived providers

@riverpod
Player? currentPlayer(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.currentPlayer;
}

@riverpod
List<Player>? players(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.players;
}

@riverpod
List<FlyingAtom> flyingAtoms(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.flyingAtoms ?? [];
}

@riverpod
bool isProcessing(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.isProcessing ?? false;
}

@riverpod
bool isGameOver(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.isGameOver ?? false;
}

@riverpod
Player? winner(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.winner;
}

@riverpod
List<List<Cell>>? grid(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.grid;
}

@riverpod
int turnCount(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.turnCount ?? 0;
}

@riverpod
int totalMoves(Ref ref) {
  final gameState = ref.watch(gameProvider);
  return gameState?.totalMoves ?? 0;
}
