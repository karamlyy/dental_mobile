import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SecureStorage storage;

  ThemeCubit(this.storage) : super(ThemeState(themeMode: ThemeMode.system));

  Future<void> loadTheme() async {
    final savedTheme = await storage.read('themeMode');
    if (savedTheme != null) {
      final themeMode = _stringToThemeMode(savedTheme);
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    await storage.write('themeMode', _themeModeToString(mode));
    emit(state.copyWith(themeMode: mode));
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
