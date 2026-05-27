import 'package:chain_reaction/features/settings/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [SettingsRepository] using [SharedPreferences].
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);
  final SharedPreferences _prefs;

  static const String _keyDarkMode = 'isDarkMode';

  static const String _keyHapticOn = 'isHapticOn';
  static const String _keyThemeName = 'themeName';

  @override
  Future<bool?> getDarkMode() async {
    return _prefs.getBool(_keyDarkMode);
  }

  @override
  Future<void> setDarkMode({required bool value}) async {
    await _prefs.setBool(_keyDarkMode, value);
  }

  @override
  Future<bool?> getHapticOn() async {
    return _prefs.getBool(_keyHapticOn);
  }

  @override
  Future<void> setHapticOn({required bool value}) async {
    await _prefs.setBool(_keyHapticOn, value);
  }

  @override
  Future<String?> getThemeName() async {
    return _prefs.getString(_keyThemeName);
  }

  @override
  Future<void> setThemeName(String value) async {
    await _prefs.setString(_keyThemeName, value);
  }

  static const String _keyAtomRotationOn = 'isAtomRotationOn';
  static const String _keyAtomVibrationOn = 'isAtomVibrationOn';

  @override
  Future<bool?> getAtomRotationOn() async {
    return _prefs.getBool(_keyAtomRotationOn);
  }

  @override
  Future<void> setAtomRotationOn({required bool value}) async {
    await _prefs.setBool(_keyAtomRotationOn, value);
  }

  @override
  Future<bool?> getAtomVibrationOn() async {
    return _prefs.getBool(_keyAtomVibrationOn);
  }

  @override
  Future<void> setAtomVibrationOn({required bool value}) async {
    await _prefs.setBool(_keyAtomVibrationOn, value);
  }

  static const String _keyCellHighlightOn = 'isCellHighlightOn';

  @override
  Future<bool?> getCellHighlightOn() async {
    return _prefs.getBool(_keyCellHighlightOn);
  }

  @override
  Future<void> setCellHighlightOn({required bool value}) async {
    await _prefs.setBool(_keyCellHighlightOn, value);
  }

  static const String _keyAtomBreathingOn = 'isAtomBreathingOn';

  @override
  Future<bool?> getAtomBreathingOn() async {
    return _prefs.getBool(_keyAtomBreathingOn);
  }

  @override
  Future<void> setAtomBreathingOn({required bool value}) async {
    await _prefs.setBool(_keyAtomBreathingOn, value);
  }

  @override
  Future<void> clearSettings() async {
    await Future.wait([
      _prefs.remove(_keyDarkMode),

      _prefs.remove(_keyHapticOn),
      _prefs.remove(_keyThemeName),
      _prefs.remove(_keyAtomRotationOn),
      _prefs.remove(_keyAtomVibrationOn),
      _prefs.remove(_keyCellHighlightOn),
      _prefs.remove(_keyAtomBreathingOn),
    ]);
  }
}
