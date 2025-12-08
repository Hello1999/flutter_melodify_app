import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeColorOption _colorOption = ThemeColorOption.purple;

  static const String _themeModeKey = 'theme_mode';
  static const String _colorOptionKey = 'color_option';

  ThemeMode get themeMode => _themeMode;
  ThemeColorOption get colorOption => _colorOption;
  Color get seedColor => _colorOption.color;

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_themeModeKey);
    if (themeModeIndex != null && themeModeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }

    final colorIndex = prefs.getInt(_colorOptionKey);
    if (colorIndex != null && colorIndex < ThemeColorOption.values.length) {
      _colorOption = ThemeColorOption.values[colorIndex];
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> setColorOption(ThemeColorOption option) async {
    if (_colorOption == option) return;
    _colorOption = option;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorOptionKey, option.index);
  }

  Future<void> toggleThemeMode(BuildContext context) async {
    final isDark = isDarkMode(context);
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}
