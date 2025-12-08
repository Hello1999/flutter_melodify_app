import 'package:flutter/material.dart';

/// 主题颜色选项
enum ThemeColorOption {
  purple('Purple', Color(0xFF7C4DFF)),
  blue('Ocean Blue', Color(0xFF2196F3)),
  teal('Teal', Color(0xFF009688)),
  green('Forest', Color(0xFF4CAF50)),
  orange('Sunset', Color(0xFFFF5722)),
  pink('Rose', Color(0xFFE91E63)),
  red('Cherry', Color(0xFFF44336)),
  indigo('Indigo', Color(0xFF3F51B5));

  const ThemeColorOption(this.label, this.color);
  final String label;
  final Color color;
}

class AppColors {
  AppColors._();

  // 功能性颜色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // 播放器特殊颜色
  static const Color shuffleActive = Color(0xFF1DB954);
  static const Color repeatActive = Color(0xFF1DB954);

  static ColorScheme lightScheme(Color seedColor) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  static ColorScheme darkScheme(Color seedColor) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }
}
