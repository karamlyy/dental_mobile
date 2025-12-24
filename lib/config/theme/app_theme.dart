import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_theme_extension.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      extensions: const [
        AppTextColors(
          primary: AppColors.lightPrimaryText,
          secondary: AppColors.lightSecondaryText,
        ),
      ],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      extensions: const [
        AppTextColors(
          primary: AppColors.darkPrimaryText,
          secondary: AppColors.darkSecondaryText,
        ),
      ],
    );
  }
}
