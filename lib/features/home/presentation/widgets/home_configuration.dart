import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/game_selector.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/features/home/presentation/providers/home_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:chain_reaction/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeConfiguration extends ConsumerWidget {
  const HomeConfiguration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final isVsComputer = state.selectedMode == GameMode.vsComputer;

    return Column(
      key: const ValueKey('Configuration'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isVsComputer)
          GameSelector(
            label: 'DIFFICULTY',
            value: state.difficultyLabel,
            onPrevious: () => notifier.cycleDifficulty(forward: false),
            onNext: () => notifier.cycleDifficulty(forward: true),
          )
        else
          GameSelector(
            label: l10n.playersLabel,
            value: state.playerCount.toString(),
            onPrevious: notifier.decrementPlayers,
            onNext: notifier.incrementPlayers,
          ),
        const SizedBox(height: AppDimensions.paddingXL),
        GameSelector(
          label: l10n.gridSizeLabel,
          value: _getLocalizedGridSize(context, state.currentGridSize),
          onPrevious: () => notifier.cycleGridSize(forward: false),
          onNext: () => notifier.cycleGridSize(forward: true),
        ),
        const SizedBox(height: AppDimensions.paddingXXL),
        PillButton(
          text: l10n.startGame,
          onTap: () {
            final players = isVsComputer ? 2 : state.playerCount;
            unawaited(
              context.pushNamed(
                AppRouteNames.game,
                extra: {
                  'playerCount': players,
                  'gridSize': state.currentGridSize,
                  'aiDifficulty': isVsComputer ? state.aiDifficulty : null,
                },
              ),
            );
          },
          width: double.infinity,
          type: PillButtonType.primary,
        ),
      ],
    );
  }

  String _getLocalizedGridSize(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'x_small':
        return l10n.gridSizeXSmall;
      case 'small':
        return l10n.gridSizeSmall;
      case 'medium':
        return l10n.gridSizeMedium;
      case 'large':
        return l10n.gridSizeLarge;
      case 'x_large':
        return l10n.gridSizeXLarge;
      default:
        return key;
    }
  }
}
