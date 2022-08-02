import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/endpoints_api.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';
import '../widgets/forms/form_asignar_permiso.dart';
import '../widgets/forms/form_crear_endpoint.dart';

class EndpointsViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _endpointsApi = locator<EndpointsApi>();
  final _permisosApi = locator<PermisosAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  TextEditingController tcBuscar = TextEditingController();

  List<EndpointsData> endpoints = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late EndpointsResponse endpointsResponse;

  EndpointsViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasEndpoints();
        }
      }
    });
  }

  bool get cargando => _cargando;
  set cargando(bool value) {
    _cargando = value;
    notifyListeners();
  }

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  void ordenar() {
    endpoints.sort((a, b) {
      return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
    });
  }

  Future<void> onInit() async {
    cargando = true;
    endpoints = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _endpointsApi.getEndpoints(pageNumber: pageNumber);
    if (resp is Success) {
      endpointsResponse = resp.response as EndpointsResponse;
      endpoints = endpointsResponse.data;
      ordenar();
      hasNextPage = endpointsResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> onRefresh() async {
    endpoints = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _endpointsApi.getEndpoints(pageNumber: pageNumber);
    if (resp is Success) {
      endpointsResponse = resp.response as EndpointsResponse;
      endpoints = endpointsResponse.data;
      ordenar();
      hasNextPage = endpointsResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> cargarMasEndpoints() async {
    pageNumber += 1;
    var resp = await _endpointsApi.getEndpoints(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as EndpointsResponse;
      endpoints.addAll(temp.data);
      ordenar();
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      pageNumber -= 1;
    }
  }

  Future<void> buscarEndpoint(String query) async {
    cargando = true;
    var resp = await _endpointsApi.getEndpoints(
      controlador: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as EndpointsResponse;
      endpoints = temp.data;
      ordenar();
      hasNextPage = temp.hasNextPage;
      _busqueda = true;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  void limpiarBusqueda() {
    _busqueda = false;
    endpoints = endpointsResponse.data;
    if (endpoints.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> modificarEndpoint(
      EndpointsData endpointsData, BuildContext context, Size size) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    bool validator = false;
    String buttonTittle = "Modificar";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: CrearEndpointForm(
                  asignarPermiso: () async {
                    final GlobalKey<FormState> _formKey = GlobalKey();
                    bool validator = true;
                    Map<String, dynamic> permiso = {};
                    dynamic opcion;
                    ProgressDialog.show(context);
                    var resp = await _permisosApi.getPermisos(pageSize: 999);
                    if (resp is Success<PermisosResponse>) {
                      ProgressDialog.dissmiss(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.zero,
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * .75,
                                child: formAsignarPermiso(
                                  "Asignar Permiso",
                                  _formKey,
                                  permiso,
                                  () async {
                                    ProgressDialog.show(context);
                                    var resp = await _endpointsApi
                                        .assignPermisoEndpoint(
                                            endpointId: endpointsData.id,
                                            permisoId: permiso["id"]);
                                    if (resp
                                        is Success<EndpointsPOSTResponse>) {
                                      ProgressDialog.dissmiss(context);
                                      Dialogs.success(
                                          msg: "Asignacion de Permiso exitosa");
                                      _formKey.currentState?.reset();
                                      _navigationService.pop();
                                      _navigationService.pop();
                                      onInit();
                                    } else if (resp is Failure) {
                                      ProgressDialog.dissmiss(context);
                                      Dialogs.error(msg: resp.messages[0]);
                                    }
                                  },
                                  opcion,
                                  resp.response.data,
                                  size,
                                  validator,
                                  "Asignar",
                                ),
                              ),
                            );
                          });
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages.first);
                    }
                  },
                  eliminar: () {
                    Dialogs.confirm(context,
                        tittle: "Desactivar Endpoint",
                        description:
                            "Esta seguro que desea desactivar el endpoint?",
                        confirm: () async {
                      ProgressDialog.show(context);
                      var resp = await _endpointsApi.deleteEndpoint(
                          id: endpointsData.id);
                      if (resp is Success<EndpointsPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Desactivado con exito");
                        _formKey.currentState?.reset();
                        _navigationService.pop();
                        onInit();
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
                      }
                    });
                  },
                  showEliminar: true,
                  formKey: _formKey,
                  size: size,
                  titulo: "Modificar Endpoint",
                  validator: validator,
                  modificar:
                      (nombref, controladorf, metodof, httpVerbof) async {
                    ProgressDialog.show(context);
                    var resp = await _endpointsApi.updateEndpoint(
                        id: endpointsData.id,
                        controlador: controladorf,
                        nombre: nombref,
                        metodo: metodof,
                        httpVerbo: httpVerbof);
                    if (resp is Success<EndpointsPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Modificacion de endpoint exitosa");
                      _formKey.currentState?.reset();
                      _navigationService.pop();
                      onInit();
                    } else if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages[0]);
                    }
                  },
                  buttonTittle: buttonTittle,
                  endpointsData: endpointsData),
            ),
          );
        });
  }

  Future<void> crearEndpoint(BuildContext context, Size size) async {
    final _endpointsApi = locator<EndpointsApi>();
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Endpoint";
    bool validator = true;
    String buttonTittle = "Crear";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: CrearEndpointForm(
                asignarPermiso: () {},
                formKey: _formKey,
                size: size,
                titulo: titulo,
                validator: validator,
                modificar: (nombref, controladorf, metodof, httpVerbof) async {
                  ProgressDialog.show(context);
                  var resp = await _endpointsApi.createEndpoint(
                      controlador: controladorf,
                      nombre: nombref,
                      metodo: metodof,
                      httpVerbo: httpVerbof);
                  if (resp is Success<EndpointsData>) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.success(msg: "Creacion de endpoint exitosa");
                    _formKey.currentState?.reset();
                    _navigationService.pop();
                    onInit();
                  } else if (resp is Failure) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.error(msg: resp.messages.first);
                  }
                },
                buttonTittle: buttonTittle,
                endpointsData: EndpointsData(
                    controlador: "",
                    estado: false,
                    httpVerbo: "",
                    id: 0,
                    metodo: "",
                    nombre: "",
                    permiso: PermisosData(
                        accionNombre: "",
                        descripcion: "",
                        esBasico: 0,
                        id: 0,
                        idAccion: 0,
                        idRecurso: 0,
                        recursoNombre: "")),
                eliminar: () {},
                showEliminar: false,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
