import 'package:chain_reaction/core/constants/breakpoints.dart';
import 'package:flutter/material.dart';

/// Responsive theme utilities for breakpoint-aware styling.
///
/// Provides typography scaling and density adjustments based on the current
/// breakpoint, ensuring text remains readable across all device sizes.

/// Returns a scaled [TextTheme] based on the current [breakpoint].
///
/// Typography scales slightly smaller on mobile and slightly larger on
/// desktop to maintain optimal readability:
/// - xs: 0.95x (slightly smaller for compact displays)
/// - sm: 1.0x (baseline)
/// - md: 1.05x (slightly larger for tablet viewing distance)
/// - lg: 1.08x (comfortable desktop reading)
/// - xl: 1.1x (large desktop displays)
///
/// Example usage with LayoutBuilder:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     final bp = breakpointForWidth(constraints.maxWidth);
///     final scaledTheme = responsiveTextTheme(
///       Theme.of(context).textTheme,
///       bp,
///     );
///     // Use scaledTheme for text styling
///   },
/// )
/// ```
TextTheme responsiveTextTheme(TextTheme base, Breakpoint breakpoint) {
  final scale = switch (breakpoint) {
    Breakpoint.xs => 0.95,
    Breakpoint.sm => 1.0,
    Breakpoint.md => 1.05,
    Breakpoint.lg => 1.08,
    Breakpoint.xl => 1.1,
  };
  return base.apply(fontSizeFactor: scale);
}

/// Returns the font size scaling factor for the given [breakpoint].
///
/// Can be used for manual font size calculations when not using [TextTheme].
double fontScaleForBreakpoint(Breakpoint breakpoint) => switch (breakpoint) {
  Breakpoint.xs => 0.95,
  Breakpoint.sm => 1.0,
  Breakpoint.md => 1.05,
  Breakpoint.lg => 1.08,
  Breakpoint.xl => 1.1,
};

/// Returns the icon size scaling factor for the given [breakpoint].
///
/// Icons scale slightly more aggressively than text for visibility.
double iconScaleForBreakpoint(Breakpoint breakpoint) => switch (breakpoint) {
  Breakpoint.xs => 1.0,
  Breakpoint.sm => 1.0,
  Breakpoint.md => 1.1,
  Breakpoint.lg => 1.15,
  Breakpoint.xl => 1.2,
};

/// Returns the minimum touch target size for the given [breakpoint].
///
/// Touch targets must be at least 48dp for accessibility, but can be
/// smaller on desktop where mouse precision is available.
double minTouchTargetForBreakpoint(Breakpoint breakpoint) =>
    switch (breakpoint) {
      Breakpoint.xs => 48.0,
      Breakpoint.sm => 48.0,
      Breakpoint.md => 44.0, // Mixed touch/mouse
      Breakpoint.lg => 40.0, // Primarily mouse
      Breakpoint.xl => 40.0,
    };
