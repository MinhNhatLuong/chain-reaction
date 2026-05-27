import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Efficiently draws atoms on a canvas with dynamic sizing.
class AtomPainter extends CustomPainter {
  AtomPainter({
    required this.color,
    required this.count,
    required this.atomImages,
    required this.isUnstable,
    required this.isCritical,
    required this.isRotationOn,
    required this.isVibrationOn,
    required this.isBreathingOn,
    required this.animationValue,
    required this.angleOffset,
    required this.cellSize,
  }) : super(repaint: null);

  final Color color;
  final int count;
  final List<ui.Image>? atomImages;
  final bool isUnstable; // Exploding
  final bool isCritical; // Full
  final bool isRotationOn;
  final bool isVibrationOn;
  final bool isBreathingOn;
  final double animationValue; // 0.0 to 1.0 from master controller
  final double angleOffset; // 0.0 to 1.0 phase shift
  final double cellSize;

  /// Base reference cell size for scaling calculations.
  static const double _referenceCellSize = 60;

  /// Calculate scale factor relative to reference cell size.
  double get _scaleFactor => (cellSize / _referenceCellSize).clamp(0.5, 2.0);

  /// Scaled orb radius.
  double get _orbRadius => (AppDimensions.orbSizeSmall / 2) * _scaleFactor;

  @override
  void paint(Canvas canvas, Size size) {
    if (color == Colors.transparent || count == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = color;
    final imagePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.48)
      ..filterQuality = FilterQuality.medium;
    final outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (1.25 * _scaleFactor).clamp(0.75, 2.5);

    // 1. Calculate Rotation
    double rotationAngle = 0;
    if (isRotationOn && count > 1) {
      rotationAngle = (animationValue + angleOffset) * 2 * math.pi;
    }

    // 2. Calculate Vibration (scaled)
    double vibrateX = 0;
    double vibrateY = 0;
    if (isVibrationOn && (isCritical || isUnstable)) {
      final vVal = math.sin(
        animationValue * AppDimensions.atomVibrationFrequency * math.pi,
      );
      final amplitude = AppDimensions.atomVibrationAmplitude * _scaleFactor;
      vibrateX = vVal * amplitude;
      vibrateY = (1 - vVal.abs()) * amplitude * (vVal > 0 ? 1 : -1);
    }

    // Apply transformations
    canvas
      ..save()
      ..translate(center.dx + vibrateX, center.dy + vibrateY)
      ..rotate(rotationAngle);

    // Draw Shadows (scaled blur)
    final shadowPaint = Paint()
      ..color = color.withAlpha(
        ((color.a * 255.0).round().clamp(0, 255) *
                AppDimensions.atomShadowOpacity)
            .toInt(),
      )
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        AppDimensions.atomShadowBlur * _scaleFactor,
      );

    // 3. Organic Breathing (Simulated Physics)
    final breatheVal = math.sin(
      (animationValue + angleOffset) * 4 * math.pi,
    );
    final breathingFactor =
        1.0 + (breatheVal * AppDimensions.atomBreathingScaleBy);

    // Scaled spacing values
    final spacing2 = AppDimensions.atomSpacing2 * _scaleFactor;
    final spacing4 = AppDimensions.atomSpacing4 * _scaleFactor;
    final triangleTopY = AppDimensions.atomTriangleTopY * _scaleFactor;
    final triangleBottomX = AppDimensions.atomTriangleBottomX * _scaleFactor;
    final triangleBottomY = AppDimensions.atomTriangleBottomY * _scaleFactor;

    void drawAtom(Offset offset, int imageIndex) {
      _drawAtom(
        canvas,
        offset,
        imageIndex: imageIndex,
        paint: paint,
        shadowPaint: shadowPaint,
        outlinePaint: outlinePaint,
        imagePaint: imagePaint,
      );
    }

    // Draw based on count (Applying breathingFactor to spacing)
    switch (count) {
      case 1:
        drawAtom(Offset.zero, 0);
      case 2:
        final d = spacing2 * breathingFactor;
        drawAtom(Offset(-d, -d), 0);
        drawAtom(Offset(d, d), 1);
      case 3:
        final s = breathingFactor;
        drawAtom(Offset(0, -triangleTopY * s), 0);
        drawAtom(Offset(-triangleBottomX * s, triangleBottomY * s), 1);
        drawAtom(Offset(triangleBottomX * s, triangleBottomY * s), 2);
      case 4:
        final d4 = spacing4 * breathingFactor;
        drawAtom(Offset(0, -d4), 0);
        drawAtom(Offset(-d4, 0), 1);
        drawAtom(Offset(d4, 0), 2);
        drawAtom(Offset(0, d4), 0);
      default:
        if (count > 4) {
          final d4 = spacing4 * breathingFactor;
          drawAtom(Offset(0, -d4), 0);
          drawAtom(Offset(-d4, 0), 1);
          drawAtom(Offset(d4, 0), 2);
          drawAtom(Offset(0, d4), 0);
        }
    }

    canvas.restore();
  }

  void _drawAtom(
    Canvas canvas,
    Offset offset, {
    required int imageIndex,
    required Paint paint,
    required Paint shadowPaint,
    required Paint outlinePaint,
    required Paint imagePaint,
  }) {
    canvas
      ..drawCircle(offset, _orbRadius, shadowPaint)
      ..drawCircle(offset, _orbRadius, paint);

    final image = atomImages != null && imageIndex < atomImages!.length
        ? atomImages![imageIndex]
        : null;
    if (image == null) {
      canvas.drawCircle(offset, _orbRadius, paint);
      return;
    }

    final targetRect = Rect.fromCircle(center: offset, radius: _orbRadius);
    final sourceSide = math.min(image.width, image.height).toDouble();
    final sourceRect = Rect.fromLTWH(
      (image.width - sourceSide) / 2,
      (image.height - sourceSide) / 2,
      sourceSide,
      sourceSide,
    );

    canvas
      ..save()
      ..clipPath(Path()..addOval(targetRect))
      ..drawImageRect(image, sourceRect, targetRect, imagePaint)
      ..restore()
      ..drawCircle(offset, _orbRadius, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant AtomPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.count != count ||
        oldDelegate.atomImages != atomImages ||
        oldDelegate.isUnstable != isUnstable ||
        oldDelegate.isCritical != isCritical ||
        oldDelegate.isRotationOn != isRotationOn ||
        oldDelegate.isVibrationOn != isVibrationOn ||
        oldDelegate.isBreathingOn != isBreathingOn ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.angleOffset != angleOffset ||
        oldDelegate.cellSize != cellSize;
  }
}
