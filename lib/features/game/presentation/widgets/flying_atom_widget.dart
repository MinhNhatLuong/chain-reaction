import 'package:chain_reaction/features/game/domain/entities/flying_atom.dart';
import 'package:flutter/material.dart';

class FlyingAtomWidget extends StatefulWidget {
  const FlyingAtomWidget({
    required this.atom,
    required this.cellSize,
    super.key,
    this.duration = const Duration(milliseconds: 250),
  });
  final FlyingAtom atom;
  final Size cellSize;
  final Duration duration;

  @override
  State<FlyingAtomWidget> createState() => _FlyingAtomWidgetState();
}

class _FlyingAtomWidgetState extends State<FlyingAtomWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;

  /// Base reference cell size for scaling calculations.
  static const double _referenceCellSize = 60;

  /// Base orb size at reference cell size.
  static const double _baseOrbSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Convert grid coordinates to relative offsets
    // This assumes the widget is placed in a Stack covering the grid
    final startOffset = Offset(
      widget.atom.fromX * widget.cellSize.width,
      widget.atom.fromY * widget.cellSize.height,
    );

    final endOffset = Offset(
      widget.atom.toX * widget.cellSize.width,
      widget.atom.toY * widget.cellSize.height,
    );

    _positionAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().ignore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate orb size based on cell size (same scaling as AtomPainter)
    final smallerDimension = widget.cellSize.width < widget.cellSize.height
        ? widget.cellSize.width
        : widget.cellSize.height;
    final scaleFactor = (smallerDimension / _referenceCellSize).clamp(0.5, 2.0);
    final orbSize = _baseOrbSize * scaleFactor;
    final blurRadius = 8.0 * scaleFactor;

    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          width: widget.cellSize.width,
          height: widget.cellSize.height,
          child: Center(child: child),
        );
      },
      child: Container(
        width: orbSize,
        height: orbSize,
        decoration: BoxDecoration(
          color: Color(widget.atom.color),
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(widget.atom.color),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(widget.atom.color).withValues(alpha: 0.4),
              blurRadius: blurRadius,
              spreadRadius: 1,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/ImageA.jpg',
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.48),
        ),
      ),
    );
  }
}
