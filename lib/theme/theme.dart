import 'package:flutter/material.dart';

/* Colors */
class AppColors {
  static const bronce = Color.fromRGBO(235, 219, 206, 1);
  static const grey = Color.fromRGBO(230, 230, 230, 1);
  static const orange = Color(0xFFFE9301);
  static const darkOrange = Color.fromRGBO(255, 135, 44, 1);
  static const green = Color(0xFFA8C638);
  static const brownLight2 = Color(0xFFAC6D3A);
  static const brownLight = Color(0xFF98470A);
  static const brownDark = Color(0xFF442A19);
  static const white = Colors.white;
  static const gold = Color.fromRGBO(222, 158, 61, 1);
  static const cream = Color.fromRGBO(255, 247, 235, 1);
  static const lightGreen = Color.fromRGBO(46, 226, 146, 1);
}

// final theme = ThemeData(
//   primaryColor: AppColors.brownDark,
//   colorScheme: const ColorScheme.light(
//     primary: AppColors.brownDark,
//     secondary: AppColors.brownLight,
//   ),
//   iconTheme: const IconThemeData(
//     color: AppColors.brownLight,
//   ),

//   /*checkboxTheme: CheckboxThemeData(
//     side: MaterialStateBorderSide.resolveWith(
//         (_) => const BorderSide(width: 1.5, color: AppColors.blue)),
//     fillColor: MaterialStateProperty.all(AppColors.blue),
//     checkColor: MaterialStateProperty.all(Colors.white),
//   ),*/
// );
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
  scaffoldBackgroundColor: AppColors.white,
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
