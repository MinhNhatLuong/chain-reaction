class AppDimensions {
  // Padding & Margins
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32; // formerly used as SizedBox height 32
  static const double paddingXXL = 40;
  static const double spacingXXL = 48; // Specific large spacing
  static const double paddingXXXL = 64; // found in winner screen

  // Border Radius
  static const double radiusS = 12;
  static const double radiusM = 24; // for dialogs

  // Icon Sizes
  static const double iconS = 16;
  static const double iconM = 20;
  static const double iconL = 28;

  // Font Sizes
  static const double fontXS = 12;
  static const double fontS = 14;
  static const double fontM = 16;
  static const double fontL = 18;
  static const double fontXL = 20;
  static const double fontXXL = 24;
  static const double fontGiant = 40; // for Winner text

  // Specific Elements
  static const double pillButtonHeight = 56;
  static const double pillButtonBorderWidth = 1.5;
  static const double letterSpacingHeader = 1.5;
  static const double letterSpacingTitle = 2; // game selector
  static const double colorCircleSize = 24; // Standard color circle size

  // Orb/Grid
  static const double orbSizeLarge = 160; // Home screen central orb
  static const double orbSizeMedium = 80;
  static const double orbSizeSmall = 20; // Atom circle
  static const double orbBorderWidth = 16; // Central orb border

  // Game Grid Configurations
  static const double gridPadding = 16;
  static const double cellSpacing = 2;

  // Grid Sizes: (rows, cols)
  static const Map<String, (int, int)> gridSizes = {
    'x_small': (6, 4),
    'small': (8, 5),
    'medium': (10, 6),
    'large': (12, 7),
    'x_large': (14, 8),
  };

  // Animation durations (ms)
  static const int explosionDurationMs = 50;
  static const int flightDurationMs = 250;
  static const int turnTransitionMs = 200;

  // UI Components
  static const double actionButtonSize = 48;
  static const double playerIndicatorSize = 8;
  static const double loaderStrokeWidth = 2;

  // Atom Rendering
  static const double atomShadowBlur = 8;
  static const double atomShadowOpacity = 0.4;
  static const double atomVibrationAmplitude = 0.8;
  static const double atomVibrationFrequency = 100;
  static const double atomBreathingScaleBy = 0.15;
  static const double atomSpacing2 = 6;
  // Triangle Layout (Count 3)
  static const double atomTriangleTopY = 8;
  static const double atomTriangleBottomX = 7;
  static const double atomTriangleBottomY = 5;
  // Square Layout (Count 4)
  static const double atomSpacing4 = 12;

  // Grid & Cell
  static const double gridBorderWidth = 0.5;
  static const double gridBorderOpacity = 0.5;
  static const double cellHighlightOpacity = 0.1;
  static const double cellHoverOpacity = 0.2;
  static const double cellSplashOpacity = 0.3;
  static const int cellAnimationDurationMs = 300;
  static const int masterAnimationDurationSec = 4;

  // Buttons
  static const double buttonPressScale = 0.96;
  static const int buttonPressDurationMs = 100;
  static const double letterSpacingButton = 1.2;
  static const double disabledOpacity = 0.3;
  static const double activeOpacity = 1;
  static const double surfaceOpacity = 0.1;
  static const double outlineOpacity = 0.3;
}
