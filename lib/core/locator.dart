import 'package:dio/dio.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/api/constants.dart';
import 'package:tasaciones_app/core/api/http.dart';

import '../core/logger.dart';
import '../core/services/navigator_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt locator = GetIt.instance;

class LocatorInjector {
  static final Logger _log = getLogger('LocatorInjector');

  static Future<void> setupLocator() async {
    _log.d('Initializing Navigator Service');
    locator.registerLazySingleton(() => NavigatorService());
  }
}

abstract class DependencyInjection {
  static void initialize() {
    final Dio dio = Dio(BaseOptions(baseUrl: server));
    Logger logger = Logger();
    Http http = Http(dio: dio, logger: logger, logsEnabled: true);
    final AuthenticationAPI authenticationAPI = AuthenticationAPI(http);
    GetIt.instance.registerSingleton<AuthenticationAPI>(authenticationAPI);
  }
}
