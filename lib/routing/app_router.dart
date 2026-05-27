import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/presentation/screens/game_screen.dart';
import 'package:chain_reaction/features/game/presentation/screens/winner_screen.dart';
// Screen imports
import 'package:chain_reaction/features/home/presentation/screens/home_screen.dart';
import 'package:chain_reaction/features/home/presentation/screens/info_screen.dart';
import 'package:chain_reaction/features/settings/presentation/screens/settings_screen.dart';
import 'package:chain_reaction/features/shop/presentation/screens/palette_screen.dart';
import 'package:chain_reaction/features/shop/presentation/screens/purchase_screen.dart';
import 'package:chain_reaction/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provider for the GoRouter instance.
final goRouterProvider = Provider<GoRouter>((ref) {
  // Future: Add authentication state listening logic here.

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // Helpful for debugging
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRouteNames.home,
        pageBuilder: (context, state) =>
            _fadeTransition(context, state, const HomeScreen()),
      ),
      GoRoute(
        path: '/${AppRoutes.game}',
        name: AppRouteNames.game,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final playerCount = extras?['playerCount'] as int?;
          final gridSize = extras?['gridSize'] as String?;
          final aiDifficulty = extras?['aiDifficulty'] as AIDifficulty?;
          final isResuming = extras?['isResuming'] as bool? ?? false;

          return _fadeTransition(
            context,
            state,
            GameScreen(
              playerCount: playerCount,
              gridSize: gridSize,
              aiDifficulty: aiDifficulty,
              isResuming: isResuming,
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRoutes.winner}',
        name: AppRouteNames.winner,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final winnerPlayerIndex = extras?['winnerPlayerIndex'] as int? ?? 1;
          final winnerName = extras?['winnerName'] as String?;
          final totalMoves = extras?['totalMoves'] as int? ?? 0;
          final gameDuration = extras?['gameDuration'] as String? ?? '00:00';
          final territoryPercentage =
              extras?['territoryPercentage'] as int? ?? 100;
          final playerCount = extras?['playerCount'] as int? ?? 2;
          final gridSize = extras?['gridSize'] as String? ?? 'medium';
          final aiDifficulty = extras?['aiDifficulty'] as AIDifficulty?;

          return _fadeTransition(
            context,
            state,
            WinnerScreen(
              winnerPlayerIndex: winnerPlayerIndex,
              winnerName: winnerName,
              totalMoves: totalMoves,
              gameDuration: gameDuration,
              territoryPercentage: territoryPercentage,
              playerCount: playerCount,
              gridSize: gridSize,
              aiDifficulty: aiDifficulty,
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRoutes.settings}',
        name: AppRouteNames.settings,
        pageBuilder: (context, state) =>
            _fadeTransition(context, state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/${AppRoutes.shop}',
        name: AppRouteNames.shop,
        pageBuilder: (context, state) =>
            _fadeTransition(context, state, const PurchaseScreen()),
      ),
      GoRoute(
        path: '/${AppRoutes.palette}',
        name: AppRouteNames.palette,
        pageBuilder: (context, state) =>
            _fadeTransition(context, state, const PaletteScreen()),
      ),
      GoRoute(
        path: '/${AppRoutes.info}',
        name: AppRouteNames.info,
        pageBuilder: (context, state) =>
            _fadeTransition(context, state, const InfoScreen()),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
});

CustomTransitionPage<void> _fadeTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeOut).animate(animation),
        child: child,
      );
    },
  );
}
