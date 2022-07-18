import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_actualizar_rol.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_crear_usuario.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_update_usuario.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/api_status.dart';
import '../../../core/api/endpoints_api.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/api/roles_api.dart';
import '../../../core/api/usuarios_api.dart';
import '../../../core/authentication_client.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/permisos_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../core/models/roles_response.dart';
import '../../../core/models/usuarios_response.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_dialogs.dart';
import 'forms/form_crear_endpoint.dart';
import 'forms/form_crear_permiso.dart';

class ChangeButtons {
  late BuildContext context;
  final Size size;
  ChangeButtons({required this.context, required this.size});

  Future<Widget> addButtonUsuario() async {
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
    List<RolData> roles = [];
    var rolElegido;
    var resp = await _rolesApi.getRoles();
    if (resp is Success<RolResponse>) {
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

      return CircleIconButton(
          color: AppColors.green,
          icon: Icons.add,
          onPressed: () => dialogCrearUsuario(
                  titulo,
                  size,
                  context,
                  _formKey,
                  resp.response.data,
                  nombre,
                  telefono,
                  email,
                  validator, (nombref, emailf, telefonof) async {
                ProgressDialog.show(context);
                var creacion = await _usuariosApi.createUsuarios(
                  email: emailf,
                  phoneNumber: telefonof,
                  fullName: nombref,
                  roleId: rol1['id'],
                );
                if (creacion is Success<UsuarioPOSTResponse>) {
                  ProgressDialog.dissmiss(context);
                  Dialogs.alert(context,
                      tittle: "Creacion de usuario exitosa",
                      description: ["Exito al crear usuario"]);
                } else if (creacion is Failure) {
                  ProgressDialog.dissmiss(context);
                  Dialogs.alert(context,
                      tittle: "Error al crear usuario",
                      description: creacion.messages);
                }
              }, rolElegido, buttonTittle, rol1));
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.alert(context,
          tittle: resp.messages[0], description: resp.messages);
    }
    return Container();
  }

  Future<Widget> addButtonEndpoints() async {
    final _endpointsApi = locator<EndpointsApi>();
    String controlador = "";
    String nombre = "";
    String metodo = "";
    String httpVerbo = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Endpoint";
    bool validator = true;
    String buttonTittle = "Crear";

    return CircleIconButton(
        color: AppColors.green,
        icon: Icons.add,
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: CrearEndpointForm(
                    formKey: _formKey,
                    size: size,
                    titulo: titulo,
                    informacion: const [],
                    validator: validator,
                    modificar:
                        (nombref, controladorf, metodof, httpVerbof) async {
                      ProgressDialog.show(context);
                      var resp = await _endpointsApi.createEndpoint(
                          controlador: controladorf,
                          nombre: nombref,
                          metodo: metodof,
                          httpVerbo: httpVerbof);
                      if (resp is Success<EndpointsData>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.alert(context,
                            tittle: "Creacion de endpoint exitosa",
                            description: [
                              "Se ha creado el  endpoint con exito"
                            ]);
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.alert(context,
                            tittle: "Creacion fallida",
                            description: resp.messages);
                      }
                    },
                    controlador: controlador,
                    httpVerbo: httpVerbo,
                    metodo: metodo,
                    buttonTittle: buttonTittle,
                    nombre: nombre),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              );
            }));
  }

  Future<Widget> addButtonRol() async {
    final _rolesApi = locator<RolesAPI>();
    String descripcion = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear rol";
    bool validator = true;
    String buttonTittle = "Crear";
    String nombre = "";
    return CircleIconButton(
        color: AppColors.green,
        icon: Icons.add,
        onPressed: () => showDialog(
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
                      var resp =
                          await _rolesApi.createRoles(nombref, descripcionf);
                      if (resp is Success<RolPOSTResponse>) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.alert(context,
                            tittle: "Creacion de rol exitosa",
                            description: ["Se ha creado el rol con exito"]);
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.alert(context,
                            tittle: "Creacion fallida",
                            description: resp.messages);
                      }
                    },
                    descripcion: descripcion,
                    buttonTittle: buttonTittle,
                    nombre: nombre),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              );
            }));
  }

  Future<Widget> addButtonPermisos() async {
    final _accionesApi = locator<AccionesApi>();
    final _recursosApi = locator<RecursosAPI>();
    final _permisosApi = locator<PermisosAPI>();
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
        return CircleIconButton(
            color: AppColors.green,
            icon: Icons.add,
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: formCrearPermiso(
                          "Nuevo Permiso",
                          _formKey,
                          descripcion,
                          recurso,
                          accion, (String descripcionf) async {
                        ProgressDialog.show(context);
                        var creacion = await _permisosApi.createPermisos(
                            descripcion: descripcionf,
                            idAccion: accion["id"],
                            idRecurso: recurso["id"],
                            esBasico: 1);
                        if (creacion is Success<PermisosData>) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.alert(context,
                              tittle: "Creacion exitosa",
                              description: ["Permiso creado con exito"]);
                          _formKey.currentState?.reset();
                        } else if (creacion is Failure) {
                          ProgressDialog.dissmiss(context);
                          Dialogs.alert(context,
                              tittle: creacion.supportMessage,
                              description: creacion.messages);
                        }
                      }, opcion, resp.response.data, resp2.response.data, [],
                          size, false, "Crear"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ));
                }));
      } else if (resp2 is Failure) {
        ProgressDialog.dissmiss(context);
        Dialogs.alert(
          context,
          tittle: 'Error',
          description: resp2.messages,
        );
      }
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.alert(
        context,
        tittle: 'Error',
        description: resp.messages,
      );
    }
    return Container();
  }
}
