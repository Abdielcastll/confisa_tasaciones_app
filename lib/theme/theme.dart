import 'package:flutter/material.dart';

class AppColors {
  static const orange = Color(0xFFFE9301);
  static const green = Color(0xFFA8C638);
  static const brownLight = Color(0xFF98470A);
  static const brownDark = Color(0xFF442A19);
}

final theme = ThemeData(
  primaryColor: AppColors.brownDark,
  colorScheme: const ColorScheme.light(
    primary: AppColors.brownDark,
    secondary: AppColors.brownLight,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.brownLight,
  ),

  /*checkboxTheme: CheckboxThemeData(
    side: MaterialStateBorderSide.resolveWith(
        (_) => const BorderSide(width: 1.5, color: AppColors.blue)),
    fillColor: MaterialStateProperty.all(AppColors.blue),
    checkColor: MaterialStateProperty.all(Colors.white),
  ),*/
);
