import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:chain_reaction/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.fg),
            tooltip: l10n.settingsTitle,
            onPressed: () {
              unawaited(context.pushNamed(AppRouteNames.settings));
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: theme.fg),
            tooltip: l10n.shopTitle,
            onPressed: () {
              unawaited(context.pushNamed(AppRouteNames.shop));
            },
          ),
          IconButton(
            icon: Icon(Icons.palette, color: theme.fg),
            tooltip: l10n.themesTitle,
            onPressed: () {
              unawaited(context.pushNamed(AppRouteNames.palette));
            },
          ),
          IconButton(
            icon: Icon(Icons.info, color: theme.fg),
            tooltip: l10n.infoTitle,
            onPressed: () {
              unawaited(context.pushNamed(AppRouteNames.info));
            },
          ),
        ],
      ),
    );
  }
}
