import 'package:flutter/material.dart';

class AppColors {
  static const brownDark = Color(0xFF442A19);
  static const brownLight = Color(0xFF984902);
  static const green = Color(0xFFA8C638);
  static const orange = Color(0xFFFE9301);
  static const bronce = Color.fromRGBO(235, 219, 206, 1);
}

final myTheme = ThemeData(
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
