import 'dart:ui' as ui;

import 'package:chain_reaction/features/game/presentation/widgets/atom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Renders the atoms within a cell using CustomPainter for performance.
///
/// This widget is purely stateless and driven by the [animation] passed from above.
/// All drawing logic is handled by [AtomPainter].
class AtomWidget extends StatelessWidget {
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

  static final Future<List<ui.Image>> _atomImages = _loadAtomImages();

  static Future<List<ui.Image>> _loadAtomImages() async {
    const imagePaths = [
      'assets/ImageA.jpg',
      'assets/ImageB.jpg',
      'assets/ImageC.jpg',
    ];
    return Future.wait(imagePaths.map(_loadAssetImage));
  }

  static Future<ui.Image> _loadAssetImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      return frame.image;
    } finally {
      codec.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (color == Colors.transparent || count == 0) {
      return const SizedBox();
    }

    return FutureBuilder<List<ui.Image>>(
      future: _atomImages,
      builder: (context, snapshot) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return RepaintBoundary(
              child: CustomPaint(
                size: Size(cellSize, cellSize),
                painter: AtomPainter(
                  color: color,
                  count: count,
                  atomImages: snapshot.data,
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
      },
    );
  }
}
