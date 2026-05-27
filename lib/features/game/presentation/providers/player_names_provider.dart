import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable state for player names.
@immutable
class PlayerNamesState {
  const PlayerNamesState([Map<int, String>? names])
    : _names = names ?? const {};
  final Map<int, String> _names;

  /// Get the name for a player (1-indexed).
  /// Returns "Player X" if no custom name is set.
  String getName(int index) {
    return _names[index] ?? 'Player $index';
  }

  /// Get all custom names.
  Map<int, String> get allNames => Map.unmodifiable(_names);

  PlayerNamesState copyWith({Map<int, String>? names}) {
    return PlayerNamesState(names ?? _names);
  }

  /// Creates a new state with an updated name.
  PlayerNamesState withUpdatedName(int index, String newName) {
    final newNames = Map<int, String>.from(_names);
    if (newName.trim().isEmpty) {
      newNames.remove(index);
    } else {
      newNames[index] = newName.trim();
    }
    return PlayerNamesState(newNames);
  }

  /// Creates a cleared state.
  PlayerNamesState cleared() => const PlayerNamesState();
}

/// Notifier for managing player names.
class PlayerNamesNotifier extends Notifier<PlayerNamesState> {
  @override
  PlayerNamesState build() {
    return const PlayerNamesState();
  }

  /// Update the name for a specific player (1-indexed).
  void updateName(int index, String newName) {
    state = state.withUpdatedName(index, newName);
  }

  /// Reset all player names to default.
  void resetNames() {
    state = state.cleared();
  }

  /// Set multiple names at once.
  void setNames(Map<int, String> names) {
    state = PlayerNamesState(names);
  }
}

/// Main player names provider.
final playerNamesProvider =
    NotifierProvider<PlayerNamesNotifier, PlayerNamesState>(
      PlayerNamesNotifier.new,
    );

/// Helper provider to get a specific player's name.
/// Usage: ref.watch(playerNameProvider(1)) for player 1's name.
// ignore: specify_nonobvious_property_types
final playerNameProvider = Provider.family<String, int>((ref, index) {
  return ref.watch(playerNamesProvider.select((s) => s.getName(index)));
});
