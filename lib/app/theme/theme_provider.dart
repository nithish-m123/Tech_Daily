import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themePrefKey = 'user_theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.light;
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      if (savedTheme == 'dark') {
        state = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        state = ThemeMode.light;
      }
    } catch (_) {}
  }

  Future<void> toggleTheme(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, isDark ? 'dark' : 'light');
    } catch (_) {}
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
