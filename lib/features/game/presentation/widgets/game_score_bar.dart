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
    final occupiedSquares = _occupiedSquares;
    if (occupiedSquares == 0) return const SizedBox.shrink();
    final segments = [
      for (var index = 0; index < gameState.players.length; index++)
        _ScoreSegmentData(
          color: Color(gameState.players[index].color),
          count: gameState.cellCountForPlayer(gameState.players[index].id),
        ),
    ];

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var leadingRatio = 0.0;
                  final positionedSegments = <Widget>[];

                  for (final segment in segments) {
                    final ratio = segment.count / occupiedSquares;
                    positionedSegments.add(
                      _AnimatedScoreSegment(
                        color: segment.color,
                        count: segment.count,
                        left: constraints.maxWidth * leadingRatio,
                        width: constraints.maxWidth * ratio,
                      ),
                    );
                    leadingRatio += ratio;
                  }

                  return Stack(
                    fit: StackFit.expand,
                    children: positionedSegments,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total Squares: $occupiedSquares/${gameState.totalCells}',
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

class _ScoreSegmentData {
  const _ScoreSegmentData({
    required this.color,
    required this.count,
  });

  final Color color;
  final int count;
}

class _AnimatedScoreSegment extends StatelessWidget {
  const _AnimatedScoreSegment({
    required this.color,
    required this.count,
    required this.left,
    required this.width,
  });

  final Color color;
  final int count;
  final double left;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      left: left,
      width: width,
      top: 0,
      bottom: 0,
      child: Semantics(
        label: '$count squares',
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
