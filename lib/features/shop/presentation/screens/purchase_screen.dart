import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/shop/presentation/providers/shop_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

const String _supportCoffeeUrl = 'https://example.com/support';

class PurchaseScreen extends ConsumerWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final shopAsync = ref.watch(shopProvider);
    final l10n = AppLocalizations.of(context)!;

    final paidThemes = AppThemes.all.where((t) => t.isPremium).toList();

    return ColoredBox(
      color: theme.bg,
      child: ResponsiveContainer(
        child: Scaffold(
          backgroundColor: theme.bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.fg,
                size: AppDimensions.iconM,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.shopTitle,
              style: TextStyle(
                color: theme.fg,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: shopAsync.when(
              loading: () =>
                  Center(child: CircularProgressIndicator(color: theme.fg)),
              error: (e, st) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Text(
                    'Error: $e',
                    style: TextStyle(color: theme.fg),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (state) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.paddingM),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: _buildSectionHeader(l10n.themePacksHeader, theme),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    ...paidThemes.map((targetTheme) {
                      final isOwned = state.isOwned(targetTheme.name);
                      final product = state.getProduct(targetTheme.name);
                      final price = isOwned
                          ? 'OWNED'
                          : (product?.price ?? (targetTheme.price ?? 'N/A'));

                      final canBuy = !isOwned && product != null;

                      return _buildShopItem(
                        title: '${targetTheme.name} Theme',
                        subtitle: isOwned
                            ? 'Currently owned'
                            : 'Unlock this theme',
                        price: price,
                        onTap: canBuy
                            ? () {
                                unawaited(
                                  ref
                                      .read(shopProvider.notifier)
                                      .purchaseTheme(product),
                                );
                              }
                            : null,
                        theme: theme,
                      );
                    }),
                    const SizedBox(height: AppDimensions.paddingS),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Divider(color: theme.border, thickness: 1),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: _buildSectionHeader(
                        l10n.supportDevelopmentHeader,
                        theme,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    Builder(
                      builder: (context) {
                        final coffeeProduct = state.getProduct(kCoffeeId);
                        return _buildShopItem(
                          title: 'Buy me a coffee',
                          subtitle: coffeeProduct == null
                              ? 'Support the developer (external checkout)'
                              : 'Support the developer',
                          price: coffeeProduct?.price ?? 'OPEN',
                          theme: theme,
                          onTap: () async {
                            if (coffeeProduct != null) {
                              unawaited(
                                ref
                                    .read(shopProvider.notifier)
                                    .buyCoffee(coffeeProduct),
                              );
                              return;
                            }

                            final url = Uri.parse(_supportCoffeeUrl);
                            var launched = false;
                            try {
                              launched = await launchUrl(url);
                            } on Object {
                              launched = false;
                            }

                            if (!launched) {
                              try {
                                launched = await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } on Object {
                                launched = false;
                              }
                            }

                            if (launched || !context.mounted) {
                              return;
                            }

                            var copiedToClipboard = false;
                            try {
                              await Clipboard.setData(
                                const ClipboardData(text: _supportCoffeeUrl),
                              );
                              copiedToClipboard = true;
                            } on Object {
                              copiedToClipboard = false;
                            }

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  copiedToClipboard
                                      ? 'Could not open browser. Support link copied to clipboard.'
                                      : 'Could not open browser. Visit $_supportCoffeeUrl',
                                  style: TextStyle(color: theme.bg),
                                ),
                                backgroundColor: theme.fg,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Divider(color: theme.border, thickness: 1),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(l10n.purchasesHeader, theme),
                          const SizedBox(height: AppDimensions.paddingM),
                          Text(
                            l10n.restorePurchasesText,
                            style: TextStyle(
                              color: theme.subtitle,
                              fontSize: AppDimensions.fontS,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingXL),
                          PillButton(
                            text: l10n.restorePurchasesButton,
                            onTap: () async {
                              await ref
                                  .read(shopProvider.notifier)
                                  .restorePurchases();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Restoring purchases...',
                                    style: TextStyle(color: theme.bg),
                                  ),
                                  backgroundColor: theme.fg,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeState theme) {
    return Text(
      title,
      style: TextStyle(
        color: theme.subtitle,
        fontSize: AppDimensions.fontXS,
        fontWeight: FontWeight.bold,
        letterSpacing: AppDimensions.letterSpacingHeader,
      ),
    );
  }

  Widget _buildShopItem({
    required String title,
    required String subtitle,
    required String price,
    required ThemeState theme,
    VoidCallback? onTap,
  }) {
    final isUnavailable = price == 'N/A';
    final interactive = onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
      ), // Add horizontal padding for touch target spacing
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          splashColor: theme.fg.withValues(alpha: interactive ? 0.12 : 0.0),
          highlightColor: theme.fg.withValues(alpha: interactive ? 0.06 : 0.0),
          hoverColor: theme.fg.withValues(alpha: interactive ? 0.04 : 0.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal:
                  AppDimensions.paddingL -
                  AppDimensions
                      .paddingS, // Adjust padding to align with core layout
              vertical: AppDimensions.paddingM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isUnavailable ? theme.subtitle : theme.fg,
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.subtitle,
                        fontSize: AppDimensions.fontS,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: onTap == null ? theme.surface : theme.fg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      color: onTap == null ? theme.subtitle : theme.bg,
                      fontSize: AppDimensions.fontS,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
