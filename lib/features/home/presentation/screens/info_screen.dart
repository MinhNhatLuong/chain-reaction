import 'package:chain_reaction/core/constants/constants.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final l10n = AppLocalizations.of(context)!;

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
              l10n.infoTitle,
              style: TextStyle(
                color: theme.fg,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(l10n.howToPlayHeader, theme),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildBulletPoint(l10n.htpBullet1, theme),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildBulletPoint(l10n.htpBullet2, theme),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildBulletPoint(l10n.htpBullet3, theme),

                  const SizedBox(height: AppDimensions.paddingXL),
                  Divider(color: theme.border, thickness: 1),
                  const SizedBox(height: AppDimensions.paddingXL),

                  _buildSectionHeader(l10n.aboutHeader, theme),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildInfoRow(
                    l10n.versionLabel,
                    AppConstants.appVersion,
                    theme,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildInfoRow(
                    l10n.developerLabel,
                    l10n.developerName,
                    theme,
                    onTap: () async {
                      final url = Uri.parse('https://example.com');
                      try {
                        await launchUrl(url);
                      } on Object {
                        // Fail silently
                      }
                    },
                  ),

                  const SizedBox(height: AppDimensions.paddingXL),
                  Divider(color: theme.border, thickness: 1),
                  const SizedBox(height: AppDimensions.paddingXL),

                  _buildSectionHeader(l10n.supportHeader, theme),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    l10n.supportMessage,
                    style: TextStyle(
                      color: theme.subtitle,
                      fontSize: AppDimensions.fontS,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  PillButton(
                    text: l10n.contactMe,
                    onTap: () async {
                      final emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: l10n.supportEmail,
                      );
                      try {
                        await launchUrl(emailLaunchUri);
                      } on Object {
                        // Handle error silently or show toast
                      }
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                ],
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
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: AppDimensions.letterSpacingHeader,
      ),
    );
  }

  Widget _buildBulletPoint(String text, ThemeState theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: theme.fg, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: theme.fg,
              fontSize: AppDimensions.fontM,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeState theme, {
    VoidCallback? onTap,
  }) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.subtitle,
            fontSize: AppDimensions.fontM,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: theme.fg,
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_outward,
                color: theme.subtitle,
                size: AppDimensions.iconS,
              ),
            ],
          ],
        ),
      ],
    );

    if (onTap == null) return row;

    return Semantics(
      button: true,
      label: '$label, $value',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingS,
            ),
            child: row,
          ),
        ),
      ),
    );
  }
}
