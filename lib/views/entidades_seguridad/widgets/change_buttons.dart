import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_actualizar_rol.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_crear_usuario.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_update_usuario.dart';
import 'package:tasaciones_app/core/models/modulos_response.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/form_crear_recurso.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/api_status.dart';
import '../../../core/api/endpoints_api.dart';
import '../../../core/api/modulos_api.dart';
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
import '../../../widgets/app_buttons.dart';
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
    String password = "";
    final GlobalKey<FormState> _formKey = GlobalKey();
    String titulo = "Crear Usuario";
    bool validator = true;
    String buttonTittle = "Crear";
    Map<String, dynamic> rol1 = {};
    Map<String, dynamic> suplidor = {};
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
          onPressed: () => dialogCrearUsuario(titulo, size, context, _formKey,
                  resp.response.data, nombre, telefono, email, validator,
                  (nombref, emailf, telefonof, codigoSuplidorf) async {
                ProgressDialog.show(context);
                if (codigoSuplidorf == 0) {
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
              }, rolElegido, buttonTittle, rol1, suplidor, password));
    } else if (resp is Failure) {
      ProgressDialog.dissmiss(context);
      Dialogs.error(msg: resp.messages.first);
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
                        Dialogs.success(msg: "Creacion de endpoint exitosa");
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
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
                        Dialogs.success(msg: "Creacion de rol exitosa");
                      } else if (resp is Failure) {
                        ProgressDialog.dissmiss(context);
                        Dialogs.error(msg: resp.messages.first);
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

  Future<void> addButtonPermisos() async {
    final _accionesApi = locator<AccionesApi>();
    final _recursosApi = locator<RecursosAPI>();
    final _permisosApi = locator<PermisosAPI>();
    String descripcion = "";
    Map<String, dynamic> accion = {};
    Map<String, dynamic> recurso = {};
    dynamic opcion;
    var resp = await _accionesApi.getAcciones();
    if (resp is Success<AccionesResponse>) {
      var resp2 = await _recursosApi.getRecursos();
      if (resp2 is Success<RecursosResponse>) {
        final GlobalKey<FormState> _formKey = GlobalKey();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: formCrearPermiso(
                      "Nuevo Permiso", _formKey, descripcion, recurso, accion,
                      (String descripcionf) async {
                    ProgressDialog.show(context);
                    var creacion = await _permisosApi.createPermisos(
                        descripcion: descripcionf,
                        idAccion: accion["id"],
                        idRecurso: recurso["id"],
                        esBasico: 1);
                    if (creacion is Success<PermisosData>) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: "Creacion exitosa");
                      _formKey.currentState?.reset();
                    } else if (creacion is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: creacion.messages.first);
                    }
                  }, () {}, opcion, resp.response.data, resp2.response.data, [],
                      size, false, "Crear", false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ));
            });
      } else if (resp2 is Failure) {
        Dialogs.error(msg: resp2.messages.first);
      }
    } else if (resp is Failure) {
      Dialogs.error(msg: resp.messages.first);
    }
  }

  // Boton Agregar Acciones
  Future<Widget> addButtonAcciones() async {
    final _accionesApi = locator<AccionesApi>();
    TextEditingController tcNewName = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return CircleIconButton(
        color: AppColors.green,
        icon: Icons.add,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 2,
                        color: AppColors.orange,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: AppColors.orange,
                            child: const Text(
                              'Crear Acción',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewName,
                                validator: (value) {
                                  if (value!.trim() == '') {
                                    return 'Escriba un nombre';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppButton(
                                  text: 'Atrás',
                                  onPressed: () {
                                    tcNewName.clear();
                                    Navigator.of(context).pop();
                                  },
                                  color: AppColors.orange),
                              AppButton(
                                  text: 'Guardar',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ProgressDialog.show(context);
                                      var resp =
                                          await _accionesApi.createAcciones(
                                              name: tcNewName.text.trim());
                                      if (resp is Success) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.success(msg: 'Acción Creada');
                                        Navigator.of(context).pop();
                                      }

                                      if (resp is Failure) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.error(msg: resp.messages[0]);
                                      }
                                    }
                                  },
                                  color: Colors.green),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Future<Widget> addButtonModulos() async {
    final _modulosApi = locator<ModulosApi>();
    TextEditingController tcNewName = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return CircleIconButton(
        color: AppColors.green,
        icon: Icons.add,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 2,
                        color: AppColors.orange,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: AppColors.orange,
                            child: const Text(
                              'Crear Módulo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tcNewName,
                                validator: (value) {
                                  if (value!.trim() == '') {
                                    return 'Escriba un nombre';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppButton(
                                  text: 'Atrás',
                                  onPressed: () {
                                    tcNewName.clear();
                                    Navigator.of(context).pop();
                                  },
                                  color: AppColors.orange),
                              AppButton(
                                  text: 'Guardar',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ProgressDialog.show(context);
                                      var resp =
                                          await _modulosApi.createModulos(
                                              name: tcNewName.text.trim());
                                      if (resp is Success) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.success(msg: 'Módulo Creado');
                                        Navigator.of(context).pop();
                                      }

                                      if (resp is Failure) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.error(msg: resp.messages[0]);
                                      }
                                    }
                                  },
                                  color: Colors.green),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Future<Widget> addButtonRecursos() async {
    final _recursosAPI = locator<RecursosAPI>();
    final _modulosAPI = locator<ModulosApi>();
    final size = MediaQuery.of(context).size;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    ModulosData? modulo;
    TextEditingController tcdescripcion = TextEditingController();
    List<ModulosData> modulos = [];

    var resp = await _modulosAPI.getModulos();

    if (resp is Success) {
      var response = resp.response as ModulosResponse;
      modulos = response.data;
      return CircleIconButton(
        color: AppColors.green,
        icon: Icons.add,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                clipBehavior: Clip.antiAlias,
                child: formCrearRecurso(
                  _formKey,
                  titulo: 'Nuevo Recurso',
                  controller: tcdescripcion,
                  modulos: modulos,
                  modulo: modulo,
                  size: size,
                  crear: (modulo) async {
                    ProgressDialog.show(context);
                    var resp = await _recursosAPI.createRecursos(
                      name: tcdescripcion.text.trim(),
                      idModulo: modulo!.id,
                    );
                    if (resp is Failure) {
                      ProgressDialog.dissmiss(context);
                      Dialogs.error(msg: resp.messages[0]);
                    } else {
                      ProgressDialog.dissmiss(context);
                      Dialogs.success(msg: 'Recurso creado');
                      tcdescripcion.clear();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              );
            },
          );
        },
      );
    } else if (resp is Failure) {
      modulos = [];
      Dialogs.error(msg: resp.messages[0]);
      return const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}
