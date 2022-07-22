import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../core/api/roles_api.dart';
import '../../../core/api/usuarios_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/locator.dart';
import '../../../core/models/roles_response.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';
import '../widgets/forms/form_crear_usuario.dart';
import '../widgets/forms/form_update_roles_usuarios.dart';
import '../widgets/forms/form_update_usuario.dart';

class UsuariosViewModel extends BaseViewModel {
  final user = locator<AuthenticationClient>().loadSession;
  final _usuariosApi = locator<UsuariosAPI>();
  final _rolesApi = locator<RolesAPI>();
  final listController = ScrollController();
  final _navigationService = locator<NavigatorService>();

  TextEditingController tcBuscar = TextEditingController();

  List<UsuariosData> usuarios = [];
  int pageNumber = 1;
  bool _cargando = false;
  bool _busqueda = false;
  bool hasNextPage = false;
  late UsuariosResponse usuariosResponse;

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

  bool get busqueda => _busqueda;
  set busqueda(bool value) {
    _busqueda = value;
    notifyListeners();
  }

  Future<void> onInit() async {
    cargando = true;
    usuarios = [];
    pageNumber = 1;
    hasNextPage = false;
    var resp =
        await _usuariosApi.getUsuarios(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      usuariosResponse = resp.response as UsuariosResponse;
      usuarios = usuariosResponse.data;
      hasNextPage = usuariosResponse.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      Dialogs.error(msg: resp.messages[0]);
    }
    cargando = false;
  }

  Future<void> cargarMasUsuarios() async {
    pageNumber += 1;
    var resp =
        await _usuariosApi.getUsuarios(pageNumber: pageNumber, pageSize: 20);
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      usuarios.addAll(temp.data);
      hasNextPage = temp.hasNextPage;
      notifyListeners();
    }
    if (resp is Failure) {
      pageNumber -= 1;
      Dialogs.error(msg: resp.messages[0]);
    }
  }

  Future<void> buscarUsuario(String query) async {
    cargando = true;
    var resp = await _usuariosApi.getUsuarios(
      nombreCompleto: query,
      pageSize: 0,
    );
    if (resp is Success) {
      var temp = resp.response as UsuariosResponse;
      usuarios = temp.data;
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
    usuarios = usuariosResponse.data;
    if (usuarios.length >= 20) {
      hasNextPage = true;
    }
    notifyListeners();
    tcBuscar.clear();
  }

  Future<void> modificarUsuario(
      UsuariosData usuario, BuildContext context, Size size) async {
    String email = "", telefono = "", nombre = "";
    GlobalKey<FormState> _key = GlobalKey();
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
                },
                () async {
                  GlobalKey<FormState> _key = GlobalKey();
                  var dropdown;
                  Map<String, dynamic> rol1 = {};
                  Map<String, dynamic> rol2 = {};
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
                                side: const BorderSide(
                                    color: AppColors.gold, width: 3)),
                            contentPadding: EdgeInsets.zero,
                            content: dialogActualizarRolesUsuario(
                                size, context, _key, resp.response.data, true,
                                () async {
                              if (rol1["id"] != "") {
                                ProgressDialog.show(context);
                                var creacion =
                                    await _usuariosApi.updateRolUsuario(
                                        id: usuario.id, rol: rol1);
                                if (creacion is Success<UsuarioPOSTResponse>) {
                                  ProgressDialog.dissmiss(context);
                                  Dialogs.success(msg: "Rol asignado");
                                  _key.currentState?.reset();
                                } else if (creacion is Failure) {
                                  ProgressDialog.dissmiss(context);
                                  Dialogs.error(msg: creacion.messages.first);
                                }
                              }
                              if (rol2["id"] != "") {
                                ProgressDialog.show(context);
                                var creacion =
                                    await _usuariosApi.updateRolUsuario(
                                        id: usuario.id, rol: rol2);
                                if (creacion is Success<UsuarioPOSTResponse>) {
                                  ProgressDialog.dissmiss(context);
                                  Dialogs.success(msg: "Rol asignado");
                                  _key.currentState?.reset();
                                } else if (creacion is Failure) {
                                  ProgressDialog.dissmiss(context);
                                  Dialogs.error(msg: creacion.messages.first);
                                }
                              }
                            }, dropdown, rol1, rol2),
                          );
                        });
                  } else if (resp is Failure) {
                    ProgressDialog.dissmiss(context);
                    Dialogs.error(msg: resp.messages.first);
                  }
                }),
          );
        });
  }

  Future<void> crearUsuario(BuildContext context, Size size) async {
    final _usuariosApi = locator<UsuariosAPI>();
    final _rolesApi = locator<RolesAPI>();
    final user = locator<AuthenticationClient>().loadSession;
    String nombre = "";
    String telefono = "";
    String email = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Usuario";
    bool validator = true;
    String buttonTittle = "Crear";
    Map<String, dynamic> rol1 = {};
    Map<String, dynamic> suplidor = {};
    List<RolData> roles = [];
    var rolElegido;
    ProgressDialog.show(context);
    var resp = await _rolesApi.getRoles();
    if (resp is Success<RolResponse>) {
      ProgressDialog.dissmiss(context);
      for (var element in user.role) {
        if (element == "Administrador") {
          roles = resp.response.data;
          break;
        } else if (element == "AprobadorTasaciones") {
          roles = resp.response.data;
          roles.removeWhere((element) =>
              (element.description != "AprobadorTasaciones" ||
                  element.description != "Tasador"));
        } else {
          roles = [];
        }
      }

      dialogCrearUsuario(
          titulo,
          size,
          context,
          _formKey,
          resp.response.data,
          nombre,
          telefono,
          email,
          validator, (nombref, emailf, telefonof, codigoSuplidorf) async {
        if (codigoSuplidorf == 0) {
          ProgressDialog.show(context);
          var creacion = await _usuariosApi.createUsuarios(
              email: emailf,
              phoneNumber: telefonof,
              fullName: nombref,
              roleId: rol1['id'],
              codigoSuplidor: suplidor["codigoRelacional"]);
          if (creacion is Success<UsuarioPOSTResponse>) {
            ProgressDialog.dissmiss(context);
            Dialogs.success(msg: "Creacion de usuario exitosa");
          } else if (creacion is Failure) {
            ProgressDialog.dissmiss(context);
            Dialogs.error(msg: creacion.messages[0]);
          }
        } else {
          var creacion = await _usuariosApi.createUsuarios(
              email: emailf,
              phoneNumber: telefonof,
              fullName: nombref,
              roleId: rol1['id'],
              codigoSuplidor: codigoSuplidorf);
          if (creacion is Success<UsuarioPOSTResponse>) {
            ProgressDialog.dissmiss(context);
            Dialogs.success(msg: "Creacion de usuario exitosa");
          } else if (creacion is Failure) {
            ProgressDialog.dissmiss(context);
            Dialogs.error(msg: creacion.messages[0]);
          }
        }
      }, rolElegido, buttonTittle, rol1, suplidor);
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
