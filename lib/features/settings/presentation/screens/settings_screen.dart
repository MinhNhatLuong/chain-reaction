import 'dart:async';
import 'dart:typed_data';

import 'package:chain_reaction/core/constants/app_dimensions.dart';
import 'package:chain_reaction/core/presentation/widgets/edit_player_dialog.dart';
import 'package:chain_reaction/core/presentation/widgets/pill_button.dart';
import 'package:chain_reaction/core/presentation/widgets/responsive_container.dart';
import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/core/utils/fluid_dialog.dart';
import 'package:chain_reaction/features/game/presentation/providers/player_names_provider.dart';
import 'package:chain_reaction/features/settings/presentation/providers/custom_atom_images_provider.dart';
import 'package:chain_reaction/features/settings/presentation/providers/update_provider.dart';
import 'package:chain_reaction/features/settings/presentation/screens/atom_image_crop_screen.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(appUpdateProvider.notifier).continueAfterPermission(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final playerNamesState = ref.watch(playerNamesProvider);
    final atomImageState = ref.watch(customAtomImagesProvider);
    final updateState = ref.watch(appUpdateProvider);
    final isCustomAtomImagesUnlocked = ref.watch(
      isCustomAtomImagesUnlockedProvider,
    );
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
              l10n.settingsTitle,
              style: TextStyle(
                color: themeState.fg,
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('GENERAL', themeState),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.darkMode,
                      l10n.darkModeSubtitle,
                      value: themeState.isDarkMode,
                      onChanged: themeNotifier.setDarkMode,
                      theme: themeState,
                      l10n: l10n,
                    ),

                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.hapticFeedback,
                      l10n.hapticFeedbackSubtitle,
                      value: themeState.isHapticOn,
                      onChanged: themeNotifier.setHapticOn,
                      theme: themeState,
                      l10n: l10n,
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                    Divider(color: themeState.border, thickness: 1),
                    const SizedBox(height: AppDimensions.paddingXL),

                    _buildSectionHeader('APP UPDATE', themeState),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildUpdateSection(
                      ref: ref,
                      theme: themeState,
                      state: updateState,
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                    Divider(color: themeState.border, thickness: 1),
                    const SizedBox(height: AppDimensions.paddingXL),

                    _buildSectionHeader('VISUALS & ANIMATION', themeState),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.atomRotation,
                      l10n.atomRotationSubtitle,
                      value: themeState.isAtomRotationOn,
                      onChanged: themeNotifier.setAtomRotationOn,
                      theme: themeState,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.atomVibration,
                      l10n.atomVibrationSubtitle,
                      value: themeState.isAtomVibrationOn,
                      onChanged: themeNotifier.setAtomVibrationOn,
                      theme: themeState,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.atomBreathing,
                      l10n.atomBreathingSubtitle,
                      value: themeState.isAtomBreathingOn,
                      onChanged: themeNotifier.setAtomBreathingOn,
                      theme: themeState,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildToggleRow(
                      l10n.cellHighlight,
                      l10n.cellHighlightSubtitle,
                      value: themeState.isCellHighlightOn,
                      onChanged: themeNotifier.setCellHighlightOn,
                      theme: themeState,
                      l10n: l10n,
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                    Divider(color: themeState.border, thickness: 1),
                    const SizedBox(height: AppDimensions.paddingXL),

                    _buildSectionHeader('CUSTOM ORB IMAGES', themeState),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildCustomAtomImagesSection(
                      context: context,
                      ref: ref,
                      theme: themeState,
                      imageState: atomImageState,
                      isUnlocked: isCustomAtomImagesUnlocked,
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                    Divider(color: themeState.border, thickness: 1),
                    const SizedBox(height: AppDimensions.paddingXL),

                    _buildSectionHeader(l10n.playerSettingsHeader, themeState),
                    const SizedBox(height: AppDimensions.paddingL),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppDimensions.paddingM,
                            mainAxisSpacing: AppDimensions.paddingM,
                            childAspectRatio: 2.5,
                          ),
                      itemCount: themeState.playerColors.length,
                      itemBuilder: (context, index) {
                        final playerIndex = index + 1;
                        return _buildPlayerSettingItem(
                          playerIndex,
                          themeState.playerColors[index],
                          themeState,
                          playerNamesState.getName(playerIndex),
                          context,
                        );
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                    PillButton(
                      text: l10n.resetSettings,
                      onTap: () async {
                        // Reset player names
                        ref.read(playerNamesProvider.notifier).resetNames();
                        await ref
                            .read(customAtomImagesProvider.notifier)
                            .clearImages();
                        // Reset all app settings (theme, visuals)
                        await ref.read(themeProvider.notifier).resetSettings();
                      },
                      width: double.infinity,
                      type: PillButtonType.destructive,
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

  Widget _buildUpdateSection({
    required WidgetRef ref,
    required ThemeState theme,
    required AppUpdateState state,
  }) {
    final availability = state.availability;
    final latestBuild = availability?.release.buildNumber;
    final asset = availability?.apkAsset;
    final progress = state.downloadProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (availability != null) ...[
          Text(
            'Latest build: $latestBuild',
            style: TextStyle(
              color: theme.fg,
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            '${asset?.name ?? 'Android APK'} - ${_formatBytes(asset?.size ?? 0)}',
            style: TextStyle(
              color: theme.subtitle,
              fontSize: AppDimensions.fontS,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
        if (state.message != null) ...[
          Text(
            state.message!,
            style: TextStyle(
              color: _isUpdateErrorState(state.status)
                  ? theme.currentTheme.red
                  : theme.subtitle,
              fontSize: AppDimensions.fontS,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
        if (progress != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.border,
              valueColor: AlwaysStoppedAnimation<Color>(theme.fg),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
        ],
        Row(
          children: [
            Expanded(
              child: PillButton(
                text: state.status == AppUpdateStatus.checking
                    ? 'Checking...'
                    : 'Check for update',
                onTap: state.isBusy
                    ? null
                    : () {
                        unawaited(
                          ref
                              .read(appUpdateProvider.notifier)
                              .checkForUpdate(),
                        );
                      },
              ),
            ),
            if (state.hasAvailableUpdate) ...[
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: PillButton(
                  text: _updateButtonText(state),
                  type: PillButtonType.primary,
                  onTap: state.isBusy
                      ? null
                      : () {
                          unawaited(
                            ref.read(appUpdateProvider.notifier).update(),
                          );
                        },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _updateButtonText(AppUpdateState state) {
    return switch (state.status) {
      AppUpdateStatus.permissionRequired => 'Grant permission',
      AppUpdateStatus.downloading => 'Downloading...',
      AppUpdateStatus.installing => 'Installing...',
      _ => 'Update',
    };
  }

  bool _isUpdateErrorState(AppUpdateStatus status) {
    return status == AppUpdateStatus.error;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return 'Unknown size';
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    final precision = unitIndex == 0 || size >= 10 ? 0 : 1;
    return '${size.toStringAsFixed(precision)} ${units[unitIndex]}';
  }

  Widget _buildCustomAtomImagesSection({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeState theme,
    required CustomAtomImagesState imageState,
    required bool isUnlocked,
  }) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.42,
      child: IgnorePointer(
        ignoring: !isUnlocked,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUnlocked)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: theme.subtitle,
                      size: AppDimensions.iconS,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: Text(
                        'Buy the ${AppThemes.photoOrbs.name} theme to unlock custom orb images.',
                        style: TextStyle(
                          color: theme.subtitle,
                          fontSize: AppDimensions.fontS,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: List.generate(kCustomAtomImageSlotCount, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == kCustomAtomImageSlotCount - 1
                          ? 0
                          : AppDimensions.paddingS,
                    ),
                    child: _buildAtomImageSlot(
                      context: context,
                      ref: ref,
                      theme: theme,
                      index: index,
                      imageBytes: imageState.imageAt(index),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            PillButton(
              text: 'Clear orb images',
              onTap: imageState.hasAnyImage
                  ? () {
                      unawaited(
                        ref
                            .read(customAtomImagesProvider.notifier)
                            .clearImages(),
                      );
                    }
                  : null,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtomImageSlot({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeState theme,
    required int index,
    required Uint8List? imageBytes,
  }) {
    return Semantics(
      button: true,
      label: 'Choose image for orb ${index + 1}',
      child: InkWell(
        onTap: () {
          unawaited(_pickAndCropAtomImage(context, ref, index));
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.surface,
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageBytes == null)
                    Center(
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: theme.subtitle,
                        size: AppDimensions.iconL,
                      ),
                    )
                  else
                    Image.memory(imageBytes, fit: BoxFit.cover),
                  Positioned(
                    left: AppDimensions.paddingS,
                    top: AppDimensions.paddingS,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.bg.withValues(alpha: 0.78),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(
                        dimension: 24,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: theme.fg,
                              fontSize: AppDimensions.fontXS,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndCropAtomImage(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) async {
    final notifier = ref.read(customAtomImagesProvider.notifier);
    final picker = ImagePicker();

    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 92,
      );
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open image picker.')),
      );
      return;
    }

    if (pickedFile == null) return;

    final imageBytes = await pickedFile.readAsBytes();
    if (!context.mounted) return;

    final croppedBytes = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => AtomImageCropScreen(
          imageBytes: imageBytes,
          slotNumber: index + 1,
        ),
      ),
    );

    if (croppedBytes == null) return;
    await notifier.setImage(index, croppedBytes);
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

  Widget _buildToggleRow(
    String title,
    String subtitle, {
    required bool value,
    required void Function({required bool value}) onChanged,
    required ThemeState theme,
    required AppLocalizations l10n,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.fg,
                  fontSize: AppDimensions.fontM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                subtitle,
                style: TextStyle(
                  color: theme.subtitle,
                  fontSize: AppDimensions.fontS,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => onChanged(value: !value),
          style: TextButton.styleFrom(
            foregroundColor: theme.fg,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              value ? l10n.on : l10n.off,
              key: ValueKey<bool>(value),
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSettingItem(
    int playerIndex,
    Color color,
    ThemeState theme,
    String playerName,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        unawaited(
          showFluidDialog<void>(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.8),
            builder: (context) => EditPlayerDialog(playerIndex: playerIndex),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          children: [
            Container(
              width: AppDimensions.colorCircleSize,
              height: AppDimensions.colorCircleSize,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                playerName,
                style: TextStyle(
                  color: theme.fg,
                  fontSize: AppDimensions.fontM,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
