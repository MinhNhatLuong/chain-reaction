import 'package:chain_reaction/features/game/domain/entities/player.dart';
import 'package:chain_reaction/features/game/presentation/screens/winner_screen.dart';
import 'package:chain_reaction/features/settings/domain/repositories/settings_repository.dart';
import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:chain_reaction/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSettingsRepository implements SettingsRepository {
  @override
  Future<bool?> getDarkMode() async => true;

  @override
  Future<bool?> getHapticOn() async => true;

  @override
  Future<String?> getThemeName() async => 'Default';

  @override
  Future<void> setDarkMode({required bool value}) async {}

  @override
  Future<void> setHapticOn({required bool value}) async {}

  @override
  Future<void> setThemeName(String value) async {}

  @override
  Future<bool?> getAtomRotationOn() async => true;

  @override
  Future<void> setAtomRotationOn({required bool value}) async {}

  @override
  Future<bool?> getAtomVibrationOn() async => true;

  @override
  Future<void> setAtomVibrationOn({required bool value}) async {}

  @override
  Future<bool?> getCellHighlightOn() async => true;

  @override
  Future<void> setCellHighlightOn({required bool value}) async {}

  @override
  Future<bool?> getAtomBreathingOn() async => true;

  @override
  Future<void> setAtomBreathingOn({required bool value}) async {}

  @override
  Future<void> clearSettings() async {}
}

void main() {
  testWidgets('WinnerScreen prefers provided winnerName', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            MockSettingsRepository(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en')],
          home: WinnerScreen(
            playerCount: 2,
            gridSize: 'small',
            winnerPlayerIndex: 2,
            winnerName: 'Computer',
            aiDifficulty: AIDifficulty.easy,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Computer'), findsOneWidget);
    expect(find.text('Player 2'), findsNothing);
  });
}
