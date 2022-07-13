import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasaciones_app/core/api/acciones_api.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/api/constants.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/api/permisos_api.dart';
import 'package:tasaciones_app/core/api/roles_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';

import '../core/logger.dart';
import '../core/services/navigator_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'api/recursos_api.dart';
import 'api/usuarios_api.dart';

GetIt locator = GetIt.instance;

class LocatorInjector {
  static final Logger _log = getLogger('LocatorInjector');

  static Future<void> setupLocator() async {
    _log.d('Initializing Navigator Service');
    locator.registerLazySingleton(() => NavigatorService());
  }
}

abstract class DependencyInjection {
  static Future<void> initialize() async {
    final Dio dio = Dio(BaseOptions(baseUrl: server));
    Logger logger = Logger();
    Http http = Http(dio: dio, logger: logger, logsEnabled: true);
    final storage = await SharedPreferences.getInstance();

    final authenticationAPI = AuthenticationAPI(http);

    final authenticationClient =
        AuthenticationClient(storage, authenticationAPI);
    final rolesAPI = RolesAPI(http, authenticationClient);
    final permisosAPI = PermisosAPI(http, authenticationClient);
    final usuariosAPI = UsuariosAPI(http, authenticationClient);
    final accionesAPI = AccionesAPI(http, authenticationClient);
    final recursosAPI = RecursosAPI(http, authenticationClient);

    locator.registerSingleton<AuthenticationAPI>(authenticationAPI);
    locator.registerSingleton<RolesAPI>(rolesAPI);
    locator.registerSingleton<AccionesAPI>(accionesAPI);
    locator.registerSingleton<PermisosAPI>(permisosAPI);
    locator.registerSingleton<UsuariosAPI>(usuariosAPI);
    locator.registerSingleton<RecursosAPI>(recursosAPI);
    locator.registerSingleton<AuthenticationClient>(authenticationClient);
  }
}
