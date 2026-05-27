import 'dart:math';
import 'package:chain_reaction/core/errors/domain_exceptions.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_strategy.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';

class RandomStrategy extends AIStrategy {
  @override
  Future<Point<int>> getMove(
    GameState state,
    Player player,
    Random random,
  ) async {
    // Variable thinking time to feel more natural
    final thinkingTime = 300 + random.nextInt(401); // 300 to 700ms
    await Future<void>.delayed(Duration(milliseconds: thinkingTime));

    final validMoves = getValidMoves(state, player);
    if (validMoves.isEmpty) {
      // This should practically never happen if the game is checking game-over correctly.
      throw const AIException('No valid moves available for AI');
    }
    return validMoves[random.nextInt(validMoves.length)];
  }
}
