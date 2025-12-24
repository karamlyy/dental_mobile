import 'package:flutter/material.dart';

class AppTextColors extends ThemeExtension<AppTextColors> {
  final Color primary;
  final Color secondary;

  const AppTextColors({
    required this.primary,
    required this.secondary,
  });

  @override
  ThemeExtension<AppTextColors> copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return AppTextColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ThemeExtension<AppTextColors> lerp(
    covariant ThemeExtension<AppTextColors>? other,
    double t,
  ) {
    if (other is! AppTextColors) {
      return this;
    }
    return AppTextColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }
}
