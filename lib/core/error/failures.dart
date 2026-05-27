/// Base failure class for typed error handling.
///
/// All failures in the app should extend this class.
/// This enables pattern matching and exhaustive error handling.
sealed class Failure {
  const Failure(this.message, [this.stackTrace]);
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure: $message';
}

/// Game-related failures.
final class GameFailure extends Failure {
  const GameFailure(super.message, [super.stackTrace]);
}

/// Invalid move attempt.
final class InvalidMoveFailure extends GameFailure {
  const InvalidMoveFailure([super.message = 'Invalid move']);
}

/// Game state corruption.
final class GameStateCorruptedFailure extends GameFailure {
  const GameStateCorruptedFailure([super.message = 'Game state corrupted']);
}

/// Storage-related failures.
final class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.stackTrace]);
}

/// Failed to read from storage.
final class StorageReadFailure extends StorageFailure {
  const StorageReadFailure([super.message = 'Failed to read from storage']);
}

/// Failed to write to storage.
final class StorageWriteFailure extends StorageFailure {
  const StorageWriteFailure([super.message = 'Failed to write to storage']);
}
