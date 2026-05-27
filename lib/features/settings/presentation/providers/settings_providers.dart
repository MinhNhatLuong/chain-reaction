import 'package:chain_reaction/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:chain_reaction/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the SharedPreferences instance.
/// Must be overridden in main.dart with `sharedPreferencesProvider.overrideWithValue(prefs)`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// Provider for the SettingsRepository.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs);
});
