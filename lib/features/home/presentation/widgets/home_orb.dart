import 'dart:async';
import 'dart:math' as math;

import 'package:chain_reaction/core/theme/providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The pulsing orb displayed on the home screen.
///
/// This widget uses constraint-based sizing to adapt to available space,
/// ensuring it renders correctly in split-screen and resizable windows.
class HomeOrb extends ConsumerStatefulWidget {
  const HomeOrb({super.key});

  @override
  ConsumerState<HomeOrb> createState() => _HomeOrbState();
}

class _HomeOrbState extends ConsumerState<HomeOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbController;
  late final Animation<double> _orbScaleAnimation;
  late final Animation<double> _orbOpacityAnimation;

  // Sizing constants as ratios for constraint-based layout
  static const double _minOrbSize = 80;
  static const double _maxOrbSize = 200;
  static const double _orbSizeFactor = 0.5; // 50% of available space

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    unawaited(_orbController.repeat(reverse: true));

    _orbScaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _orbController, curve: Curves.easeInOut));

    _orbOpacityAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: _orbController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate orb size based on available constraints
        final availableSize = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final orbSize = (availableSize * _orbSizeFactor).clamp(
          _minOrbSize,
          _maxOrbSize,
        );

        // Scale inner elements proportionally
        final innerRingSize = orbSize * 0.5; // 50% of orb
        final coreSize = orbSize * 0.375; // 37.5% of orb
        final highlightSize = orbSize * 0.075; // 7.5% of orb
        final borderWidth = orbSize * 0.1; // 10% of orb
        final innerBorderWidth = orbSize * 0.025; // 2.5% of orb

        final Widget orbContent = Container(
          width: orbSize,
          height: orbSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.fg.withValues(alpha: 0.1),
              width: borderWidth,
            ),
          ),
          child: Center(
            child: Container(
              width: innerRingSize,
              height: innerRingSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: innerRingSize,
                    height: innerRingSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.fg.withValues(alpha: 0.1),
                        width: innerBorderWidth,
                      ),
                    ),
                  ),
                  Container(
                    width: coreSize,
                    height: coreSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.fg.withValues(alpha: 0.9),
                      boxShadow: [
                        BoxShadow(
                          color: theme.fg.withValues(alpha: 0.2),
                          blurRadius: orbSize * 0.0625,
                          spreadRadius: orbSize * 0.0125,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: innerRingSize * 0.25,
                    left: innerRingSize * 0.25,
                    child: Container(
                      width: highlightSize,
                      height: highlightSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.subtitle.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        return FadeTransition(
          opacity: _orbOpacityAnimation,
          child: ScaleTransition(
            scale: _orbScaleAnimation,
            child: orbContent,
          ),
        );
      },
    );
  }
}
