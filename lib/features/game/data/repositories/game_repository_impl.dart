import 'dart:convert';

import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/repositories/game_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._prefs);
  final SharedPreferences _prefs;
  static const String _keyGameState = 'active_game_state';

  @override
  Future<void> saveGame(GameState state) async {
    try {
      final jsonString = jsonEncode(state.toJson());
      await _prefs.setString(_keyGameState, jsonString);
    } on Object {
      // Silently fail on serialization error to prevent game flow interruption.
    }
  }

  @override
  Future<GameState?> loadGame() async {
    final jsonString = _prefs.getString(_keyGameState);
    if (jsonString == null) return null;

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return GameState.fromJson(map);
    } on Object {
      // Return null on deserialization corruption or schema mismatch.
      return null;
    }
  }

  @override
  Future<bool> hasSavedGame() async {
    return _prefs.containsKey(_keyGameState);
  }

  @override
  Future<void> clearGame() async {
    await _prefs.remove(_keyGameState);
  }
}
