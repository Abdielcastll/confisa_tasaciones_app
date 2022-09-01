import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasaciones_app/core/api/acciones_api.dart';
import 'package:tasaciones_app/core/api/acciones_solicitud_api.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/autentication_api.dart';
import 'package:tasaciones_app/core/api/constants.dart';
import 'package:tasaciones_app/core/api/endpoints_api.dart';
import 'package:tasaciones_app/core/api/http.dart';
import 'package:tasaciones_app/core/api/notas.dart';
import 'package:tasaciones_app/core/api/permisos_api.dart';
import 'package:tasaciones_app/core/api/personal_api.dart';
import 'package:tasaciones_app/core/api/roles_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/parametros_servidor_email_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_generales/suplidores_default.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/accesorios_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/accesorios_suplidor_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/condiciones_componentes_vehiculo_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/fotos_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_eliminacion_data_grafica_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/periodo_tasacion_promedio_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/segmentos_accesorios_vehiculos_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/segmentos_componentes_vehiculos_api.dart';
import 'package:tasaciones_app/core/api/seguridad_entidades_solicitudes/vencimiento_estados_api.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/api/suplidores_api.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/user_client.dart';

import '../core/logger.dart';
import '../core/services/navigator_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'api/modulos_api.dart';
import 'api/recursos_api.dart';
import 'api/seguridad_entidades_generales/accion_pendiente.dart';
import 'api/seguridad_entidades_generales/adjuntos.dart';
import 'api/seguridad_entidades_solicitudes/componentes_vehiculo_suplidor_api.dart';
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
    final usuariosAPI = UsuariosAPI(http, authenticationClient);
    final adjuntosAPI = AdjuntosApi(http, authenticationClient);
    final accionesPendientesAPI =
        AccionesPendientesApi(http, authenticationClient);
    final userClient = UserClient(storage, usuariosAPI);
    final personalApi = PersonalApi(http, authenticationClient);
    final componenteVehiculoSuplidorApi =
        ComponentesVehiculoSuplidorApi(http, authenticationClient);
    final accionesApi = AccionesApi(http, authenticationClient);
    final segmentosComponentesVehiculosApi =
        SegmentosComponentesVehiculosApi(http, authenticationClient);
    final segmentosAccesoriosVehiculosApi =
        SegmentosAccesoriosVehiculosApi(http, authenticationClient);
    final componentesVehiculoApi =
        ComponentesVehiculoApi(http, authenticationClient);
    final accesoriosApi = AccesoriosApi(http, authenticationClient);
    final alarmasApi = AlarmasApi(http, authenticationClient);
    final accesoriosSuplidorApi =
        AccesoriosSuplidorApi(http, authenticationClient);
    final vencimientoEstadosApi =
        VencimientoEstadosApi(http, authenticationClient);
    final periodoEliminacionDataGraficaApi =
        PeriodoEliminacionDataGraficaApi(http, authenticationClient);
    final notasApi = NotasApi(http, authenticationClient);
    final condicionesComponentesVehiculoApi =
        CondicionesComponentesVehiculoApi(http, authenticationClient);
    final periodoTasacionPromedioApi =
        PeriodoTasacionPromedioApi(http, authenticationClient);
    final fotosApi = FotosApi(http, authenticationClient);
    final rolesAPI = RolesAPI(http, authenticationClient);
    final permisosAPI = PermisosAPI(http, authenticationClient);
    final recursosAPI = RecursosAPI(http, authenticationClient);
    final endpointsAPI = EndpointsApi(http, authenticationClient);
    final parametrosServidorEmailApi =
        ParametrosServidorEmailApi(http, authenticationClient);
    final modulosAPI = ModulosApi(http, authenticationClient);
    final suplidoresAPI = SuplidoresApi(http, authenticationClient);
    final suplidoresDefaultAPI =
        SuplidoresDefaultApi(http, authenticationClient);
    final solicitudesAPI = SolicitudesApi(http, authenticationClient);
    final accionesSolicitudApi =
        AccionesSolicitudApi(http, authenticationClient);

    locator.registerSingleton<AuthenticationAPI>(authenticationAPI);
    locator.registerSingleton<RolesAPI>(rolesAPI);
    locator.registerSingleton<PermisosAPI>(permisosAPI);
    locator.registerSingleton<AdjuntosApi>(adjuntosAPI);
    locator.registerSingleton<AccionesPendientesApi>(accionesPendientesAPI);
    locator.registerSingleton<UsuariosAPI>(usuariosAPI);
    locator.registerSingleton<RecursosAPI>(recursosAPI);
    locator.registerSingleton<AlarmasApi>(alarmasApi);
    locator.registerSingleton<VencimientoEstadosApi>(vencimientoEstadosApi);
    locator.registerSingleton<PeriodoEliminacionDataGraficaApi>(
        periodoEliminacionDataGraficaApi);
    locator.registerSingleton<NotasApi>(notasApi);
    locator.registerSingleton<SegmentosComponentesVehiculosApi>(
        segmentosComponentesVehiculosApi);
    locator.registerSingleton<SegmentosAccesoriosVehiculosApi>(
        segmentosAccesoriosVehiculosApi);
    locator.registerSingleton<ComponentesVehiculoSuplidorApi>(
        componenteVehiculoSuplidorApi);
    locator.registerSingleton<AuthenticationClient>(authenticationClient);
    locator.registerSingleton<AccesoriosApi>(accesoriosApi);
    locator.registerSingleton<UserClient>(userClient);
    locator.registerSingleton<ComponentesVehiculoApi>(componentesVehiculoApi);
    locator.registerSingleton<CondicionesComponentesVehiculoApi>(
        condicionesComponentesVehiculoApi);
    locator.registerSingleton<PersonalApi>(personalApi);
    locator.registerSingleton<AccionesApi>(accionesApi);
    locator.registerSingleton<EndpointsApi>(endpointsAPI);
    locator.registerSingleton<ParametrosServidorEmailApi>(
        parametrosServidorEmailApi);
    locator.registerSingleton<ModulosApi>(modulosAPI);
    locator.registerSingleton<SuplidoresApi>(suplidoresAPI);
    locator.registerSingleton<SuplidoresDefaultApi>(suplidoresDefaultAPI);
    locator.registerSingleton<SolicitudesApi>(solicitudesAPI);
    locator.registerSingleton<PeriodoTasacionPromedioApi>(
        periodoTasacionPromedioApi);
    locator.registerSingleton<AccesoriosSuplidorApi>(accesoriosSuplidorApi);
    locator.registerSingleton<FotosApi>(fotosApi);
    locator.registerSingleton<AccionesSolicitudApi>(accionesSolicitudApi);
  }
}
