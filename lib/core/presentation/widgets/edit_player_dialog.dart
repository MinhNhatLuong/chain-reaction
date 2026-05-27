import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/custom_popup.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/presentation/providers/player_names_provider.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPlayerDialog extends ConsumerStatefulWidget {
  const EditPlayerDialog({required this.playerIndex, super.key});
  final int playerIndex;

  @override
  ConsumerState<EditPlayerDialog> createState() => _EditPlayerDialogState();
}

class _EditPlayerDialogState extends ConsumerState<EditPlayerDialog> {
  late final TextEditingController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final currentName = ref.read(
        playerNamesProvider.select((s) => s.getName(widget.playerIndex)),
      );
      _controller = TextEditingController(text: currentName);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final playerColor = themeState.getPlayerColor(widget.playerIndex);
    final l10n = AppLocalizations.of(context)!;

    return CustomPopup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                decoration: BoxDecoration(
                  color: playerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${l10n.editPlayerTitle} ${widget.playerIndex}',
                style: TextStyle(
                  color: themeState.fg,
                  fontSize: AppDimensions.fontXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            style: TextStyle(color: themeState.fg),
            decoration: InputDecoration(
              labelText: l10n.nameLabel,
              labelStyle: TextStyle(color: themeState.subtitle),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeState.border),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeState.fg),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  text: l10n.cancel,
                  onTap: () => Navigator.of(context).pop(),
                  height: 48,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: PillButton(
                  text: l10n.save,
                  onTap: () {
                    ref
                        .read(playerNamesProvider.notifier)
                        .updateName(widget.playerIndex, _controller.text);
                    Navigator.of(context).pop();
                  },
                  height: 48,
                  type: PillButtonType.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
