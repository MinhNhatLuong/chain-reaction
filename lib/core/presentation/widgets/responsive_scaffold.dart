import 'package:chain_reaction/core/constants/breakpoints.dart';
import 'package:flutter/material.dart';

/// A navigation destination item used by [ResponsiveScaffold].
///
/// This is a platform-agnostic representation that can be rendered as
/// either a bottom navigation item or a NavigationRail destination.
class ResponsiveNavItem {
  const ResponsiveNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// The icon displayed for this destination.
  final IconData icon;

  /// The label for this destination.
  final String label;

  /// Optional icon to display when this destination is selected.
  final IconData? selectedIcon;
}

/// A responsive scaffold that switches between navigation paradigms.
///
/// On smaller screens (xs, sm), navigation is displayed as a bottom bar.
/// On larger screens (md, lg, xl), navigation uses a NavigationRail.
///
/// This widget automatically adapts based on the available width using
/// [LayoutBuilder] and [breakpointForWidth].
///
/// Example:
/// ```dart
/// ResponsiveScaffold(
///   body: MyContent(),
///   destinations: [
///     ResponsiveNavItem(icon: Icons.home, label: 'Home'),
///     ResponsiveNavItem(icon: Icons.settings, label: 'Settings'),
///   ],
///   selectedIndex: 0,
///   onDestinationSelected: (index) => setState(() => _index = index),
/// )
/// ```
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.body,
    this.destinations = const [],
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.appBar,
    this.floatingActionButton,
    super.key,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// Navigation destinations to display.
  ///
  /// If empty, no navigation will be shown.
  final List<ResponsiveNavItem> destinations;

  /// The index of the currently selected destination.
  final int selectedIndex;

  /// Called when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// Background color for the scaffold.
  final Color? backgroundColor;

  /// Optional app bar to display.
  final PreferredSizeWidget? appBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);
        final useRail =
            breakpoint.usesRailNavigation && destinations.isNotEmpty;

        if (useRail) {
          return _buildRailLayout(context, breakpoint);
        } else {
          return _buildBottomBarLayout(context);
        }
      },
    );
  }

  Widget _buildRailLayout(BuildContext context, Breakpoint breakpoint) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: backgroundColor ?? colorScheme.surface,
            indicatorColor: colorScheme.primaryContainer,
            labelType: breakpoint.isDesktop
                ? NavigationRailLabelType.all
                : NavigationRailLabelType.selected,
            destinations: destinations
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon ?? item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: colorScheme.outlineVariant,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildBottomBarLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: body,
      bottomNavigationBar: destinations.isEmpty
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              backgroundColor: backgroundColor ?? colorScheme.surface,
              indicatorColor: colorScheme.primaryContainer,
              destinations: destinations
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
