import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:flutter/material.dart';

class GameScoreBar extends StatelessWidget {
  const GameScoreBar({
    required this.gameState,
    required this.foregroundColor,
    required this.borderColor,
    super.key,
  });

  final GameState gameState;
  final Color foregroundColor;
  final Color borderColor;

  int get _occupiedSquares {
    var count = 0;
    for (final player in gameState.players) {
      count += gameState.cellCountForPlayer(player.id);
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor.withValues(alpha: 0.45),
                width: AppDimensions.gridBorderWidth,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 34,
              child: Row(
                children: [
                  for (var index = 0; index < gameState.players.length; index++)
                    Expanded(
                      child: _ScoreSegment(
                        color: Color(gameState.players[index].color),
                        count: gameState.cellCountForPlayer(
                          gameState.players[index].id,
                        ),
                        isCurrent:
                            index == gameState.currentPlayerIndex &&
                            !gameState.isGameOver,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total Squares: $_occupiedSquares/${gameState.totalCells}',
            style: TextStyle(
              color: foregroundColor.withValues(alpha: 0.72),
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreSegment extends StatelessWidget {
  const _ScoreSegment({
    required this.color,
    required this.count,
    required this.isCurrent,
  });

  final Color color;
  final int count;
  final bool isCurrent;

  Color get _textColor {
    return color.computeLuminance() > 0.48 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: textColor.withValues(alpha: 0.32),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXS,
            ),
            child: Text(
              '$count',
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w800,
                height: 1,
                shadows: [
                  Shadow(
                    color:
                        (textColor == Colors.white
                                ? Colors.black
                                : Colors.white)
                            .withValues(alpha: 0.22),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
