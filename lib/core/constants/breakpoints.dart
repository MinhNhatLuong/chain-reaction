/// Canonical breakpoints for responsive layout decisions.
///
/// These breakpoints define when UI structure should change, not just scale.
/// All layout decisions should flow through [breakpointForWidth].
enum Breakpoint {
  /// Extra small: < 600dp (phones, split-screen)
  xs,

  /// Small: 600–839dp (small tablets, large phones landscape)
  sm,

  /// Medium: 840–1199dp (tablets, small desktops)
  md,

  /// Large: 1200–1599dp (desktops)
  lg,

  /// Extra large: ≥ 1600dp (large desktops, ultra-wide)
  xl,
}

/// Returns the [Breakpoint] for the given [width] in logical pixels.
///
/// Use with `LayoutBuilder` constraints:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     final bp = breakpointForWidth(constraints.maxWidth);
///     // Layout decisions based on bp
///   },
/// )
/// ```
Breakpoint breakpointForWidth(double width) {
  if (width < 600) return Breakpoint.xs;
  if (width < 840) return Breakpoint.sm;
  if (width < 1200) return Breakpoint.md;
  if (width < 1600) return Breakpoint.lg;
  return Breakpoint.xl;
}

/// Extension methods for [Breakpoint] comparisons.
extension BreakpointX on Breakpoint {
  /// Returns true if this breakpoint is at least [other].
  bool operator >=(Breakpoint other) => index >= other.index;

  /// Returns true if this breakpoint is at most [other].
  bool operator <=(Breakpoint other) => index <= other.index;

  /// Returns true if this breakpoint is greater than [other].
  bool operator >(Breakpoint other) => index > other.index;

  /// Returns true if this breakpoint is less than [other].
  bool operator <(Breakpoint other) => index < other.index;

  /// Returns true if this is a mobile-sized breakpoint (xs or sm).
  bool get isMobile => this <= Breakpoint.sm;

  /// Returns true if this is a tablet-sized breakpoint (md).
  bool get isTablet => this == Breakpoint.md;

  /// Returns true if this is a desktop-sized breakpoint (lg or xl).
  bool get isDesktop => this >= Breakpoint.lg;
}

/// Layout-specific helper extensions for breakpoints.
///
/// These methods help determine structural layout decisions based on the
/// current breakpoint, following Phase 2 layout switching rules.
extension BreakpointLayoutX on Breakpoint {
  /// Returns true if navigation should use NavigationRail instead of bottom bar.
  ///
  /// NavigationRail is used for `md`, `lg`, and `xl` breakpoints.
  bool get usesRailNavigation => index >= Breakpoint.md.index;

  /// Returns true if layout can use two-pane (side-by-side) mode.
  ///
  /// Two-pane layouts are supported from `md` breakpoint onwards.
  bool get supportsTwoPaneLayout => index >= Breakpoint.md.index;

  /// Returns horizontal padding based on breakpoint.
  ///
  /// Larger screens get more generous padding for visual breathing room.
  double get horizontalPadding => switch (this) {
    Breakpoint.xs => 16.0,
    Breakpoint.sm => 24.0,
    Breakpoint.md => 32.0,
    Breakpoint.lg => 48.0,
    Breakpoint.xl => 64.0,
  };

  /// Returns content max-width for this breakpoint.
  ///
  /// Used to cap content width on larger screens to maintain readability.
  double? get contentMaxWidth => switch (this) {
    Breakpoint.xs => null,
    Breakpoint.sm => null,
    Breakpoint.md => 720.0,
    Breakpoint.lg => 960.0,
    Breakpoint.xl => 1200.0,
  };
}

/// Density control extensions for touch targets and spacing.
///
/// These values ensure proper touch target sizes on mobile while allowing
/// denser layouts on desktop where mouse precision is available.
extension BreakpointDensityX on Breakpoint {
  /// Minimum touch target size for accessibility.
  ///
  /// Mobile devices need larger targets (48dp), while desktop can use
  /// smaller targets (40dp) since mouse precision is available.
  double get minTouchTarget => switch (this) {
    Breakpoint.xs => 48.0,
    Breakpoint.sm => 48.0,
    Breakpoint.md => 44.0, // Mixed touch/mouse
    Breakpoint.lg => 40.0, // Primarily mouse
    Breakpoint.xl => 40.0,
  };

  /// Padding for list items based on breakpoint.
  ///
  /// Larger screens get more generous padding for visual breathing room.
  double get listItemPadding => switch (this) {
    Breakpoint.xs => 12.0,
    Breakpoint.sm => 14.0,
    Breakpoint.md => 16.0,
    Breakpoint.lg => 18.0,
    Breakpoint.xl => 20.0,
  };

  /// Spacing between items in a list or grid.
  double get itemSpacing => switch (this) {
    Breakpoint.xs => 8.0,
    Breakpoint.sm => 10.0,
    Breakpoint.md => 12.0,
    Breakpoint.lg => 14.0,
    Breakpoint.xl => 16.0,
  };

  /// Card elevation for depth perception.
  ///
  /// Desktop benefits from subtle shadows, mobile uses flatter design.
  double get cardElevation => switch (this) {
    Breakpoint.xs => 1.0,
    Breakpoint.sm => 1.0,
    Breakpoint.md => 2.0,
    Breakpoint.lg => 2.0,
    Breakpoint.xl => 3.0,
  };
}
