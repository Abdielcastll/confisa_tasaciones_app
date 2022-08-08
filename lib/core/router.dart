import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/views/auth/confirm_password/confirm_password_view.dart';
import 'package:tasaciones_app/views/auth/recover_password/recovery_password_view.dart';
import 'package:tasaciones_app/views/entidades_generales/acciones_pendientes/acciones_pendientes_view.dart';
import 'package:tasaciones_app/views/entidades_generales/tipos_adjuntos/tipos_adjuntos_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/acciones/acciones_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/endpoints/endpoints_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/roles/roles_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/usuarios/usuarios_view.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/componentes_vehiculo/componentes_vehiculo_view.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/condiciones_componentes_vehiculo.dart/condiciones_componentes_vehiculo_view.dart';
import 'package:tasaciones_app/views/entidades_solicitudes/segmentos_componentes_vehiculos/segmentos_componentes_vehiculos_view.dart';

import '../views/Perfil_de_usuario/perfil_view.dart';
import '../views/auth/login/login_view.dart';
import '../views/entidades_seguridad/modulos/modulos_view.dart';
import '../views/entidades_seguridad/permisos/permisos_view.dart';
import '../views/entidades_seguridad/recursos/recursos_view.dart';
import '../views/entidades_solicitudes/componentes_vehiculo_suplidor/componentes_vehiculo_suplidor_view.dart';
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

    case ConfirmPasswordView.routeName:
      return MaterialPageRoute(
          builder: (context) => const ConfirmPasswordView());

    case PerfilView.routeName:
      return CupertinoPageRoute(builder: (context) => const PerfilView());

    case AccionesView.routeName:
      return CupertinoPageRoute(builder: (context) => const AccionesView());

    case ModulosView.routeName:
      return CupertinoPageRoute(builder: (context) => const ModulosView());

    case RecursosView.routeName:
      return CupertinoPageRoute(builder: (context) => const RecursosView());

    case PermisosView.routeName:
      return CupertinoPageRoute(builder: (context) => const PermisosView());

    case UsuariosView.routeName:
      return CupertinoPageRoute(builder: (context) => const UsuariosView());

    case EndpointsView.routeName:
      return CupertinoPageRoute(builder: (context) => const EndpointsView());

    case RolesView.routeName:
      return CupertinoPageRoute(builder: (context) => const RolesView());

    case TiposAdjuntosView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const TiposAdjuntosView());

    case AccionesPendientesView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const AccionesPendientesView());

    case ComponentesVehiculoSuplidorView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const ComponentesVehiculoSuplidorView());

    case ComponentesVehiculoView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const ComponentesVehiculoView());

    case SegmentosComponentesVehiculosView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const SegmentosComponentesVehiculosView());

    case CondicionesComponentesVehiculoView.routeName:
      return CupertinoPageRoute(
          builder: (context) => const CondicionesComponentesVehiculoView());

    default:
      return MaterialPageRoute(builder: (context) => const HomeView());
  }
}
