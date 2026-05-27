/// Base class for all domain-specific exceptions.
abstract class DomainException implements Exception {
  const DomainException(this.message);
  final String message;

  @override
  String toString() => 'DomainException: $message';
}

/// Thrown when an AI operation fails (e.g., no valid moves, computation error).
class AIException extends DomainException {
  const AIException(super.message);

  @override
  String toString() => 'AIException: $message';
}

/// Thrown when a move is invalid (e.g., out of bounds, wrong player).
class InvalidMoveException extends DomainException {
  const InvalidMoveException(super.message);

  @override
  String toString() => 'InvalidMoveException: $message';
}

/// Thrown when the game state is corrupted or invalid.
class GameStateException extends DomainException {
  const GameStateException(super.message);

  @override
  String toString() => 'GameStateException: $message';
}
