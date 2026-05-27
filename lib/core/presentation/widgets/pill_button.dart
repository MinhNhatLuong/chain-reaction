import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PillButtonType { primary, secondary, destructive }

class PillButton extends ConsumerStatefulWidget {
  const PillButton({
    required this.text,
    super.key,
    this.onTap,
    this.width,
    this.height = AppDimensions.pillButtonHeight,
    this.type = PillButtonType.secondary,
  });
  final String text;
  final VoidCallback? onTap; // Nullable for disabled state
  final double? width;
  final double height;
  final PillButtonType type;

  @override
  ConsumerState<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends ConsumerState<PillButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDisabled = widget.onTap == null;

    // Determine colors based on type
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.type) {
      case PillButtonType.primary:
        // Filled: FG background, BG text
        backgroundColor = theme.fg.withValues(
          alpha: isDisabled
              ? AppDimensions.disabledOpacity
              : AppDimensions.activeOpacity,
        );
        textColor = theme.bg.withValues(alpha: isDisabled ? 0.5 : 1.0);
        border = null;

      case PillButtonType.secondary:
        // Outline: Transparent BG, FG text, dimmed border
        backgroundColor = theme.surface.withValues(
          alpha: isDisabled ? AppDimensions.surfaceOpacity : 0.0,
        );
        textColor = theme.fg.withValues(
          alpha: isDisabled
              ? AppDimensions.disabledOpacity
              : AppDimensions.activeOpacity,
        );
        border = Border.all(
          color: theme.border.withValues(
            alpha: isDisabled
                ? AppDimensions.surfaceOpacity
                : AppDimensions.outlineOpacity,
          ), // Very faint outline
          width: AppDimensions.pillButtonBorderWidth,
        );

      case PillButtonType.destructive:
        // Outline: Transparent BG, Red text, subtle red outline
        backgroundColor = Colors.transparent;
        textColor = theme.currentTheme.red.withValues(
          alpha: isDisabled ? 0.5 : 1.0,
        );
        border = Border.all(
          color: theme.currentTheme.red.withValues(
            alpha: isDisabled ? 0.1 : 0.3,
          ), // Subtle red outline
          width: AppDimensions.pillButtonBorderWidth,
        );
    }

    return AnimatedScale(
      scale: _isPressed ? AppDimensions.buttonPressScale : 1.0,
      duration: const Duration(
        milliseconds: AppDimensions.buttonPressDurationMs,
      ),
      curve: Curves.easeOutQuad,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            borderRadius: BorderRadius.circular(widget.height / 2),
            splashColor: textColor.withValues(alpha: 0.1),
            highlightColor: textColor.withValues(alpha: 0.05),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                border: border,
                color: backgroundColor,
              ),
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w600,
                  letterSpacing: AppDimensions.letterSpacingButton,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
