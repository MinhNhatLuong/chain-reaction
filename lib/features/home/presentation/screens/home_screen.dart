import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/constants/breakpoints.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/home/presentation/providers/home_provider.dart';
import 'package:chain_reaction/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:chain_reaction/features/home/presentation/widgets/home_configuration.dart';
import 'package:chain_reaction/features/home/presentation/widgets/home_mode_selection.dart';
import 'package:chain_reaction/features/home/presentation/widgets/home_orb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export '../providers/home_provider.dart' show GameMode, HomeStep;

/// The main home screen with responsive layout support.
///
/// Layout behavior by breakpoint:
/// - **xs/sm**: Single column with orb above content, bottom navigation bar
/// - **md+**: Two-pane layout with orb on left, content on right
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final currentStep = ref.watch(homeProvider.select((s) => s.currentStep));
    final notifier = ref.read(homeProvider.notifier);

    return PopScope(
      canPop: currentStep == HomeStep.modeSelection,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (didPop) return;
        notifier.setStep(HomeStep.modeSelection);
      },
      child: Scaffold(
        backgroundColor: theme.bg,
        body: SafeArea(
          child: ResponsiveContainer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final breakpoint = breakpointForWidth(constraints.maxWidth);

                if (breakpoint.supportsTwoPaneLayout) {
                  return _TwoPaneLayout(
                    currentStep: currentStep,
                    onBack: () => notifier.setStep(HomeStep.modeSelection),
                  );
                } else {
                  return _SingleColumnLayout(
                    currentStep: currentStep,
                    onBack: () => notifier.setStep(HomeStep.modeSelection),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Single column layout for mobile (xs, sm breakpoints).
class _SingleColumnLayout extends StatelessWidget {
  const _SingleColumnLayout({
    required this.currentStep,
    required this.onBack,
  });

  final HomeStep currentStep;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingXL,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),

                      // Main content centered
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Central Orb Graphic
                          const HomeOrb(),

                          const SizedBox(height: AppDimensions.paddingXXL),

                          // Dynamic Content Area with Animation
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: currentStep == HomeStep.modeSelection
                                ? const HomeModeSelection()
                                : const HomeConfiguration(),
                          ),
                        ],
                      ),

                      // Bottom bar
                      const Padding(
                        padding: EdgeInsets.only(top: AppDimensions.paddingXXL),
                        child: HomeBottomBar(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Back Button Overlay
        if (currentStep == HomeStep.configuration)
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
                size: AppDimensions.iconM,
              ),
              onPressed: onBack,
              tooltip: 'Back to Mode Selection',
            ),
          ),
      ],
    );
  }
}

/// Two-pane layout for tablet/desktop (md+ breakpoints).
class _TwoPaneLayout extends StatelessWidget {
  const _TwoPaneLayout({
    required this.currentStep,
    required this.onBack,
  });

  final HomeStep currentStep;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Row(
          children: [
            // Left pane: Orb
            const Expanded(
              flex: 5,
              child: Center(child: HomeOrb()),
            ),

            // Right pane: Content (scrollable)
            Expanded(
              flex: 5,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingXL,
                          vertical: AppDimensions.paddingL,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox.shrink(),

                            // Dynamic Content Area
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: currentStep == HomeStep.modeSelection
                                  ? const HomeModeSelection()
                                  : const HomeConfiguration(),
                            ),

                            // Bottom navigation as horizontal row
                            const Padding(
                              padding: EdgeInsets.only(
                                top: AppDimensions.paddingXL,
                              ),
                              child: HomeBottomBar(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // Back Button Overlay
        if (currentStep == HomeStep.configuration)
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
                size: AppDimensions.iconM,
              ),
              onPressed: onBack,
              tooltip: 'Back to Mode Selection',
            ),
          ),
      ],
    );
  }
}
