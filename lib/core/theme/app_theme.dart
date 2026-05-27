import 'package:flutter/material.dart';

enum AtomShape { circle, square, roundedSquare, diamond }

/// Represents a complete color theme for the application.
/// Supports both light and dark modes with a standardized 10-color palette.
class AppTheme {
  const AppTheme({
    required this.name,
    required this.bgDark,
    required this.bgLight,
    required this.fgDark,
    required this.fgLight,
    required this.red,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.purple,
    required this.aqua,
    required this.orange,
    this.isPremium = false,
    this.price,
  });
  final String name;

  // Mode-specific colors
  final Color bgDark;
  final Color bgLight;
  final Color fgDark;
  final Color fgLight;

  // Accent colors (same for both modes)
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color purple;
  final Color aqua;
  final Color orange;

  // Shop properties
  final bool isPremium;
  final String? price;

  /// Get background color based on dark mode
  /// Get background color based on dark mode
  Color bg({required bool isDark}) => isDark ? bgDark : bgLight;

  /// Get foreground/text color based on dark mode
  Color fg({required bool isDark}) => isDark ? fgDark : fgLight;

  /// Get surface color (slightly lighter/darker than bg)
  Color surface({required bool isDark}) {
    final bgColor = bg(isDark: isDark);
    return isDark
        ? Color.lerp(bgColor, Colors.white, 0.05)!
        : Color.lerp(bgColor, Colors.black, 0.03)!;
  }

  /// Get subtitle color (dimmed foreground)
  Color subtitle({required bool isDark}) =>
      fg(isDark: isDark).withValues(alpha: 0.7);

  /// Get border color (very dimmed foreground)
  Color border({required bool isDark}) =>
      fg(isDark: isDark).withValues(alpha: 0.15);

  /// Get player colors list (fg as first player, then accent colors)
  List<Color> playerColors({required bool isDark}) => [
    fg(isDark: isDark),
    red,
    green,
    yellow,
    blue,
    purple,
    aqua,
    orange,
  ];

  /// Get all 10 colors for display in Palette Screen
  List<Color> paletteColors({required bool isDark}) => [
    bg(isDark: isDark),
    surface(isDark: isDark),
    fg(isDark: isDark),
    red,
    green,
    yellow,
    blue,
    purple,
    aqua,
    orange,
  ];

  /// Returns a player color by index (1-indexed)
  Color getPlayerColor(int playerIndex, {required bool isDark}) {
    final colors = playerColors(isDark: isDark);
    if (playerIndex <= 0 || colors.isEmpty) return Colors.transparent;
    return colors[(playerIndex - 1) % colors.length];
  }
}

/// All available themes in the application.
class AppThemes {
  static const AppTheme defaultTheme = AppTheme(
    name: 'Default',
    bgDark: Color(0xFF151515),
    bgLight: Color(0xFFF5F5F5),
    fgDark: Color(0xFFEEEEEE),
    fgLight: Color(0xFF1A1A1A),
    red: Color(0xFFD32F2F),
    green: Color(0xFF388E3C),
    yellow: Color(0xFFFBC02D),
    blue: Color(0xFF1976D2),
    purple: Color(0xFF7B1FA2),
    aqua: Color(0xFF00ACC1),
    orange: Color(0xFFF57C00),
  );

  static const AppTheme earthy = AppTheme(
    name: 'Earthy',
    bgDark: Color(0xFF282828),
    bgLight: Color(0xFFFBF1C7),
    fgDark: Color(0xFFEBDBB2),
    fgLight: Color(0xFF3C3836),
    red: Color(0xFFCC241D),
    green: Color(0xFF98971A),
    yellow: Color(0xFFD79921),
    blue: Color(0xFF458588),
    purple: Color(0xFFB16286),
    aqua: Color(0xFF689D6A),
    orange: Color(0xFFD65D0E),
    isPremium: true,
    price: r'$0.99',
  );

  static const AppTheme pastel = AppTheme(
    name: 'Pastel',
    bgDark: Color(0xFF262626),
    bgLight: Color(0xFFFFFDF5),
    fgDark: Color(0xFFF5F5F5),
    fgLight: Color(0xFF404040),
    // Increased contrast/separation while keeping pastel vibe
    red: Color(0xFFFF6961), // Pastel Red
    green: Color(0xFF77DD77), // Pastel Green
    yellow: Color(0xFFFDFD96), // Pastel Yellow
    blue: Color(0xFF84B6F4), // Pastel Blue
    purple: Color(0xFFB39EB5), // Pastel Purple
    aqua: Color(0xFF76D7C4), // Pastel Teal/Aqua
    orange: Color(0xFFFFB347), // Pastel Orange
    isPremium: true,
    price: r'$0.99',
  );

  static const AppTheme amoled = AppTheme(
    name: 'Amoled',
    bgDark: Color(0xFF000000), // Deep Arcade Black
    bgLight: Color(0xFFFFFFFF), // Classic Console Gray
    fgDark: Color(0xFFFFFFFF), // Crisp White Text (Fixes clash with Green)
    fgLight: Color(0xFF000000),
    // 8-Bit / Arcade Palette (High Saturation)
    red: Color(0xFFFF0000), // Red
    green: Color(0xFF00FF00), // Green
    yellow: Color(0xFFFFFF00), // Yellow
    blue: Color(0xFF0000FF), // Blue
    purple: Color(0xFF800080), // Purple
    aqua: Color(0xFF00FFFF), // Aqua
    orange: Color(0xFFFFA500), // Orange
    isPremium: true,
    price: r'$0.99',
  );

  /// List of all available themes.
  static const List<AppTheme> all = [defaultTheme, earthy, pastel, amoled];
}
