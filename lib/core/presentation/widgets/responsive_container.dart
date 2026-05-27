import 'package:flutter/material.dart';

/// A wrapper widget that centers content and limits its width on larger screens.
///
/// Use this as the root of your Screen's body to prevent UI elements
/// from stretching uncomfortably wide on Desktop/Tablets.
///
/// This container uses [LayoutBuilder] internally to ensure constraints
/// are properly propagated to children.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    super.key,
    this.maxWidth = 600.0,
  });

  /// The child widget to constrain.
  final Widget child;

  /// Maximum width for the content (default: 600).
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              // Preserve height constraints for proper layout
              maxHeight: constraints.maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
