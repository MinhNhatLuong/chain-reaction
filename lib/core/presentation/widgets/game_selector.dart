import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSelector extends ConsumerWidget {
  const GameSelector({
    required this.label,
    required this.value,
    required this.onPrevious,
    required this.onNext,
    super.key,
    this.isReadOnly = false,
  });
  final String label;
  final String value;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: theme.subtitle,
            fontSize: AppDimensions.fontXS,
            fontWeight: FontWeight.bold,
            letterSpacing: AppDimensions.letterSpacingTitle,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ArrowButton(
              icon: Icons.chevron_left,
              onTap: isReadOnly ? null : onPrevious,
              color: theme.fg,
            ),
            Expanded(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: theme.fg,
                    fontSize: AppDimensions.fontXXL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            _ArrowButton(
              icon: Icons.chevron_right,
              onTap: isReadOnly ? null : onNext,
              color: theme.fg,
            ),
          ],
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.color,
    this.onTap,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: color.withValues(alpha: onTap == null ? 0.18 : 0.6),
        size: 28,
      ),
      splashRadius: 24,
    );
  }
}
