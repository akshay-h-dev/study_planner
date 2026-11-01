
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's saved theme preference.
class ThemeService {
  static const String _darkModeKey = 'settings_dark_mode';

  /// Loads the saved theme preference.
  static Future<bool> loadDarkMode() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_darkModeKey) ?? false;
  }

  /// Saves the selected theme preference.
  static Future<void> saveDarkMode(bool isDarkMode) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  /// Returns the application theme.
  static ThemeData getTheme(bool isDarkMode) {
    const Color primaryColor = Color(0xFF4B2CE5);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDarkMode
            ? Brightness.dark
            : Brightness.light,
      ),
      scaffoldBackgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : Colors.white,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
      ),
    );
  }
}
