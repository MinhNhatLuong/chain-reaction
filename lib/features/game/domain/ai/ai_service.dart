import 'dart:math';

import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/ai/strategies/extreme_strategy.dart';
import 'package:chain_reaction/features/game/domain/ai/strategies/god_strategy.dart';
import 'package:chain_reaction/features/game/domain/ai/strategies/greedy_strategy.dart';
import 'package:chain_reaction/features/game/domain/ai/strategies/random_strategy.dart';
import 'package:chain_reaction/features/game/domain/ai/strategies/strategic_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:flutter/foundation.dart';

class AIComputeParams {
  AIComputeParams(this.state, this.player, this.rules, this.seed);
  final GameState state;
  final Player player;
  final GameRules rules;
  final int seed;
}

Future<Point<int>> _computeMove(AIComputeParams params) async {
  AIStrategy strategy;
  switch (params.player.difficulty) {
    case AIDifficulty.easy:
      strategy = RandomStrategy();
    case AIDifficulty.medium:
      strategy = GreedyStrategy();
    case AIDifficulty.hard:
      strategy = StrategicStrategy();
    case AIDifficulty.extreme:
      strategy = ExtremeStrategy(params.rules);
    case AIDifficulty.god:
      strategy = GodStrategy(params.rules);
    case null:
      strategy = GreedyStrategy();
    // default handled by exhaustive enum switch
  }

  final random = Random(params.seed);

  try {
    return await strategy.getMove(params.state, params.player, random);
  } on DomainException {
    // If a domain exception occurs (e.g. no valid moves), try fallback
    try {
      return await RandomStrategy().getMove(
        params.state,
        params.player,
        random,
      );
    } on Object catch (e) {
      throw AIException('AI Critical Failure: $e');
    }
  } on Object catch (e) {
    // Unexpected error
    throw AIException('AI Unexpected Error: $e');
  }
}

class AIService {
  AIService(this._rules);
  final GameRules _rules;

  Future<Point<int>> getMove(GameState state, Player player) async {
    // Safety check: verify game is not over
    if (state.isGameOver) return const Point(0, 0);

    // Offload calculation to a background isolate
    // Deterministic seed derivation:
    // We use totalMoves to ensure each move gets a different but reproducible seed.
    // Use fixed integer generic hash logic to avoid platform differences.
    final seed =
        state.totalMoves * 31 +
        state.turnCount * 17 +
        state.currentPlayer.id.hashCode;

    try {
      return await compute(
        _computeMove,
        AIComputeParams(state, player, _rules, seed),
      );
    } on Object catch (e) {
      // Wrap isolate errors
      throw AIException('Isolate computation failed: $e');
    }
  }
}
