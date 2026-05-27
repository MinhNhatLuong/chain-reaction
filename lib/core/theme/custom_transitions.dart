import 'package:flutter/material.dart';

/// A [PageTransitionsBuilder] that provides a smooth fade and subtle scale transition.
class FluidFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FluidFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeIn,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Show opaque background ONLY when pushing (forward).
        // When popping (reverse), we want transparency to see the underlying page.
        final showBackground =
            animation.status == AnimationStatus.forward ||
            animation.status == AnimationStatus.completed;

        return Stack(
          fit: StackFit.passthrough,
          children: [
            if (showBackground)
              Container(color: Theme.of(context).scaffoldBackgroundColor),
            FadeTransition(
              opacity: curve,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1).animate(curve),
                child: child,
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}
