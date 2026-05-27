import 'package:chain_reaction/core/constants/breakpoints.dart';
import 'package:flutter/material.dart';

/// Abstract base class for constraint-aware widgets.
///
/// Enforces the layout contract: every widget must render correctly under
/// arbitrary width/height constraints. Use this as the base for top-level
/// screens and complex layout widgets.
abstract class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({super.key});

  /// Builds the widget with access to constraints and computed breakpoint.
  ///
  /// The [constraints] parameter provides the available space for this widget.
  /// The [breakpoint] parameter is pre-computed from `constraints.maxWidth`.
  Widget buildForConstraints(
    BuildContext context,
    BoxConstraints constraints,
    Breakpoint breakpoint,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);
        return buildForConstraints(context, constraints, breakpoint);
      },
    );
  }
}

/// A simpler version of [ResponsiveWidget] that only provides breakpoint.
///
/// Use when you don't need raw constraints but still need breakpoint-based
/// layout switching.
abstract class BreakpointWidget extends StatelessWidget {
  const BreakpointWidget({super.key});

  /// Builds the widget based on the current breakpoint.
  Widget buildForBreakpoint(BuildContext context, Breakpoint breakpoint);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);
        return buildForBreakpoint(context, breakpoint);
      },
    );
  }
}
