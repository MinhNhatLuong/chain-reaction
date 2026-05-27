import 'package:chain_reaction/core/constants/breakpoints.dart';
import 'package:flutter/material.dart';

/// A responsive widget that switches between Row and Column based on width.
///
/// Use this for layouts that should be horizontal on larger screens but
/// need to stack vertically on narrow screens (e.g., split-screen mode).
///
/// Example:
/// ```dart
/// ResponsiveRow(
///   children: [
///     Text('Label'),
///     Switch(value: true, onChanged: (_) {}),
///   ],
/// )
/// ```
///
/// By default, collapses to Column when width < 600dp (xs breakpoint).
class ResponsiveRow extends StatelessWidget {
  const ResponsiveRow({
    required this.children,
    this.collapseBelow = Breakpoint.sm,
    this.rowMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8.0,
    super.key,
  });

  /// The children to display.
  final List<Widget> children;

  /// The breakpoint below which to collapse to Column.
  ///
  /// Defaults to [Breakpoint.sm], meaning xs breakpoint uses Column.
  final Breakpoint collapseBelow;

  /// Main axis alignment when displaying as Row.
  final MainAxisAlignment rowMainAxisAlignment;

  /// Cross axis alignment when displaying as Row.
  final CrossAxisAlignment rowCrossAxisAlignment;

  /// Main axis alignment when displaying as Column.
  final MainAxisAlignment columnMainAxisAlignment;

  /// Cross axis alignment when displaying as Column.
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// Spacing between children when collapsed to Column.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);
        final useColumn = breakpoint < collapseBelow;

        if (useColumn) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: columnCrossAxisAlignment,
            children: _addSpacing(children, spacing),
          );
        } else {
          return Row(
            mainAxisAlignment: rowMainAxisAlignment,
            crossAxisAlignment: rowCrossAxisAlignment,
            children: children,
          );
        }
      },
    );
  }

  /// Adds spacing between children for column layout.
  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(height: spacing));
      }
    }
    return result;
  }
}

/// A simpler variant that just wraps content in a responsive manner.
///
/// Use when you have label-value pairs that should be horizontal on larger
/// screens but stack vertically on narrow screens.
class ResponsiveLabelValue extends StatelessWidget {
  const ResponsiveLabelValue({
    required this.label,
    required this.value,
    this.collapseBelow = Breakpoint.sm,
    this.spacing = 4.0,
    super.key,
  });

  /// The label widget (typically Text).
  final Widget label;

  /// The value widget (typically Text, Switch, or Button).
  final Widget value;

  /// The breakpoint below which to stack vertically.
  final Breakpoint collapseBelow;

  /// Spacing between label and value when stacked.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);
        final useColumn = breakpoint < collapseBelow;

        if (useColumn) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label,
              SizedBox(height: spacing),
              value,
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [label, value],
          );
        }
      },
    );
  }
}
