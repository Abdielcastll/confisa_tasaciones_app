import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/acciones/acciones_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/entidades_seguridad_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/usuarios/usuarios_view.dart';

import '../views/Perfil_de_usuario/perfil_view.dart';
import '../views/auth/login/login_view.dart';
import '../views/entidades_seguridad/permisos/permisos_view.dart';
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
    case EntidadesSeguridadView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const EntidadesSeguridadView());
    case AccionesView.routeName:
      return CupertinoPageRoute(builder: (context) => const AccionesView());
    case PermisosView.routeName:
      return CupertinoPageRoute(builder: (context) => const PermisosView());
    case UsuariosView.routeName:
      return CupertinoPageRoute(builder: (context) => const UsuariosView());
    default:
      return MaterialPageRoute(builder: (context) => const HomeView());
  }
}
