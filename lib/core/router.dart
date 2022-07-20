import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/acciones/acciones_view.dart';

import '../views/Perfil_de_usuario/perfil_view.dart';
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
    case PerfilView.routeName:
      return CupertinoPageRoute(builder: (context) => const PerfilView());
    case AccionesView.routeName:
      return CupertinoPageRoute(builder: (context) => const AccionesView());
    default:
      return MaterialPageRoute(builder: (context) => const HomeView());
  }
}
