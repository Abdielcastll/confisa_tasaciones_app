import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';

import '../views/auth/login/login_view.dart';
import '../views/home/home_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case RecoveryPasswordView.routeName:
      return MaterialPageRoute(
          builder: (context) => const RecoveryPasswordView());
    default:
      return MaterialPageRoute(builder: (context) => const HomeView());
  }
}
