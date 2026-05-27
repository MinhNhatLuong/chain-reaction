import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.freezed.dart';
part 'home_provider.g.dart';

enum HomeStep { modeSelection, configuration }

enum GameMode { localMultiplayer, vsComputer }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required HomeStep currentStep,
    required GameMode selectedMode,
    required int playerCount,
    required AIDifficulty aiDifficulty,
    required int gridSizeIndex,
    required List<String> gridSizes,
  }) = _HomeState;
  const HomeState._();

  factory HomeState.initial() {
    return const HomeState(
      currentStep: HomeStep.modeSelection,
      selectedMode: GameMode.localMultiplayer,
      playerCount: 2,
      aiDifficulty: AIDifficulty.medium,
      gridSizeIndex: 2,
      gridSizes: ['x_small', 'small', 'medium', 'large', 'x_large'],
    );
  }

  String get currentGridSize => gridSizes[gridSizeIndex];

  String get difficultyLabel {
    switch (aiDifficulty) {
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

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return HomeState.initial();
  }

  void setStep(HomeStep step) {
    state = state.copyWith(currentStep: step);
  }

  void toggleMode() {
    final newMode = state.selectedMode == GameMode.localMultiplayer
        ? GameMode.vsComputer
        : GameMode.localMultiplayer;
    state = state.copyWith(selectedMode: newMode);
  }

  void incrementPlayers() {
    if (state.playerCount < 8) {
      state = state.copyWith(playerCount: state.playerCount + 1);
    }
  }

  void decrementPlayers() {
    if (state.playerCount > 2) {
      state = state.copyWith(playerCount: state.playerCount - 1);
    }
  }

  void checkPlayerCountForMode() {
    // Ensure player count is valid for mode if needed, e.g. vsComputer implies specific setup
  }

  void cycleDifficulty({required bool forward}) {
    const values = AIDifficulty.values;
    final currentIndex = values.indexOf(state.aiDifficulty);
    final nextIndex = forward
        ? (currentIndex + 1) % values.length
        : (currentIndex - 1 + values.length) % values.length;
    state = state.copyWith(aiDifficulty: values[nextIndex]);
  }

  void cycleGridSize({required bool forward}) {
    final nextIndex = forward
        ? (state.gridSizeIndex + 1) % state.gridSizes.length
        : (state.gridSizeIndex - 1 + state.gridSizes.length) %
              state.gridSizes.length;
    state = state.copyWith(gridSizeIndex: nextIndex);
  }
}
