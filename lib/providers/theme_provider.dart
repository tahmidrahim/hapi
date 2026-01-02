// lib/providers/theme_provider.dart
import 'package:flutter_riverpod/legacy.dart';
import 'package:hapi/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'dark') {
      state = ThemeMode.dark;
    } else if (theme == 'light') {
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString('theme', 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString('theme', 'light');
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
