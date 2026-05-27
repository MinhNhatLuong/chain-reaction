import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/presentation/providers/providers.dart';
import 'package:chain_reaction/features/game/presentation/widgets/cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A wrapper around [CellWidget] that watches only the specific cell at [row], [col].
/// This ensures that only the modified cell rebuilds, not the entire grid.
class ScopedCellWidget extends ConsumerWidget {
  const ScopedCellWidget({
    required this.row,
    required this.col,
    required this.onTap,
    required this.animation,
    required this.angleOffset,
    required this.borderColor,
    this.isKeyboardSelected = false,
    super.key,
  });

  final int row;
  final int col;
  final VoidCallback onTap;
  final Animation<double> animation;
  final double angleOffset;
  final Color borderColor;
  final bool isKeyboardSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Select only this specific cell to avoid unnecessary rebuilds.
    final cell = ref.watch(
      gridProvider.select((grid) => grid?[row][col]),
    );

    // If grid is null (e.g. game reset), render nothing or placeholder
    if (cell == null) return const SizedBox();

    final themeState = ref.read(
      themeProvider,
    ); // Read is safe for config flags if they don't change often, or watch if they do.
    // Watching themeState might trigger full grid rebuild on theme change, which is acceptable.
    // But for cell updates (atoms), we want isolation.

    // We need owner color.
    var cellColor = Colors.transparent;
    var ownerName = 'Empty';
    if (cell.ownerId != null) {
      final players = ref.read(
        playersProvider,
      ); // Read players list (unlikely to change during game)
      if (players != null) {
        for (final player in players) {
          if (player.id == cell.ownerId) {
            cellColor = Color(player.color);
            ownerName = player.name;
            break;
          }
        }
      }
    }

    final orbLabel = cell.atomCount == 1 ? 'orb' : 'orbs';
    final semanticLabel =
        'Row ${row + 1}, Column ${col + 1}. $ownerName. ${cell.atomCount} $orbLabel.';

    return CellWidget(
      cell: cell,
      borderColor: borderColor,
      cellColor: cellColor,
      onTap: onTap,
      isAtomRotationOn: themeState.isAtomRotationOn,
      isAtomVibrationOn: themeState.isAtomVibrationOn,
      isAtomBreathingOn: themeState.isAtomBreathingOn,
      isCellHighlightOn: themeState.isCellHighlightOn,
      animation: animation,
      angleOffset: angleOffset,
      isKeyboardSelected: isKeyboardSelected,
      semanticLabel: semanticLabel,
      semanticHint: 'Double tap to place an orb.',
    );
  }
}
