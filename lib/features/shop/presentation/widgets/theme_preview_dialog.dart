import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/features/shop/presentation/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemePreviewDialog extends ConsumerStatefulWidget {
  const ThemePreviewDialog({required this.themeToPreview, super.key});
  final AppTheme themeToPreview;

  @override
  ConsumerState<ThemePreviewDialog> createState() => _ThemePreviewDialogState();
}

class _ThemePreviewDialogState extends ConsumerState<ThemePreviewDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeToPreview;
    final shopAsync = ref.watch(shopProvider);
    final product = shopAsync.asData?.value.getProduct(theme.name);

    // Determine price to show: Product price, or theme placeholder, or error
    final price = product?.price ?? theme.price ?? 'N/A';
    final canBuy = product != null;
    final isLoading = shopAsync.isLoading;

    const isDark = true; // Preview in default dark mode

    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: theme.bg(isDark: isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            side: BorderSide(color: theme.border(isDark: isDark), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${theme.name} Theme',
                  style: TextStyle(
                    color: theme.fg(isDark: isDark),
                    fontSize: AppDimensions.fontL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),

                // Preview Color Grid
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingS),
                  decoration: BoxDecoration(
                    color: theme.surface(isDark: isDark),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: theme
                        .playerColors(isDark: isDark)
                        .map(
                          (c) => Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: c.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingL),

                Text(
                  'Unlock this theme for $price',
                  style: TextStyle(
                    color: theme.subtitle(isDark: isDark),
                    fontSize: AppDimensions.fontS,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingL),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
                    child: CircularProgressIndicator(),
                  ),

                Row(
                  children: [
                    Expanded(
                      child: PillButton(
                        text: 'Cancel',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: PillButton(
                        text: 'Buy',
                        // Disable if loading or product not found
                        onTap: (isLoading || !canBuy)
                            ? null
                            : () {
                                unawaited(
                                  ref
                                      .read(shopProvider.notifier)
                                      .purchaseTheme(product),
                                );
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                        type: PillButtonType.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
