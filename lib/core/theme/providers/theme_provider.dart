import 'dart:async';
import 'dart:ui';

import 'package:chain_reaction/core/theme/app_theme.dart';
import 'package:chain_reaction/features/settings/domain/repositories/settings_repository.dart';
import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable state for theme settings.
@immutable
class ThemeState {
  const ThemeState({
    required this.currentTheme,
    this.isDarkMode = true,

    this.isHapticOn = true,
    this.isAtomRotationOn = true,
    this.isAtomVibrationOn = true,
    this.isAtomBreathingOn = true,
    this.isCellHighlightOn = true,
  });
  final AppTheme currentTheme;
  final bool isDarkMode;

  final bool isHapticOn;
  final bool isAtomRotationOn;
  final bool isAtomVibrationOn;
  final bool isAtomBreathingOn;
  final bool isCellHighlightOn;

  // Resolved colors for convenience
  Color get bg => currentTheme.bg(isDark: isDarkMode);
  Color get fg => currentTheme.fg(isDark: isDarkMode);
  Color get surface => currentTheme.surface(isDark: isDarkMode);
  Color get subtitle => currentTheme.subtitle(isDark: isDarkMode);
  Color get border => currentTheme.border(isDark: isDarkMode);
  List<Color> get playerColors => currentTheme.playerColors(isDark: isDarkMode);

  /// Get a player color by index (1-indexed).
  Color getPlayerColor(int playerIndex) {
    if (playerIndex <= 0 || playerColors.isEmpty) return Colors.transparent;
    return playerColors[(playerIndex - 1) % playerColors.length];
  }

  ThemeState copyWith({
    AppTheme? currentTheme,
    bool? isDarkMode,

    bool? isHapticOn,
    bool? isAtomRotationOn,
    bool? isAtomVibrationOn,
    bool? isAtomBreathingOn,
    bool? isCellHighlightOn,
  }) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
      isDarkMode: isDarkMode ?? this.isDarkMode,

      isHapticOn: isHapticOn ?? this.isHapticOn,
      isAtomRotationOn: isAtomRotationOn ?? this.isAtomRotationOn,
      isAtomVibrationOn: isAtomVibrationOn ?? this.isAtomVibrationOn,
      isAtomBreathingOn: isAtomBreathingOn ?? this.isAtomBreathingOn,
      isCellHighlightOn: isCellHighlightOn ?? this.isCellHighlightOn,
    );
  }
}

/// Notifier for managing theme state.
class ThemeNotifier extends Notifier<ThemeState> {
  late final SettingsRepository _settingsRepository;

  @override
  ThemeState build() {
    _settingsRepository = ref.watch(settingsRepositoryProvider);
    unawaited(_loadSettings());
    return const ThemeState(currentTheme: AppThemes.defaultTheme);
  }

  Future<void> _loadSettings() async {
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    final defaultDarkMode = platformBrightness == Brightness.dark;

    final isDarkMode =
        await _settingsRepository.getDarkMode() ?? defaultDarkMode;

    final isHapticOn = await _settingsRepository.getHapticOn() ?? true;
    final isAtomRotationOn =
        await _settingsRepository.getAtomRotationOn() ?? true;
    final isAtomVibrationOn =
        await _settingsRepository.getAtomVibrationOn() ?? true;
    final isAtomBreathingOn =
        await _settingsRepository.getAtomBreathingOn() ?? true;
    final isCellHighlightOn =
        await _settingsRepository.getCellHighlightOn() ?? true;
    final themeName = await _settingsRepository.getThemeName();

    final theme = AppThemes.all.firstWhere(
      (t) => t.name == themeName,
      orElse: () => AppThemes.defaultTheme,
    );

    state = ThemeState(
      currentTheme: theme,
      isDarkMode: isDarkMode,

      isHapticOn: isHapticOn,
      isAtomRotationOn: isAtomRotationOn,
      isAtomVibrationOn: isAtomVibrationOn,
      isAtomBreathingOn: isAtomBreathingOn,
      isCellHighlightOn: isCellHighlightOn,
    );
  }

