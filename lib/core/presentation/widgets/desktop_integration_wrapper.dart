import 'dart:async';

import 'package:chain_reaction/core/constants/constants.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class QuitIntent extends Intent {
  const QuitIntent();
}

class GoBackIntent extends Intent {
  const GoBackIntent();
}

class ToggleFullscreenIntent extends Intent {
  const ToggleFullscreenIntent();
}

/// A wrapper that adds Desktop-specific integrations:
/// - Global Keyboard Shortcuts (Esc, F11, Ctrl+Q)
/// - Native Menu Bar
/// - Mouse Back/Forward button support
class DesktopIntegrationWrapper extends StatelessWidget {
  const DesktopIntegrationWrapper({
    required this.child,
    required this.navigatorKey,
    super.key,
  });
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: l10n?.menuLabel ?? 'Menu',
          menus: [
            PlatformMenuItem(
              label: l10n?.aboutLabel ?? 'About',
              onSelected: () {
                showAboutDialog(
                  context: navigatorKey.currentContext!,
                  applicationName: l10n?.appName ?? 'Chain Reaction',
                  applicationVersion: AppConstants.appVersion,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.copyright, size: 14),
                        const SizedBox(width: 4),
                        Text(l10n?.appLegalese ?? '2026 Chain Reaction Reborn'),
                      ],
                    ),
                  ],
                );
              },
            ),
            if (PlatformProvidedMenuItem.hasMenu(
              PlatformProvidedMenuItemType.quit,
            ))
              const PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.quit,
              ),
          ],
        ),
        PlatformMenu(
          label: l10n?.viewLabel ?? 'View',
          menus: [
            PlatformMenuItem(
              label: l10n?.toggleFullscreen ?? 'Toggle Fullscreen',
              shortcut: const SingleActivator(LogicalKeyboardKey.f11),
              onSelected: _toggleFullscreen,
            ),
          ],
        ),
      ],
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): GoBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyQ, control: true): QuitIntent(),
          SingleActivator(LogicalKeyboardKey.f11): ToggleFullscreenIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GoBackIntent: CallbackAction<GoBackIntent>(
              onInvoke: (intent) =>
                  unawaited(navigatorKey.currentState?.maybePop()),
            ),
            QuitIntent: CallbackAction<QuitIntent>(
              onInvoke: (intent) {
                if (!kIsWeb) {
                  unawaited(windowManager.close());
                }
                return null;
              },
            ),
            ToggleFullscreenIntent: CallbackAction<ToggleFullscreenIntent>(
              onInvoke: (intent) => unawaited(_toggleFullscreen()),
            ),
          },
          child: Listener(
            onPointerDown: (event) {
              // Mouse Back Button (Often button 8, or "Back" on some mice)
              if (event.buttons == 8) {
                unawaited(navigatorKey.currentState?.maybePop());
              }
            },
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFullscreen() async {
    if (kIsWeb) return; // WindowManager not supported on Web
    final isFullScreen = await windowManager.isFullScreen();
    if (isFullScreen) {
      unawaited(windowManager.setFullScreen(false));
    } else {
      unawaited(windowManager.setFullScreen(true));
    }
  }
}
