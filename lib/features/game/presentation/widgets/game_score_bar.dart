import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/features/game/domain/entities/game_state.dart';
import 'package:flutter/material.dart';

class GameScoreBar extends StatelessWidget {
  const GameScoreBar({
    required this.gameState,
    required this.foregroundColor,
    super.key,
  });

  final GameState gameState;
  final Color foregroundColor;

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
          index: index,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AnimatedScoreTrack(
          segments: segments,
          occupiedSquares: occupiedSquares,
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
    required this.index,
  });

  final Color color;
  final int count;
  final int index;
}

class _AnimatedScoreTrack extends StatefulWidget {
  const _AnimatedScoreTrack({
    required this.segments,
    required this.occupiedSquares,
  });

  final List<_ScoreSegmentData> segments;
  final int occupiedSquares;

  @override
  State<_AnimatedScoreTrack> createState() => _AnimatedScoreTrackState();
}

class _AnimatedScoreTrackState extends State<_AnimatedScoreTrack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_ScoreSegmentLayout> _startLayouts;
  late List<_ScoreSegmentLayout> _targetLayouts;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    )..value = 1;
    _targetLayouts = _layoutsFor(widget.segments, widget.occupiedSquares);
    _startLayouts = _targetLayouts;
  }

  @override
  void didUpdateWidget(covariant _AnimatedScoreTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextLayouts = _layoutsFor(widget.segments, widget.occupiedSquares);
    if (_sameLayouts(_targetLayouts, nextLayouts)) return;

    _startLayouts = _currentLayouts;
    _targetLayouts = nextLayouts;
    unawaited(_controller.forward(from: 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_ScoreSegmentLayout> get _currentLayouts {
    final curvedValue = Curves.easeOutCubic.transform(_controller.value);
    return [
      for (var index = 0; index < _targetLayouts.length; index++)
        _ScoreSegmentLayout.lerp(
          index < _startLayouts.length
              ? _startLayouts[index]
              : _targetLayouts[index].collapsed,
          _targetLayouts[index],
          curvedValue,
        ),
    ];
  }

  List<_ScoreSegmentLayout> _layoutsFor(
    List<_ScoreSegmentData> segments,
    int occupiedSquares,
  ) {
    var leadingCount = 0;
    return [
      for (final segment in segments)
        () {
          final start = leadingCount / occupiedSquares;
          leadingCount += segment.count;
          final end = leadingCount / occupiedSquares;
          return _ScoreSegmentLayout(
            color: segment.color,
            count: segment.count,
            index: segment.index,
            start: start,
            end: end,
          );
        }(),
    ];
  }

  bool _sameLayouts(
    List<_ScoreSegmentLayout> previous,
    List<_ScoreSegmentLayout> next,
  ) {
    if (previous.length != next.length) return false;
    for (var index = 0; index < previous.length; index++) {
      if (previous[index] != next[index]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final layouts = _currentLayouts;
              final slots = _ScoreSegmentSlot.fromLayouts(
                layouts,
                constraints.maxWidth,
                MediaQuery.devicePixelRatioOf(context),
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    for (final slot in slots)
                      Positioned(
                        left: slot.left,
                        width: slot.width,
                        top: 0,
                        bottom: 0,
                        child: RepaintBoundary(
                          child: ColoredBox(
                            color: slot.layout.color,
                            child: Semantics(
                              label: '${slot.layout.count} squares',
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.paddingXS,
                                    ),
                                    child: Text(
                                      '${slot.layout.count}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: slot.layout.textColor,
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
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

@immutable
class _ScoreSegmentLayout {
  const _ScoreSegmentLayout({
    required this.color,
    required this.count,
    required this.index,
    required this.start,
    required this.end,
  });

  _ScoreSegmentLayout.lerp(
    _ScoreSegmentLayout begin,
    _ScoreSegmentLayout end,
    double t,
  ) : color = end.color,
      count = end.count,
      index = end.index,
      start = _lerpDouble(begin.start, end.start, t),
      end = _lerpDouble(begin.end, end.end, t);

  final Color color;
  final int count;
  final int index;
  final double start;
  final double end;

  double get width => end - start;

  Color get textColor =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
      ? Colors.black
      : Colors.white;

  _ScoreSegmentLayout get collapsed => _ScoreSegmentLayout(
    color: color,
    count: count,
    index: index,
    start: start,
    end: start,
  );

  static double _lerpDouble(double begin, double end, double t) {
    return begin + (end - begin) * t;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ScoreSegmentLayout &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          count == other.count &&
          index == other.index &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(color, count, index, start, end);
}

@immutable
class _ScoreSegmentSlot {
  const _ScoreSegmentSlot({
    required this.layout,
    required this.left,
    required this.right,
  });

  final _ScoreSegmentLayout layout;
  final double left;
  final double right;

  double get width => right - left;

  static List<_ScoreSegmentSlot> fromLayouts(
    List<_ScoreSegmentLayout> layouts,
    double trackWidth,
    double devicePixelRatio,
  ) {
    final visibleLayouts = layouts
        .where((layout) => layout.count > 0 && layout.width > 0)
        .toList();
    var nextLeft = 0.0;
    final slots = <_ScoreSegmentSlot>[];

    for (var index = 0; index < visibleLayouts.length; index++) {
      final layout = visibleLayouts[index];
      final right = index == visibleLayouts.length - 1
          ? trackWidth
          : _snapToPhysicalPixel(trackWidth * layout.end, devicePixelRatio);
      final clampedRight = right.clamp(nextLeft, trackWidth);

      if (clampedRight > nextLeft) {
        slots.add(
          _ScoreSegmentSlot(
            layout: layout,
            left: nextLeft,
            right: clampedRight,
          ),
        );
      }
      nextLeft = clampedRight;
    }

    return slots;
  }

  static double _snapToPhysicalPixel(double value, double devicePixelRatio) {
    return (value * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }
}