  /// Sets the current theme.
  void setTheme(AppTheme theme) {
    if (state.currentTheme.name != theme.name) {
      state = state.copyWith(currentTheme: theme);
      unawaited(_settingsRepository.setThemeName(theme.name));
    }
  }

  /// Sets theme by name. Returns true if found and set.
  bool setThemeByName(String name) {
    final theme = AppThemes.all.firstWhere(
      (t) => t.name == name,
      orElse: () => state.currentTheme,
    );
    if (theme.name != state.currentTheme.name) {
      setTheme(theme);
      return true;
    }
    return false;
  }

  /// Toggles dark mode.
  void toggleDarkMode() {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    unawaited(_settingsRepository.setDarkMode(value: newValue));
  }

  /// Sets dark mode explicitly.
  void setDarkMode({required bool value}) {
    if (state.isDarkMode != value) {
      state = state.copyWith(isDarkMode: value);
      unawaited(_settingsRepository.setDarkMode(value: value));
    }
  }

  /// Sets haptic feedback on/off.
  void setHapticOn({required bool value}) {
    if (state.isHapticOn != value) {
      state = state.copyWith(isHapticOn: value);
      unawaited(_settingsRepository.setHapticOn(value: value));
    }
  }

  /// Sets atom rotation on/off.
  void setAtomRotationOn({required bool value}) {
    if (state.isAtomRotationOn != value) {
      state = state.copyWith(isAtomRotationOn: value);
      unawaited(_settingsRepository.setAtomRotationOn(value: value));
    }
  }

  /// Sets atom vibration on/off.
  void setAtomVibrationOn({required bool value}) {
    if (state.isAtomVibrationOn != value) {
      state = state.copyWith(isAtomVibrationOn: value);
      unawaited(_settingsRepository.setAtomVibrationOn(value: value));
    }
  }

  /// Sets atom breathing on/off.
  void setAtomBreathingOn({required bool value}) {
    if (state.isAtomBreathingOn != value) {
      state = state.copyWith(isAtomBreathingOn: value);
      unawaited(_settingsRepository.setAtomBreathingOn(value: value));
    }
  }

  /// Sets cell highlight on/off.
  void setCellHighlightOn({required bool value}) {
    if (state.isCellHighlightOn != value) {
      state = state.copyWith(isCellHighlightOn: value);
      unawaited(_settingsRepository.setCellHighlightOn(value: value));
    }
  }

  /// Resets all settings to defaults, preserving the current theme.
  Future<void> resetSettings() async {
    // 1. Capture current theme
    final currentThemeName = state.currentTheme.name;

    // 2. Clear all settings (including theme)
    await _settingsRepository.clearSettings();

    // 3. Restore the theme preference
    await _settingsRepository.setThemeName(currentThemeName);

    // 4. Reload to apply defaults for everything else
    await _loadSettings();
  }
}

/// Main theme provider.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

// Derived providers for selective rebuilds

/// Current theme only.
final currentThemeProvider = Provider<AppTheme>((ref) {
  return ref.watch(themeProvider.select((s) => s.currentTheme));
});

/// Dark mode state.
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeProvider.select((s) => s.isDarkMode));
});

/// Haptic feedback state.
final isHapticOnProvider = Provider<bool>((ref) {
  return ref.watch(themeProvider.select((s) => s.isHapticOn));
});

/// Background color.
final bgColorProvider = Provider<Color>((ref) {
  return ref.watch(themeProvider.select((s) => s.bg));
});

/// Foreground color.
final fgColorProvider = Provider<Color>((ref) {
  return ref.watch(themeProvider.select((s) => s.fg));
});

/// Surface color.
final surfaceColorProvider = Provider<Color>((ref) {
  return ref.watch(themeProvider.select((s) => s.surface));
});

/// Player colors list.
final playerColorsProvider = Provider<List<Color>>((ref) {
  return ref.watch(themeProvider.select((s) => s.playerColors));
});
