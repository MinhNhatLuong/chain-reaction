import 'package:flutter/material.dart';

/// Extension methods for [Duration].
extension DurationX on Duration {
  /// Formats duration as MM:SS.
  String toMMSS() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Formats duration as HH:MM:SS.
  String toHHMMSS() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

/// Extension methods for [Color].
extension ColorX on Color {
  /// Returns a copy with modified alpha.
  Color withOpacityValue(double opacity) => withValues(alpha: opacity);
}

/// Extension methods for [BuildContext].
extension ContextX on BuildContext {
  /// Shorthand for MediaQuery.sizeOf(context).
  ///
  /// **Deprecated**: Use `LayoutBuilder` constraints instead for responsive
  /// layouts. Screen size assumptions break in split-screen and resizable
  /// windows.
  @Deprecated('Use LayoutBuilder constraints instead of screen size.')
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Shorthand for MediaQuery.paddingOf(context).
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  /// Returns true if screen width > 600.
  ///
  /// **Deprecated**: Use `breakpointForWidth(constraints.maxWidth)` instead
  /// for proper constraint-aware responsive checks.
  @Deprecated('Use breakpointForWidth with LayoutBuilder constraints.')
  bool get isTablet => screenSize.width > 600;
}
