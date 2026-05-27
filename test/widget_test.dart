import 'package:chain_reaction/features/home/presentation/screens/home_screen.dart';
import 'package:chain_reaction/features/settings/presentation/providers/settings_providers.dart';
import 'package:chain_reaction/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MainApp(),
      ),
    );

    // Wait for Splash Screen to finish (2 seconds delay)
    await tester.pump(const Duration(seconds: 2, milliseconds: 100));

    // Allow the navigation to process (microtasks)
    await tester.pump();

    // Wait for the navigation transition (600ms) to complete
    await tester.pump(const Duration(seconds: 1));

    // Verify that our app builds and shows Home Screen elements.

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
