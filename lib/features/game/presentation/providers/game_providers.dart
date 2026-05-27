import 'package:chain_reaction/core/services/haptic/haptic_service.dart';
import 'package:chain_reaction/features/game/domain/ai/ai_service.dart';
import 'package:chain_reaction/features/game/domain/logic/game_rules.dart';
import 'package:chain_reaction/features/game/domain/repositories/game_repository.dart';
import 'package:chain_reaction/features/game/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Logic Providers ---

final gameRulesProvider = Provider<GameRules>((ref) {
  return const GameRules();
});

// --- Repository Providers ---

/// Provider for the GameRepository.
///
/// This provider throws an [UnimplementedError] by default.
/// It MUST be overridden in the root [ProviderScope] with a valid implementation.
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  throw UnimplementedError('gameRepositoryProvider must be overridden');
});

// --- Service Providers ---

/// Provider for the AIService.
final aiServiceProvider = Provider<AIService>((ref) {
  final rules = ref.watch(gameRulesProvider);
  return AIService(rules);
});

/// Provider for the HapticService.
final hapticServiceProvider = Provider<HapticService>((ref) {
  return HapticService();
});

// --- UseCase Providers ---

/// Provider for the PlaceAtomUseCase.
final placeAtomUseCaseProvider = Provider<PlaceAtomUseCase>((ref) {
  final rules = ref.watch(gameRulesProvider);
  return PlaceAtomUseCase(rules);
});
