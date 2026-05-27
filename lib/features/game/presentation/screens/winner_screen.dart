import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/presentation/providers/providers.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:chain_reaction/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WinnerScreen extends ConsumerWidget {
  const WinnerScreen({
    required this.playerCount,
    required this.gridSize,
    super.key,
    this.winnerPlayerIndex = 1,
    this.winnerName,
    this.totalMoves = 0,
    this.gameDuration = '00:00',
    this.territoryPercentage = 100,
    this.aiDifficulty,
  });
  final int winnerPlayerIndex;
  final String? winnerName;
  final int totalMoves;
  final String gameDuration;
  final int territoryPercentage;
  final int playerCount;
  final String gridSize;
  final AIDifficulty? aiDifficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final resolvedWinnerName =
        winnerName ?? ref.read(playerNamesProvider).getName(winnerPlayerIndex);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: ResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppDimensions.paddingXXL),
                        Text(
                          l10n.winner,
                          style: TextStyle(
                            color: theme.fg,
                            fontSize: AppDimensions.fontGiant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        // Winner circle - constraint-based sizing
                        LayoutBuilder(
                          builder: (context, circleConstraints) {
                            // Size as 20% of available width, clamped to 80-150
                            final circleSize =
                                (circleConstraints.maxWidth * 0.25).clamp(
                                  80.0,
                                  150.0,
                                );
                            return Container(
                              width: circleSize,
                              height: circleSize,
                              decoration: BoxDecoration(
                                color: theme.currentTheme.getPlayerColor(
                                  winnerPlayerIndex,
                                  isDark: theme.isDarkMode,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.currentTheme
                                      .getPlayerColor(
                                        winnerPlayerIndex,
                                        isDark: theme.isDarkMode,
                                      )
                                      .withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.paddingL),
                        Text(
                          resolvedWinnerName,
                          style: TextStyle(
                            color: theme.fg,
                            fontSize: AppDimensions.fontXXL,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.paddingXXXL),

                        _buildStatRow(
                          l10n.totalMoves,
                          totalMoves.toString(),
                          theme,
                        ),
                        const SizedBox(height: AppDimensions.paddingL),
                        _buildStatRow(l10n.duration, gameDuration, theme),
                        const SizedBox(height: AppDimensions.paddingL),
                        _buildStatRow(
                          l10n.territory,
                          '$territoryPercentage%',
                          theme,
                        ),

                        const SizedBox(height: AppDimensions.paddingXXXL),

                        PillButton(
                          text: l10n.playAgain,
                          onTap: () {
                            // Restart the game with the same configuration
                            context.pushReplacementNamed(
                              AppRouteNames.game,
                              extra: {
                                'playerCount': playerCount,
                                'gridSize': gridSize,
                                'aiDifficulty': aiDifficulty,
                              },
                            );
                          },
                          width: double.infinity,
                          type: PillButtonType.primary,
                        ),
                        const SizedBox(height: AppDimensions.paddingM),
                        PillButton(
                          text: l10n.mainMenu,
                          onTap: () {
                            context.goNamed(AppRouteNames.home);
                          },
                          width: double.infinity,
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, ThemeState theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.subtitle,
            fontSize: AppDimensions.fontL,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: theme.fg,
            fontSize: AppDimensions.fontXL,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
