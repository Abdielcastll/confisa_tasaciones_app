import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tasaciones_app/core/api/alarmas.dart';
import 'package:tasaciones_app/core/api/personal_api.dart';
import 'package:tasaciones_app/core/api/solicitudes_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/alarma_response.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';
import 'package:tasaciones_app/core/models/profile_response.dart';
import 'package:tasaciones_app/core/models/roles_claims_response.dart';
import 'package:tasaciones_app/core/models/sign_in_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitud_tipo_estado_response.dart';
import 'package:tasaciones_app/core/models/solicitudes/solicitudes_get_response.dart';
import 'package:tasaciones_app/core/providers/alarmas_provider.dart';
import 'package:tasaciones_app/core/providers/componentes_vehiculo_provider.dart';
import 'package:tasaciones_app/core/providers/profile_permisos_provider.dart';
import 'package:tasaciones_app/core/user_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/auth/login/login_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/dialog_mostrar_informacion_permisos.dart';
import 'package:tasaciones_app/views/solicitudes/consultar_modificar_solicitud/consultar_modificar_view.dart';

import '../../../core/api/api_status.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/providers/accesorios_provider.dart';
import '../../../core/services/navigator_service.dart';
import '../../../widgets/app_dialogs.dart';
import '../trabajar_solicitud/trabajar_view.dart';

class ColaSolicitudesViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigatorService>();
  final _solicitudesApi = locator<SolicitudesApi>();
  final _alarmasApi = locator<AlarmasApi>();
  final _authenticationAPI = locator<AuthenticationClient>();
  final _usuarioApi = locator<UserClient>();

  final listController = ScrollController();
  late GetSolicitudesResponse solicitudesResponse;

  AlarmasResponse? alarmasResponse;
  List<TipoTasacionData> tiposTasacion = [];
  List<EstadoSolicitudData> estadosSolicitud = [];
  List<SolicitudesData> solicitudes = [];
  List<AlarmasData> alarmas = [];
  TextEditingController tcBuscar = TextEditingController();
  List<String> roles = [];
  List<String> opcionesFiltro = [
    "No. Tasación",
    "No. Solicitud Crédito",
    "Chasis",
    "Identificación Cliente",
    "Nombre Cliente",
  ];
  List<int> seleccionEstado = [];
  List<int> seleccionTipo = [];
  List<String> seleccionFiltro = [];
  Map<EstadoSolicitudData, bool> boolMapEstado = {};
  Map<TipoTasacionData, bool> boolMapTipos = {};

  bool _loading = true;
  int pageNumber = 1;
  int _currentForm = 0;
  bool hasNextPage = false;
  bool _busqueda = false;

  final _authenticationClient = locator<AuthenticationClient>();
  final _userClient = locator<UserClient>();
  final _personalApi = locator<PersonalApi>();
  late Session _user;
  late Profile _userData;
  final logger = Logger();
  final List<RolClaimsData> _permisos;
  final MenuResponse _menu;

  ColaSolicitudesViewModel(this._permisos, this._menu) {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMas();
        }
      }
    });
  }

  List<RolClaimsData> get permisos => _permisos;
  MenuResponse get menu => _menu;

  Session get user => _user;
  Profile get userData => _userData;
  set user(Session value) {
    _user = value;
    notifyListeners();
  }

  set userData(Profile value) {
    _userData = value;
    notifyListeners();
  }

  int get currentForm => _currentForm;
  set currentForm(int value) {
    _currentForm = value;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void filtro(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    busqueda = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width * .75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold, width: 3)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            DataTable(
                                onSelectAll: (isSelectedAll) {
                                  setState(() => {
                                        isSelectedAll!
                                            ? seleccionFiltro
                                                .addAll(opcionesFiltro)
                                            : seleccionFiltro = [],
                                      });
                                },
                                columns: const [
                                  DataColumn(
                                    label: Text("Todos"),
                                  ),
                                ],
                                rows: opcionesFiltro
                                    .map((e) => DataRow(
                                            selected: seleccionFiltro
                                                .any((element) => element == e),
                                            onSelectChanged: (isSelected) {
                                              isSelected!
                                                  ? seleccionFiltro.add(e)
                                                  : seleccionFiltro.removeWhere(
                                                      (element) =>
                                                          element == e);

                                              setState((() {}));
                                            },
                                            cells: [
                                              DataCell(
                                                Text(
                                                  e,
                                                ),
                                              ),
                                            ]))
                                    .toList()),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text("Tipos de Tasacion"),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                            ...boolMapTipos.keys
                                .map(
                                  (e) => CheckboxListTile(
                                    visualDensity: VisualDensity.compact,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding:
                                        const EdgeInsets.only(left: 13),
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300)),
                                    value: boolMapTipos[e],
                                    onChanged: (isSelected) {
                                      boolMapTipos[e] = isSelected!;
                                      isSelected
                                          ? seleccionTipo.add(e.id)
                                          : seleccionTipo.removeWhere(
                                              (element) => element == e.id);

                                      setState((() {}));
                                    },
                                    title: Text(
                                      e.descripcion,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 15, top: 20),
                              child: Text("Estados de Tasacion"),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                            ...boolMapEstado.keys
                                .map(
                                  (e) => CheckboxListTile(
                                    visualDensity: VisualDensity.compact,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding:
                                        const EdgeInsets.only(left: 13),
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300)),
                                    value: boolMapEstado[e],
                                    onChanged: (isSelected) {
                                      boolMapEstado[e] = isSelected!;
                                      isSelected
                                          ? seleccionEstado.add(e.id)
                                          : seleccionEstado.removeWhere(
                                              (element) => element == e.id);

                                      setState((() {}));
                                    },
                                    title: Text(
                                      e.descripcion,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      )),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              _navigatorService.pop();
                            },
                            // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(
                                  AppIcons.closeCircle,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  height: 3,
                                ), // icon
                                Text("Cancelar"), // text
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  Future<void> getAlarma(BuildContext context) async {
    Object respalarm;
    Profile perfil = _usuarioApi.loadProfile;
    Session data = _authenticationAPI.loadSession;
    if (Provider.of<AlarmasProvider>(context, listen: false).alarmas !=
        alarmas) {
      data.role.any((element) =>
              element == "AprobadorTasaciones" || element == "Administrador")
          ? respalarm = await _alarmasApi.getAlarmas()
          : respalarm = await _alarmasApi.getAlarmas(usuario: perfil.id!);
      if (respalarm is Success) {
        alarmasResponse = respalarm.response as AlarmasResponse;
        alarmas = alarmasResponse!.data;
        Provider.of<AlarmasProvider>(context, listen: false).alarmas = alarmas;
      }
      if (respalarm is Failure) {
        Dialogs.error(msg: respalarm.messages[0]);
      }
      if (respalarm is TokenFail) {
        _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
        Dialogs.error(msg: 'Sesión expirada');
      }
      notifyListeners();
    }
  }

  Future<void> onInit(BuildContext context) async {
    // pageNumber = 1;
    seleccionFiltro = [];
    Session data = _authenticationAPI.loadSession;
    Profile perfil = _usuarioApi.loadProfile;
    roles = data.role;
    loading = true;
    user = _authenticationClient.loadSession;
    userData = _userClient.loadProfile;
    var resp = await _solicitudesApi.getTiposTasacion();
    if (resp is Success<TipoTasacionResponse>) {
      tiposTasacion = resp.response.data;
      for (var element in tiposTasacion) {
        boolMapTipos.addAll({element: false});
      }
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
    }
    var resp2 = await _solicitudesApi.getEstadosSolicitud();
    if (resp2 is Success<EstadoSolicitudResponse>) {
      estadosSolicitud = resp2.response.data;
      for (var element in estadosSolicitud) {
        boolMapEstado.addAll({element: false});
      }
    } else if (resp2 is Failure) {
      Dialogs.error(msg: resp2.messages.first);
    }
    var resp1 = await _personalApi.getPermisos();
    if (resp1 is Success<ProfilePermisoResponse>) {
      Provider.of<ProfilePermisosProvider>(context, listen: false)
          .profilePermisos = resp1.response;
    } else if (resp1 is Failure) {
      Dialogs.error(msg: resp1.messages.first);
      // loading = false;
      // _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    } else if (resp1 is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
    getAlarma(context);
    await onRefresh();
    loading = false;
    final componentesProv = ComponentesVehiculosProvider.instance;
    final accesoriosProv = AccesoriosProvider.instance;
    await componentesProv.getComponentes();
    await componentesProv.getComponentesSeg();
    await accesoriosProv.getAccesorios();
  }

  Future<void> onRefresh() async {
    pageNumber = 1;
    var resp = await _solicitudesApi.getColaSolicitudes(pageNumber: pageNumber);
    if (resp is Success<GetSolicitudesResponse>) {
      solicitudesResponse = resp.response;
      solicitudes = solicitudesResponse.data;
      hasNextPage = resp.response.hasNextPage ?? false;
      if (roles.contains("Tasador") || roles.contains("AprobadorTasaciones")) {
        solicitudes.removeWhere((e) => e.estadoTasacion == 34);
      }
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
      Dialogs.error(msg: 'Sesión expirada');
    }
  }

  Future<void> cargarMas() async {
    pageNumber += 1;
    var resp = await _solicitudesApi.getColaSolicitudes(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as GetSolicitudesResponse;
      hasNextPage = temp.hasNextPage ?? false;
      solicitudesResponse.data = [...solicitudesResponse.data, ...temp.data];
      solicitudes = [...solicitudes, ...temp.data];
      if (roles.contains("Tasador") || roles.contains("AprobadorTasaciones")) {
        solicitudes.removeWhere((e) => e.estadoTasacion == 34);
      }
      // ordenar();
      // print('HAY MAS:  ${temp.hasNextPage}');
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
  }

  void ordenar() {
    solicitudes.sort((a, b) {
      return a.noSolicitudCredito
          .toString()
          .toLowerCase()
          .compareTo(b.noSolicitudCredito.toString().toLowerCase());
    });
  }

  Future<void> buscar(String query) async {
    loading = true;
    if (query.isEmpty && seleccionEstado.isEmpty && seleccionTipo.isEmpty) {
      loading = false;
      return;
    }
    var resp;

    if (seleccionFiltro.isNotEmpty ||
        seleccionEstado.isNotEmpty ||
        seleccionTipo.isNotEmpty) {
      resp = await _solicitudesApi.getColaSolicitudes(
          pageSize: 999,
          noSolicitud: seleccionFiltro
                  .any((element) => element == "No. Solicitud Crédito")
              ? int.tryParse(query)
              : null,
          noTasacion:
              seleccionFiltro.any((element) => element == "No. Tasación")
                  ? int.tryParse(query)
                  : null,
          chasis: seleccionFiltro.any((element) => element == "Chasis")
              ? query
              : "",
          estado: seleccionEstado.isEmpty ? [] : seleccionEstado,
          identificacion: seleccionFiltro
                  .any((element) => element == "Identificación Cliente")
              ? query
              : "",
          nombreCliente:
              seleccionFiltro.any((element) => element == "Nombre Cliente")
                  ? query
                  : "",
          tipoTasacion: seleccionTipo.isEmpty ? [] : seleccionTipo);
    }

    if (seleccionFiltro.isEmpty &&
        seleccionEstado.isEmpty &&
        seleccionTipo.isEmpty) {
      resp = await _solicitudesApi.getColaSolicitudes(
        noSolicitud: query.isEmpty ? null : int.parse(query),
      );
    }
    if (resp is Success<GetSolicitudesResponse>) {
      solicitudes = resp.response.data;
      ordenar();
      hasNextPage = resp.response.hasNextPage ?? false;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    if (resp is TokenFail) {
      Dialogs.error(msg: 'su sesión a expirado');
      _navigatorService.navigateToPageAndRemoveUntil(LoginView.routeName);
    }
    loading = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    solicitudes = solicitudesResponse.data;
    if (solicitudes.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  goToSolicitud(SolicitudesData s, BuildContext context) {
    if (roles.contains("OficialNegocios")) {
      print('Consultar/Modificar No.${s.noTasacion}');
      _navigatorService
          .navigateToPage(
        ConsultarModificarView.routeName,
        arguments: s,
      )
          .then((v) {
        if (v != null) {
          onInit(context);
        }
      });
    }

    if (roles.contains("Tasador") || roles.contains("AprobadorTasaciones")) {
      if (s.estadoTasacion == 9) {
        print('Trabajar No.${s.noTasacion}');
        _navigatorService
            .navigateToPage(
          TrabajarView.routeName,
          arguments: s,
        )
            .then((v) {
          if (v != null) {
            onRefresh();
          }
        });
      } else {
        print('Consultar No.${s.noTasacion}');
        _navigatorService
            .navigateToPage(
          ConsultarModificarView.routeName,
          arguments: s,
        )
            .then((v) {
          if (v != null) {
            onInit(context);
          }
        });
      }
    }
  }
}
