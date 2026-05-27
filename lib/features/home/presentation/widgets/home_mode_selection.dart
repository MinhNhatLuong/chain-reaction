import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/game_selector.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/features/home/presentation/providers/home_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeModeSelection extends ConsumerWidget {
  const HomeModeSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      key: const ValueKey('ModeSelection'),
      mainAxisSize: MainAxisSize.min,
      children: [
        GameSelector(
          label: l10n.gameModeLabel,
          value: state.selectedMode == GameMode.localMultiplayer
              ? l10n.localMultiplayer
              : l10n.vsComputer,
          onPrevious: notifier.toggleMode,
          onNext: notifier.toggleMode,
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        // Invisible GameSelector placeholder to match HomeConfiguration exactly
        IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: GameSelector(
              label: l10n.gridSizeLabel,
              value: 'Medium',
              onPrevious: () {},
              onNext: () {},
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXXL),
        PillButton(
          text: l10n.next,
          onTap: () => notifier.setStep(HomeStep.configuration),
          width: double.infinity,
        ),
      ],
    );
  }
}
