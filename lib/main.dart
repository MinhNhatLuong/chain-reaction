import 'dart:async';
import 'package:chain_reaction/core/presentation/widgets/desktop_integration_wrapper.dart';
import 'package:chain_reaction/core/theme/custom_transitions.dart';
import 'package:chain_reaction/core/theme/providers/theme_provider.dart';
import 'package:chain_reaction/features/game/data/repositories/game_repository_impl.dart';
import 'package:chain_reaction/features/game/presentation/providers/game_providers.dart';
import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:chain_reaction/routing/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop Window Management
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1024, 768),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      title: 'Chain Reaction Reborn',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Keep compact Android phones portrait-oriented.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    final isPhone = logicalSize.shortestSide < 600;

    // Keep portrait lock for compact phones, allow full rotation on tablets.
    await SystemChrome.setPreferredOrientations(
      isPhone
          ? <DeviceOrientation>[
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]
          : <DeviceOrientation>[],
    );
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        gameRepositoryProvider.overrideWithValue(GameRepositoryImpl(prefs)),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    unawaited(_setHighRefreshRate());
  }

  Future<void> _setHighRefreshRate() async {
    // High refresh rate is an Android-specific API setup.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await FlutterDisplayMode.setHighRefreshRate();
      } on Object {
        // Fail silently, platform might not support it
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Chain Reaction Reborn',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
      ],
      theme: ThemeData(
        brightness: themeState.isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: themeState.bg,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: themeState.isDarkMode
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: themeState.isDarkMode
                ? Brightness.dark
                : Brightness.light,
          ),
        ),
        colorScheme: ColorScheme(
          brightness: themeState.isDarkMode
              ? Brightness.dark
              : Brightness.light,
          primary: themeState.fg,
          onPrimary: themeState.bg,
          secondary: themeState.subtitle,
          onSecondary: themeState.bg,
          surface: themeState.surface,
          onSurface: themeState.fg,
          error: themeState.currentTheme.red,
          onError: Colors.white,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FluidFadePageTransitionsBuilder(),
            TargetPlatform.windows: FluidFadePageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) {
        // Wrap the entire app (Navigator) in desktop integration wrapper
        return DesktopIntegrationWrapper(
          navigatorKey: router.routerDelegate.navigatorKey,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
