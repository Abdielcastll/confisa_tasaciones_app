import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../widgets/forms/form_actualizar_rol.dart';
import '../widgets/forms/form_crear_permiso.dart';

class RolesViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _rolesApi = locator<RolesAPI>();
  final _accionesApi = locator<AccionesApi>();
  final _recursosApi = locator<RecursosAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  TextEditingController tcBuscar = TextEditingController();

  List<RolData> roles = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late RolResponse rolesResponse;

  RolesViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasRoles();
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

  Future<void> onInit() async {
    cargando = true;
    roles = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      rolesResponse = resp.response as RolResponse;
      roles = rolesResponse.data;
      hasNextPage = rolesResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasRoles() async {
    pageNumber += 1;
    var resp = await _rolesApi.getRoles(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as RolResponse;
      roles.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
      pageNumber -= 1;
    }
  }

  Future<void> buscarRol(String query) async {
    cargando = true;
    var resp = await _rolesApi.getRoles(
      descripcion: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as RolResponse;
      roles = temp.data;
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
    roles = rolesResponse.data;
    if (roles.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> modificarPermiso(String descripcion, int id, String accionNombre,
      String recursoNombre, BuildContext context) async {
    /* String permisoDescripcion = descripcion;
    Map<String, dynamic> accion = {};
    Map<String, dynamic> recurso = {};
    dynamic opcion;
    Size size = MediaQuery.of(context).size;
    ProgressDialog.show(context);
    var resp = await _accionesApi.getAcciones();
    if (resp is Success<AccionesResponse>) {
      var resp2 = await _recursosApi.getRecursos();
      if (resp2 is Success<RecursosResponse>) {
        ProgressDialog.dissmiss(context);
        final GlobalKey<FormState> _formKey = GlobalKey();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: formCrearPermiso(
                      "Modificacion de Permiso",
                      _formKey,
                      descripcion,
                      recurso,
                      accion, (String descripcionf) async {
                    ProgressDialog.show(context);
                    var creacion = await _rolesApi.updateRol(
                        id: id,
                        descripcion: descripcionf,
                        idAccion: accion["id"] ?? 0,
                        idRecurso: recurso["id"] ?? 0,
                        esBasico: 1);
                    if (creacion is Success<RolesPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Modificacion exitosa");
                      _navigationService.pop();
                      onInit();
                    } else if (creacion is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: creacion.messages.first);
                    }
                  }, () async {
                    Dialogs.confirm(context,
                        tittle: "Eliminar Permiso",
                        description:
                            "Esta seguro que desea eliminar el permiso?",
                        confirm: () async {
                      ProgressDialog.show(context);
                      var resp = await _rolesApi.deleteRoles(id: id);
                      if (resp is Success<RolesPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Eliminado con exito");
                        _navigationService.pop();
                        onInit();
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
                      }
                    });
                  },
                      opcion,
                      resp.response.data,
                      resp2.response.data,
                      [
                        Text("Permiso: $descripcion", style: appDropdown),
                        const SizedBox(
                          height: 3,
                        ),
                        Text("Accion: $accionNombre", style: appDropdown),
                        const SizedBox(
                          height: 3,
                        ),
                        Text("Recurso: $recursoNombre", style: appDropdown)
                      ],
                      size,
                      false,
                      "Modificar",
                      true),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ));
            });
      } else if (resp2 is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.error(msg: resp2.messages.first);
      }
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
    } */
  }

  Future<void> crearRol(BuildContext context, Size size) async {
    final _rolesApi = locator<RolesAPI>();
    String descripcion = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear rol";
    bool validator = true;
    String buttonTittle = "Crear";
    String nombre = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: ActualizarRolForm(
                formKey: _formKey,
                size: size,
                titulo: titulo,
                informacion: const [],
                validator: validator,
                modificar: (nombref, descripcionf) async {
                  ProgressDialog.show(context);
                  var resp = await _rolesApi.createRoles(nombref, descripcionf);
                  if (resp is Success<RolPOSTResponse>) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.success(msg: "Creacion de rol exitosa");
                    _navigationService.pop();
                    onInit();
                  } else if (resp is Failure) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.error(msg: resp.messages.first);
                  }
                },
                descripcion: descripcion,
                buttonTittle: buttonTittle,
                nombre: nombre),
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
