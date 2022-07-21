import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/endpoints_api.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../widgets/forms/form_asignar_permiso.dart';
import '../widgets/forms/form_crear_endpoint.dart';
import '../widgets/forms/form_crear_permiso.dart';

class EndpointsViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _endpointsApi = locator<EndpointsApi>();
  final _permisosApi = locator<PermisosAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  List<EndpointsData> endpoints = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool hasNextPage = false;

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

  Future<void> onInit() async {
    cargando = true;
    endpoints = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp =
        await _endpointsApi.getEndpoints(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as EndpointsResponse;
      endpoints = temp.data;
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasEndpoints() async {
    pageNumber += 1;
    var resp =
        await _endpointsApi.getEndpoints(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as EndpointsResponse;
      endpoints.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> modificarEndpoint(
      EndpointsData endpointsData, BuildContext context, Size size) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    bool validator = false;
    String buttonTittle = "Modificar";
    String controlador = "";
    String nombre = "";
    String httpVerbo = "";
    String metodo = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: CrearEndpointForm(
                asignarPermiso: () async {
                  final GlobalKey<FormState> _formKey = GlobalKey();
                  bool validator = true;
                  String buttonTittle = "Asignar";
                  Map<String, dynamic> permiso = {};
                  var opcion;
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
                            content: formAsignarPermiso(
                              "Asignar Permiso",
                              _formKey,
                              permiso,
                              () async {
                                ProgressDialog.show(context);
                                var resp =
                                    await _endpointsApi.assignPermisoEndpoint(
                                        endpointId: endpointsData.id,
                                        permisoId: permiso["id"]);
                                if (resp is Success<EndpointsPOSTResponse>) {
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
                          );
                        });
                  } else if (resp is Failure) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.error(msg: resp.messages.first);
                  }
                },
                eliminar: () {
                  Dialogs.confirm(context,
                      tittle: "Eliminar Endpoint",
                      description:
                          "Esta seguro que desea eliminar el endpoint?",
                      confirm: () async {
                    ProgressDialog.show(context);
                    var resp = await _endpointsApi.deleteEndpoint(
                        id: endpointsData.id);
                    if (resp is Success<EndpointsPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Eliminado con exito");
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
                modificar: (nombref, controladorf, metodof, httpVerbof) async {
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
                controlador: controlador,
                buttonTittle: buttonTittle,
                nombre: nombre,
                httpVerbo: httpVerbo,
                metodo: metodo,
                endpointsData: endpointsData),
          );
        });
  }

  Future<void> crearEndpoint(BuildContext context, Size size) async {
    final _endpointsApi = locator<EndpointsApi>();
    String controlador = "";
    String nombre = "";
    String metodo = "";
    String httpVerbo = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Endpoint";
    bool validator = true;
    String buttonTittle = "Crear";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: CrearEndpointForm(
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
              controlador: controlador,
              httpVerbo: httpVerbo,
              metodo: metodo,
              buttonTittle: buttonTittle,
              nombre: nombre,
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
