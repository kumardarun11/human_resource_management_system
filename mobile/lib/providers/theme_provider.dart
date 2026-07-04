import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load saved theme
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themeKey) ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  /// Change Theme
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await prefs.setBool(_themeKey, true);
    } else {
      _themeMode = ThemeMode.light;
      await prefs.setBool(_themeKey, false);
    }

    notifyListeners();
  }

  /// Set Theme Directly
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = mode;

    await prefs.setBool(
      _themeKey,
      mode == ThemeMode.dark,
    );

    notifyListeners();
  }

  /// Helper
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}