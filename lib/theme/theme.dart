import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:themify_flutter/themify_flutter.dart';

/* Colors */
class AppColors {
  static const bronce = Color.fromRGBO(235, 219, 206, 1);
  static const grey = Color.fromRGBO(230, 230, 230, 1);
  static const orange = Color(0xFFFE9301);
  static const darkOrange = Color.fromRGBO(255, 135, 44, 1);
  static const green = Color(0xFFA8C638);
  static const brownLight = Color(0xFFDE9E3D);
  static const brown = Color(0xFFB06428);
  static const brownDark = Color(0xFF6D4420);
  static const white = Color(0xfffff7eb);
  static const gold = Color.fromRGBO(222, 158, 61, 1);
  static const cream = Color.fromRGBO(255, 247, 235, 1);
  static const lightGreen = Color.fromRGBO(46, 226, 146, 1);
  static const newBrownDark = Color.fromRGBO(109, 68, 32, 1);
}

class AppIcons {
  static const paperPlane = FontAwesomeIcons.paperPlane;
  static const pencilAlt = FontAwesomeIcons.penToSquare;
  static const closeCircle = Icons.cancel_outlined;
  static const accountOutline = Icons.account_circle_outlined;
  static const messageOutline = Icons.messenger_outline_sharp;
  static const checkCircle = Icons.check_circle_outline;
  static const iconPlus = Icons.add_circle_outline;
  static const trash = Themify.trash;
  static const arrowCircleLeft = Themify.arrow_circle_left;
  static const arrowCircleRight = Themify.arrow_circle_right;
  static const bell = Themify.bell;
  static const calendar = Themify.calendar;
  static const timer = Themify.calendar;
  static const search = Themify.search;
  static const save = Themify.save;
  static const personOutline = Icons.person_outline;
  static const nonCheckCircle = Icons.circle_outlined;
}

final myTheme = ThemeData(
  primaryColor: AppColors.brownDark,
  colorScheme: const ColorScheme.light(
    primary: AppColors.brownDark,
    secondary: AppColors.brown,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  ),
  scaffoldBackgroundColor: AppColors.white,
  iconTheme: const IconThemeData(size: 30),
  appBarTheme: const AppBarTheme(
    elevation: 3,
    backgroundColor: AppColors.brownLight,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: Colors.white,
    ),
  ),
);

/* TextStyles */

TextStyle appDropdown = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

/* Durations */

Duration durationLoading = const Duration(seconds: 20);
