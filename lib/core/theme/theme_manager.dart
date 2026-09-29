import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme manager to handle theme switching and persistence
class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadTheme();
  }

  /// Load saved theme preference
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  /// Set theme mode and save to preferences
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  /// Check if current theme is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if following system theme
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get theme mode name
  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}
