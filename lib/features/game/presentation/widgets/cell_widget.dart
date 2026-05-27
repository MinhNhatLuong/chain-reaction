import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/features/game/domain/entities/cell.dart';
import 'package:chain_reaction/features/game/presentation/widgets/atom_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Renders a single cell in the game grid.
class CellWidget extends StatelessWidget {
  const CellWidget({
    required this.cell,
    required this.borderColor,
    required this.cellColor,
    required this.onTap,
    required this.animation,
    super.key,
    this.angleOffset = 0.0,
    this.isAtomRotationOn = true,
    this.isAtomVibrationOn = true,
    this.isAtomBreathingOn = true,
    this.isCellHighlightOn = true,
    this.isKeyboardSelected = false,
    this.semanticLabel,
    this.semanticHint,
  });
  final Cell cell;
  final Color borderColor;
  final Color cellColor;
  final VoidCallback onTap;
  final bool isAtomRotationOn;
  final bool isAtomVibrationOn;
  final bool isAtomBreathingOn;
  final bool isCellHighlightOn;
  final bool isKeyboardSelected;
  final Animation<double> animation;
  final double angleOffset;
  final String? semanticLabel;
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    // A cell is unstable (wobbling/spinning fast) only if it's overflowing (exploding)
    // This keeps full cells (Critical Mass) running at the stable speed
    final isUnstable = cell.atomCount > cell.capacity;
    final isCritical = cell.atomCount == cell.capacity;
    final effectiveBorderColor = isKeyboardSelected
        ? borderColor
        : borderColor.withValues(alpha: AppDimensions.gridBorderOpacity);
    final effectiveBorderWidth = isKeyboardSelected
        ? AppDimensions.gridBorderWidth * 2
        : AppDimensions.gridBorderWidth;

    return Expanded(
      child: Semantics(
        button: true,
        label: semanticLabel,
        hint: semanticHint,
        child: Material(
          color: Colors.transparent,
          child: Builder(
            builder: (context) {
              final isMobile =
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

              final childContainer = LayoutBuilder(
                builder: (context, constraints) {
                  // Use the smaller dimension for atom sizing
                  final cellSize = constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight;

                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: AppDimensions.cellAnimationDurationMs,
                    ),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: (isCellHighlightOn && cell.ownerId != null)
                          ? cellColor.withValues(
                              alpha: AppDimensions.cellHighlightOpacity,
                            )
                          : Colors.transparent,
                      border: Border.all(
                        color: effectiveBorderColor,
                        width: effectiveBorderWidth,
                      ),
                    ),
                    child: Center(
                      child: AtomWidget(
                        color: cellColor,
                        // Visually cap the atoms to capacity to prevent "overloaded" shapes
                        // (e.g. 4 atoms in a 3-capacity cell) from appearing briefly before explosion.
                        count: cell.atomCount > cell.capacity
                            ? cell.capacity
                            : cell.atomCount,
                        isUnstable: isUnstable,
                        isCritical: isCritical,
                        isAtomRotationOn: isAtomRotationOn,
                        isAtomVibrationOn: isAtomVibrationOn,
                        isAtomBreathingOn: isAtomBreathingOn,
                        animation: animation,
                        angleOffset: angleOffset,
                        cellSize: cellSize,
                      ),
                    ),
                  );
                },
              );

              if (isMobile) {
                return GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: childContainer,
                );
              }

              return InkWell(
                onTap: onTap,
                hoverColor: borderColor.withValues(
                  alpha: AppDimensions.cellHoverOpacity,
                ),
                splashColor: borderColor.withValues(
                  alpha: AppDimensions.cellSplashOpacity,
                ),
                child: childContainer,
              );
            },
          ),
        ),
      ),
    );
  }
}
