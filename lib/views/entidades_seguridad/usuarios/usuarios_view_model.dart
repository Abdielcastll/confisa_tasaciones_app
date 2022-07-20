import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/api/usuarios_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/models/roles_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../widgets/forms/form_crear_permiso.dart';
import '../widgets/forms/form_update_usuario.dart';
import '../widgets/mostrar_informacion_widget.dart';

class UsuariosViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _usuariosApi = locator<UsuariosAPI>();
  final _accionesApi = locator<AccionesApi>();
  final _recursosApi = locator<RecursosAPI>();
  final _rolesApi = locator<RolesAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  List<UsuariosData> Usuarios = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool hasNextPage = false;

  UsuariosViewModel() {
    listController.addListener(() {
      if (listController.position.maxScrollExtent == listController.offset) {
        if (hasNextPage) {
          cargarMasUsuarios();
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
    Usuarios = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp =
        await _usuariosApi.getUsuarios(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      Usuarios = temp.data;
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasUsuarios() async {
    pageNumber += 1;
    var resp = await _usuariosApi.getUsuarios(pageNumber: pageNumber);
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      Usuarios.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> modificarUsuario(
      UsuariosData usuario, BuildContext context, Size size) async {
    String email = "", telefono = "", nombre = "";
    GlobalKey<FormState> _key = GlobalKey();
    ProgressDialog.show(context);
    var resp = await _rolesApi.getRoles();
    if (resp is Success<RolResponse>) {
      ProgressDialog.dissmiss(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.gold, width: 3)),
              contentPadding: EdgeInsets.zero,
              content: dialogActualizarInformacion(
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey,
                    ),
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
                  [
                    /* Text(usuario.nombreCompleto,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(usuario.email,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold)), */
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                        "Suplidor " +
                            (usuario.nombreSuplidor.isEmpty
                                ? "Ninguno"
                                : usuario.nombreSuplidor),
                        style: appDropdown),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Roles ${usuario.nombreSuplidor}", style: appDropdown),
                    Column(
                      children: usuario.roles
                          .map((e) => Text(e.description, style: appDropdown))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    /* Text(
                      "Telefono ${usuario.phoneNumber}",
                      style: appDropdown,
                    ),
                    const SizedBox(
                      height: 8,
                    ), */
                    usuario.isActive
                        ? Text("Estado Activo", style: appDropdown)
                        : Text("Estado Inactivo", style: appDropdown)
                  ],
                  size,
                  context,
                  _key,
                  resp.response.data,
                  nombre,
                  telefono,
                  email,
                  true,
                  (nombref, emailf, telefonof) async {
                    if (nombref != "" || emailf != "" || telefonof != "") {
                      ProgressDialog.show(context);
                      var creacion = await _usuariosApi.updateUsuarios(
                          id: usuario.id,
                          email: emailf,
                          phoneNumber: telefonof,
                          fullName: nombref);
                      if (creacion is Success<UsuarioPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.success(msg: "Modificacion de datos exitosa");
                        _key.currentState?.reset();
                        _navigationService.pop();
                        onInit();
                      } else if (creacion is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: creacion.messages.first);
                      }
                    }
                  },
                  "Modificar",
                  usuario,
                  () async {
                    ProgressDialog.show(context);
                    var creacion = await _usuariosApi.updateStatusUsuario(
                        id: usuario.id, status: !usuario.isActive);
                    if (creacion is Success<UsuarioPOSTResponse>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Estado actualizado");
                      onInit();
                      _navigationService.pop();
                    } else if (creacion is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: creacion.messages.first);
                    }
                  }),
            );
          });
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
    }
  }

  Future<void> crearPermiso(BuildContext context, Size size) async {
    String descripcion = "";
    Map<String, dynamic> accion = {};
    Map<String, dynamic> recurso = {};
    dynamic opcion;
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
                      "Creacion de Permiso",
                      _formKey,
                      descripcion,
                      recurso,
                      accion, (String descripcionf) async {
                    ProgressDialog.show(context);
                    /* var creacion = await _usuariosApi.createUsuarios(
                        descripcion: descripcionf,
                        idAccion: accion["id"],
                        idRecurso: recurso["id"],
                        esBasico: 1);
                    if (creacion is Success<UsuariosData>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Creacion exitosa");
                      _formKey.currentState?.reset();
                      _navigationService.pop();
                      onInit();
                    } else if (creacion is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: creacion.messages.first);
                    } */
                  }, () {}, opcion, resp.response.data, resp2.response.data, [],
                      size, false, "Crear", false),
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
    }
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }
}
