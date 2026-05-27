import 'dart:async';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/presentation/providers/providers.dart';
import 'package:chain_reaction/features/game/presentation/widgets/flying_atom_widget.dart';
import 'package:chain_reaction/features/game/presentation/widgets/scoped_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the game grid with cells and flying atoms.
/// Renders the game grid with cells and flying atoms.
class GameGrid extends ConsumerStatefulWidget {
  const GameGrid({required this.onCellTap, super.key});
  final void Function(int x, int y) onCellTap;

  @override
  ConsumerState<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends ConsumerState<GameGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _masterController;
  late final FocusNode _gridFocusNode;
  int _selectedRow = 0;
  int _selectedCol = 0;

  @override
  void initState() {
    super.initState();
    // Master loop: 4 seconds.
    // 0.0 -> 1.0 continuously.
    // AtomPainter scales this for speed (e.g. 4x for unstable).
    // AtomPainter scales this for speed (e.g. 4x for unstable).
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: AppDimensions.masterAnimationDurationSec,
      ),
    );
    unawaited(_masterController.repeat());
    _gridFocusNode = FocusNode(debugLabel: 'game_grid_focus');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _gridFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    _gridFocusNode.dispose();
    super.dispose();
  }

  void _normalizeSelection(int rows, int cols) {
    final nextRow = _selectedRow.clamp(0, rows - 1);
    final nextCol = _selectedCol.clamp(0, cols - 1);
    if (nextRow == _selectedRow && nextCol == _selectedCol) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedRow = nextRow;
        _selectedCol = nextCol;
      });
    });
  }

  void _moveSelection(int deltaCol, int deltaRow, int rows, int cols) {
    final nextCol = (_selectedCol + deltaCol).clamp(0, cols - 1);
    final nextRow = (_selectedRow + deltaRow).clamp(0, rows - 1);
    if (nextRow == _selectedRow && nextCol == _selectedCol) return;

    setState(() {
      _selectedRow = nextRow;
      _selectedCol = nextCol;
    });
  }

  void _handleCellTap(int row, int col) {
    setState(() {
      _selectedRow = row;
      _selectedCol = col;
    });
    _gridFocusNode.requestFocus();
    widget.onCellTap(col, row);
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, int rows, int cols) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) {
      _moveSelection(0, -1, rows, cols);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _moveSelection(0, 1, rows, cols);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      _moveSelection(-1, 0, rows, cols);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      _moveSelection(1, 0, rows, cols);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _handleCellTap(_selectedRow, _selectedCol);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // Watch precise parts of the state to optimize rebuilds
    // Watch only dimensions to avoid rebuilds on cell content changes
    final rows = ref.watch(gridProvider.select((g) => g?.length ?? 0));
    final cols = ref.watch(
      gridProvider.select((g) => (g?.isNotEmpty ?? false) ? g![0].length : 0),
    );

    final themeState = ref.watch(themeProvider);
    final theme = themeState.currentTheme;
    final isDark = ref.watch(isDarkModeProvider);
    final borderColor = theme.border(isDark: isDark);
    final players = ref.watch(playersProvider);
    final flyingAtoms = ref.watch(flyingAtomsProvider);

    if (rows == 0 || cols == 0 || players == null) {
      return const Center(child: CircularProgressIndicator());
    }

    _normalizeSelection(rows, cols);

    return Focus(
      focusNode: _gridFocusNode,
      autofocus: true,
      onFocusChange: (_) => setState(() {}),
      onKeyEvent: (_, event) => _handleKeyEvent(event, rows, cols),
      child: Semantics(
        label: 'Game board',
        hint:
            'Use arrow keys to select cells and press Enter or Space to place an orb.',
        child: ColoredBox(
          color: theme.bg(isDark: isDark),
          child: Center(
            child: AspectRatio(
              aspectRatio: cols / rows,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cellWidth = constraints.maxWidth / cols;
                  final cellHeight = constraints.maxHeight / rows;
                  final cellSize = Size(cellWidth, cellHeight);

                  return Stack(
                    children: [
                      // Layer 1: The Grid
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor.withValues(
                              alpha: AppDimensions.gridBorderOpacity,
                            ),
                            width: AppDimensions.gridBorderWidth,
                          ),
                        ),
                        child: Column(
                          children: List.generate(rows, (row) {
                            return Expanded(
                              child: Row(
                                children: List.generate(cols, (col) {
                                  const phasePrime1 = 13;
                                  const phasePrime2 = 23;
                                  const phaseMod = 100;
                                  final angleOffset =
                                      ((col * phasePrime1 + row * phasePrime2) %
                                          phaseMod) /
                                      phaseMod.toDouble();

                                  return ScopedCellWidget(
                                    row: row,
                                    col: col,
                                    borderColor: borderColor,
                                    onTap: () => _handleCellTap(row, col),
                                    animation: _masterController,
                                    angleOffset: angleOffset,
                                    isKeyboardSelected:
                                        _gridFocusNode.hasFocus &&
                                        row == _selectedRow &&
                                        col == _selectedCol,
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),

                      // Layer 2: Flying Atoms (Projectiles)
                      ...flyingAtoms.map(
                        (atom) => FlyingAtomWidget(
                          key: ValueKey(atom.id),
                          atom: atom,
                          cellSize: cellSize,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
