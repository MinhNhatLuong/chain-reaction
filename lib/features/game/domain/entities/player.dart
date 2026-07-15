import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// Determines if a player is human or AI
enum PlayerType { human, ai }

/// Difficulty levels for AI players
enum AIDifficulty { easy, medium, hard, extreme, god }

extension AIDifficultyPresentation on AIDifficulty {
  String get label {
    switch (this) {
      case AIDifficulty.easy:
        return 'Easy';
      case AIDifficulty.medium:
        return 'Medium';
      case AIDifficulty.hard:
        return 'Hard';
      case AIDifficulty.extreme:
        return 'Extreme';
      case AIDifficulty.god:
        return 'God';
    }
  }
}

/// Represents a player in the game.
///
/// Players are immutable and identified by a unique ID.
@freezed
abstract class Player with _$Player {
  @Assert('id.isNotEmpty', 'Player ID cannot be empty')
  @Assert('name.isNotEmpty', 'Player name cannot be empty')
  factory Player({
    required String id,
    required String name,
    required int color,
    @Default(PlayerType.human) PlayerType type,
    AIDifficulty? difficulty,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  const Player._();

  bool get isAI => type == PlayerType.ai;
}
