import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/fade_entry_widget.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/core/utils/fluid_dialog.dart';
import 'package:chain_reaction/features/shop/presentation/providers/shop_provider.dart';
import 'package:chain_reaction/features/shop/presentation/screens/purchase_screen.dart';
import 'package:chain_reaction/features/shop/presentation/widgets/theme_preview_dialog.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaletteScreen extends ConsumerWidget {
  const PaletteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final shopAsync = ref.watch(shopProvider);
    final l10n = AppLocalizations.of(context)!;

    return ColoredBox(
      color: themeState.bg,
      child: ResponsiveContainer(
        child: Scaffold(
          backgroundColor: themeState.bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: themeState.fg,
                size: AppDimensions.iconM,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.themesTitle,
              style: TextStyle(
                color: themeState.fg,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: shopAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: themeState.fg),
              ),
              error: (e, st) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: themeState.fg),
                ),
              ),
              data: (shopState) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Text(
                        l10n.availableThemesHeader,
                        style: TextStyle(
                          color: themeState.subtitle,
                          fontSize: AppDimensions.fontXS,
                          fontWeight: FontWeight.bold,
                          letterSpacing: AppDimensions.letterSpacingHeader,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    // Theme list (not using ListView since we're in a scroll view)
                    ...List.generate(AppThemes.all.length, (index) {
                      final theme = AppThemes.all[index];
                      final isSelected =
                          theme.name == themeState.currentTheme.name;
                      final isOwned =
                          !theme.isPremium || shopState.isOwned(theme.name);

                      return Column(
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingL,
                              ),
                              child: Divider(
                                color: themeState.border,
                                height: AppDimensions.paddingXL,
                              ),
                            ),
                          FadeEntryWidget(
                            delay: Duration(milliseconds: index * 50),
                            child: _ThemeRow(
                              theme: theme,
                              isSelected: isSelected,
                              isLocked: !isOwned,
                              isDarkMode: themeState.isDarkMode,
                              onTap: () {
                                if (isOwned) {
                                  ref
                                      .read(themeProvider.notifier)
                                      .setTheme(theme);
                                } else {
                                  unawaited(
                                    showFluidDialog<void>(
                                      context: context,
                                      builder: (_) => ThemePreviewDialog(
                                        themeToPreview: theme,
                                      ),
                                    ),
                                  );
                                }
                              },
                              textColor: themeState.fg,
                              backgroundColor: themeState.bg,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: AppDimensions.paddingXL),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: PillButton(
                        text: l10n.getMoreThemes,
                        onTap: () {
                          unawaited(
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const PurchaseScreen(),
                              ),
                            ),
                          );
                        },
                        width: double.infinity,
                        type: PillButtonType.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow({
    required this.theme,
    required this.isSelected,
    required this.isLocked,
    required this.isDarkMode,
    required this.onTap,
    required this.textColor,
    required this.backgroundColor,
  });
  final AppTheme theme;
  final bool isSelected;
  final bool isLocked;
  final bool isDarkMode;
  final VoidCallback onTap;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final playerColors = theme.playerColors(isDark: isDarkMode);
    final paletteColors = theme.paletteColors(isDark: isDarkMode);

    return Semantics(
      button: true,
      selected: isSelected,
      label: isLocked ? '${theme.name}, locked theme' : '${theme.name} theme',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            splashColor: textColor.withValues(alpha: 0.12),
            highlightColor: textColor.withValues(alpha: 0.06),
            hoverColor: textColor.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL - AppDimensions.paddingS,
                vertical: AppDimensions.paddingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.check_circle,
                            color: playerColors.isNotEmpty
                                ? playerColors[0]
                                : textColor,
                            size: AppDimensions.iconM,
                          ),
                        )
                      else if (isLocked)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.lock,
                            color: textColor.withValues(alpha: 0.5),
                            size: AppDimensions.iconM,
                          ),
                        ),
                      Text(
                        theme.name,
                        style: TextStyle(
                          color: isLocked
                              ? textColor.withValues(alpha: 0.5)
                              : textColor,
                          fontSize: AppDimensions.fontL,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Palette colors - constraint-based sizing
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Use 40% of available width, clamped to reasonable bounds
                      final paletteWidth = (constraints.maxWidth * 0.4).clamp(
                        100.0,
                        200.0,
                      );
                      const circleSize = AppDimensions.colorCircleSize;
                      const overlap = 14.0;

                      return SizedBox(
                        height: circleSize + 6, // Circle + border allowance
                        width: paletteWidth,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: List.generate(paletteColors.length, (
                            index,
                          ) {
                            final color =
                                paletteColors[paletteColors.length - 1 - index];
                            return Positioned(
                              right: index * overlap,
                              child: Container(
                                width: circleSize,
                                height: circleSize,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: backgroundColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
