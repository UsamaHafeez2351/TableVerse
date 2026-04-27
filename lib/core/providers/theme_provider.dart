import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Theme mode enum
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_mode') ?? 'system';
    
    switch (savedTheme) {
      case 'light':
        state = AppTheme.lightTheme;
        break;
      case 'dark':
        state = AppTheme.darkTheme;
        break;
      default:
        state = AppTheme.lightTheme;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (mode) {
      case AppThemeMode.light:
        state = AppTheme.lightTheme;
        await prefs.setString('theme_mode', 'light');
        break;
      case AppThemeMode.dark:
        state = AppTheme.darkTheme;
        await prefs.setString('theme_mode', 'dark');
        break;
      case AppThemeMode.system:
        await prefs.setString('theme_mode', 'system');
        break;
    }
  }

  Future<void> toggleTheme() async {
    final isDark = state.brightness == Brightness.dark;
    if (isDark) {
      state = AppTheme.lightTheme;
    } else {
      state = AppTheme.darkTheme;
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', isDark ? 'light' : 'dark');
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
