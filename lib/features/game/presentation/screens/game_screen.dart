import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/game_menu_dialog.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/core/utils/fluid_dialog.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/presentation/providers/providers.dart';
import 'package:chain_reaction/features/game/presentation/widgets/widgets.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:chain_reaction/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    super.key,
    this.playerCount,
    this.gridSize,
    this.aiDifficulty,
    this.isResuming = false,
  });
  final int? playerCount;
  final String? gridSize;
  final AIDifficulty? aiDifficulty;
  final bool isResuming;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize game after first frame to ensure providers are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isResuming) {
        unawaited(_resumeGame());
      } else {
        _initializeGame();
      }
    });
  }

  Future<void> _resumeGame() async {
    final didLoad = await ref.read(gameProvider.notifier).loadSavedGame();
    if (!mounted || didLoad) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.noSavedGameFound)),
    );
    context.goNamed(AppRouteNames.home);
  }

  void _initializeGame() {
    if (widget.playerCount == null) return;

    final playerNames = ref.read(playerNamesProvider);
    final themeState = ref.read(themeProvider);
    final playerColors = themeState.playerColors;

    final players = List.generate(widget.playerCount!, (index) {
      final playerIndex = index + 1;
      // If AI mode is active (difficulty != null), Player 2 is AI
      final isAI = widget.aiDifficulty != null && index == 1;

      return Player(
        id: 'player_$playerIndex',
        name: isAI ? 'Computer' : playerNames.getName(playerIndex),
        color: playerColors[index % playerColors.length].toARGB32(),
        type: isAI ? PlayerType.ai : PlayerType.human,
        difficulty: isAI ? widget.aiDifficulty : null,
      );
    });

    ref
        .read(gameProvider.notifier)
        .initGame(players, gridSize: widget.gridSize);
  }

  void _handleCellTap(int x, int y) {
    final gameState = ref.read(gameProvider);
    // Block input if game is processing (AI is thinking or chain reaction happening)
    if (gameState == null ||
        gameState.isProcessing ||
        gameState.currentPlayer.isAI) {
      return;
    }

    if (!ref.read(gameProvider.notifier).isValidMove(x, y)) return;

    // Sound/Haptics now handled by Notifier
    ref.read(gameProvider.notifier).placeAtom(x, y);
  }

  @override
  Widget build(BuildContext context) {
    _listenForGameEnd();

    final gameState = ref.watch(gameProvider);
    final themeState = ref.watch(themeProvider);

    // Show loading if game not initialized yet
    if (gameState == null) {
      return Scaffold(
        backgroundColor: themeState.bg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentPlayer = gameState.currentPlayer;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (didPop) return;
        _showMenuDialog(context, gameState);
      },
      child: ColoredBox(
        color: themeState.bg,
        child: ResponsiveContainer(
          child: Scaffold(
            backgroundColor: themeState.bg,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.menu, color: themeState.fg),
                onPressed: () => _showMenuDialog(context, gameState),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppDimensions.playerIndicatorSize,
                    height: AppDimensions.playerIndicatorSize,
                    decoration: BoxDecoration(
                      color: Color(currentPlayer.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Text(
                    currentPlayer.isAI
                        ? AppLocalizations.of(context)!.computerThinking
                        : currentPlayer.name,
                    style: TextStyle(
                      color: Color(currentPlayer.color),
                      fontSize: AppDimensions.fontL,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                if (gameState.isProcessing)
                  const SizedBox(
                    width: AppDimensions.actionButtonSize,
                    height: AppDimensions.actionButtonSize,
                    child: Center(
                      child: SizedBox(
                        width: AppDimensions.iconM,
                        height: AppDimensions.iconM,
                        child: CircularProgressIndicator(
                          strokeWidth: AppDimensions.loaderStrokeWidth,
                        ),
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.undo),
                    color: themeState.fg,
                    onPressed: ref.read(gameProvider.notifier).canUndo
                        ? () => ref.read(gameProvider.notifier).undo()
                        : null,
                  ),
                const SizedBox(width: AppDimensions.paddingS),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.gridPadding),
                child: RepaintBoundary(
                  child: GameGrid(onCellTap: _handleCellTap),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listenForGameEnd() {
    ref.listen(gameProvider, (previous, next) {
      if (next != null && next.isGameOver && next.winner != null) {
        final winnerIndex = next.players.indexOf(next.winner!) + 1;

        // Use addPostFrameCallback to avoid navigation during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            // Determine difficulty from state if resuming
            final aiPlayer = next.players.any((p) => p.isAI)
                ? next.players.firstWhere((p) => p.isAI)
                : null;

            context.pushReplacementNamed(
              AppRouteNames.winner,
              extra: {
                'winnerPlayerIndex': winnerIndex,
                'winnerName': next.winner!.name,
                'totalMoves': next.totalMoves,
                'gameDuration': next.formattedDuration,
                'territoryPercentage': next.territoryPercentage,
                'playerCount': next.players.length,
                'gridSize':
                    widget.gridSize ??
                    AppLocalizations.of(context)!.unknownGrid,
                'aiDifficulty': widget.aiDifficulty ?? aiPlayer?.difficulty,
              },
            );
          }
        });
      }
    });
  }

  void _showMenuDialog(BuildContext context, GameState gameState) {
    // Determine difficulty from state if resuming
    final aiPlayer = gameState.players.any((p) => p.isAI)
        ? gameState.players.firstWhere((p) => p.isAI)
        : null;

    unawaited(
      showFluidDialog<void>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.8),
        builder: (context) => GameMenuDialog(
          playerCount: gameState.players.length,
          gridSize: widget.gridSize ?? 'medium',
          aiDifficulty: widget.aiDifficulty ?? aiPlayer?.difficulty,
        ),
      ),
    );
  }
}
