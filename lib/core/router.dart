import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/home/home_view.dart';
import 'package:tasaciones_app/views/login/login_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    default:
      return MaterialPageRoute(builder: (context) => const HomeView());
  }
}
