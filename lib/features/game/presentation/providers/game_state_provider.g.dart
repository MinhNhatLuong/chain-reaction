// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing game state.

@ProviderFor(GameNotifier)
const gameProvider = GameNotifierProvider._();

/// Notifier for managing game state.
final class GameNotifierProvider
    extends $NotifierProvider<GameNotifier, GameState?> {
  /// Notifier for managing game state.
  const GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameState?>(value),
    );
  }
}

String _$gameNotifierHash() => r'8aec7f3f4cc42ecc2f997b6501b615f0073bdd60';

/// Notifier for managing game state.

abstract class _$GameNotifier extends $Notifier<GameState?> {
  GameState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GameState?, GameState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameState?, GameState?>,
              GameState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentPlayer)
const currentPlayerProvider = CurrentPlayerProvider._();

final class CurrentPlayerProvider
    extends $FunctionalProvider<Player?, Player?, Player?>
    with $Provider<Player?> {
  const CurrentPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPlayerHash();

  @$internal
  @override
  $ProviderElement<Player?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Player? create(Ref ref) {
    return currentPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Player? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Player?>(value),
    );
  }
}

String _$currentPlayerHash() => r'f19ce02eb240b22a8b75ee5593a3eb23023a99f4';

@ProviderFor(players)
const playersProvider = PlayersProvider._();

final class PlayersProvider
    extends $FunctionalProvider<List<Player>?, List<Player>?, List<Player>?>
    with $Provider<List<Player>?> {
  const PlayersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playersHash();

  @$internal
  @override
  $ProviderElement<List<Player>?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Player>? create(Ref ref) {
    return players(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Player>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Player>?>(value),
    );
  }
}

String _$playersHash() => r'f3fa4b572f7fc3929cc1a9fd1e78af4149e44852';

@ProviderFor(flyingAtoms)
const flyingAtomsProvider = FlyingAtomsProvider._();

final class FlyingAtomsProvider
    extends
        $FunctionalProvider<
          List<FlyingAtom>,
          List<FlyingAtom>,
          List<FlyingAtom>
        >
    with $Provider<List<FlyingAtom>> {
  const FlyingAtomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flyingAtomsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flyingAtomsHash();

  @$internal
  @override
  $ProviderElement<List<FlyingAtom>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<FlyingAtom> create(Ref ref) {
    return flyingAtoms(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FlyingAtom> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FlyingAtom>>(value),
    );
  }
}

String _$flyingAtomsHash() => r'10e4eef1811bdc4a79a3619ced0e02c233eca508';

@ProviderFor(isProcessing)
const isProcessingProvider = IsProcessingProvider._();

final class IsProcessingProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsProcessingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isProcessingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isProcessingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isProcessing(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isProcessingHash() => r'0ebbceed3edde5b82888baa7149c8dd66be004d7';

@ProviderFor(isGameOver)
const isGameOverProvider = IsGameOverProvider._();

final class IsGameOverProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsGameOverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isGameOverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isGameOverHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isGameOver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isGameOverHash() => r'89d66864c6f976d6c3a7a192d73f5fa4c6c35708';

@ProviderFor(winner)
const winnerProvider = WinnerProvider._();

final class WinnerProvider
    extends $FunctionalProvider<Player?, Player?, Player?>
    with $Provider<Player?> {
  const WinnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'winnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$winnerHash();

  @$internal
  @override
  $ProviderElement<Player?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Player? create(Ref ref) {
    return winner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Player? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Player?>(value),
    );
  }
}

String _$winnerHash() => r'5e13dcf03a916919d364c3dd46ee565201eb8096';

@ProviderFor(grid)
const gridProvider = GridProvider._();

final class GridProvider
    extends
        $FunctionalProvider<
          List<List<Cell>>?,
          List<List<Cell>>?,
          List<List<Cell>>?
        >
    with $Provider<List<List<Cell>>?> {
  const GridProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gridProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gridHash();

  @$internal
  @override
  $ProviderElement<List<List<Cell>>?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<List<Cell>>? create(Ref ref) {
    return grid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<Cell>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<Cell>>?>(value),
    );
  }
}

String _$gridHash() => r'21f813e4109eb6a5b85502c482d5c89976158807';

@ProviderFor(turnCount)
const turnCountProvider = TurnCountProvider._();

final class TurnCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TurnCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'turnCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$turnCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return turnCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$turnCountHash() => r'9e99a95e1fb13a27510b61004b3e11bedc37aad2';

@ProviderFor(totalMoves)
const totalMovesProvider = TotalMovesProvider._();

final class TotalMovesProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TotalMovesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalMovesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalMovesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalMoves(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalMovesHash() => r'23762904a98cf035ea1f336adecc9e8cc271dc37';
