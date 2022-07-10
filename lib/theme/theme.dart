import 'package:flutter/material.dart';

/* Colors */
class AppColors {
  static const bronce = Color.fromRGBO(235, 219, 206, 1);
  static const grey = Color.fromRGBO(230, 230, 230, 1);
  static const orange = Color(0xFFFE9301);
  static const green = Color(0xFFA8C638);
  static const brownLight = Color(0xFF98470A);
  static const brownDark = Color(0xFF442A19);
}

/* Theme */

final myTheme = ThemeData(
  cardTheme: CardTheme(
    color: AppColors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: const BorderSide(
        color: AppColors.grey,
        width: .5,
      ),
    ),
  ),
  scaffoldBackgroundColor: AppColors.bronce,
  iconTheme: const IconThemeData(size: 30),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.brownDark,
  ),
);

/* TextStyles */

TextStyle appDropdown = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

/* Durations */

Duration durationLoading = const Duration(seconds: 10);
