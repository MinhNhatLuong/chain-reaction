import 'package:chain_reaction/features/game/presentation/widgets/atom_painter.dart';
import 'package:chain_reaction/features/settings/presentation/providers/custom_atom_images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the atoms within a cell using CustomPainter for performance.
///
/// This widget is purely stateless and driven by the [animation] passed from above.
/// All drawing logic is handled by [AtomPainter].
class AtomWidget extends ConsumerWidget {
  const AtomWidget({
    required this.color,
    required this.count,
    required this.animation,
    required this.cellSize,
    super.key,
    this.angleOffset = 0.0,
    this.isUnstable = false,
    this.isCritical = false,
    this.isAtomRotationOn = true,
    this.isAtomVibrationOn = true,
    this.isAtomBreathingOn = true,
  });
  final Color color;
  final int count;
  final bool isUnstable;
  final bool isCritical;
  final bool isAtomRotationOn;
  final bool isAtomVibrationOn;
  final bool isAtomBreathingOn;
  final Animation<double> animation;
  final double angleOffset;

  /// The size of the cell containing this atom.
  /// Atoms scale proportionally to cell size.
  final double cellSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (color == Colors.transparent || count == 0) {
      return const SizedBox();
    }

    final atomImages = ref.watch(customAtomUiImagesProvider).asData?.value;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return RepaintBoundary(
          child: CustomPaint(
            size: Size(cellSize, cellSize),
            painter: AtomPainter(
              color: color,
              count: count,
              atomImages: atomImages,
              isUnstable: isUnstable,
              isCritical: isCritical,
              isRotationOn: isAtomRotationOn,
              isVibrationOn: isAtomVibrationOn,
              isBreathingOn: isAtomBreathingOn,
              animationValue: animation.value,
              angleOffset: angleOffset,
              cellSize: cellSize,
            ),
          ),
        );
      },
    );
  }
}
