import 'package:flutter/material.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';

import '../../../core/api/acciones_api.dart';
import '../../../core/api/api_status.dart';
import '../../../core/api/permisos_api.dart';
import '../../../core/api/recursos_api.dart';
import '../../../core/locator.dart';
import '../../../core/models/acciones_response.dart';
import '../../../core/models/permisos_response.dart';
import '../../../core/models/recursos_response.dart';
import '../../../theme/theme.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/app_dialogs.dart';
import 'form_crear_permiso.dart';

class ChangeButtons {
  late BuildContext context;
  final Size size;
  ChangeButtons({required this.context, required this.size});
  Future<Widget> addButtonPermisos() async {
    final _accionesApi = locator<AccionesApi>();
    final _recursosApi = locator<RecursosAPI>();
    final _permisosApi = locator<PermisosAPI>();
    String descripcion = "";
    Map<String, dynamic> accion = {};
    Map<String, dynamic> recurso = {};
    dynamic opcion;
    // ProgressDialog.show(context);
    var resp = await _accionesApi.getAcciones();
    if (resp is Success<AccionesResponse>) {
      var resp2 = await _recursosApi.getRecursos();
      if (resp2 is Success<RecursosResponse>) {
        // ProgressDialog.dissmiss(context);
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
                        // ProgressDialog.show(context);
                        var creacion = await _permisosApi.createPermisos(
                            descripcion: descripcionf,
                            idAccion: accion["id"],
                            idRecurso: recurso["id"],
                            esBasico: 1);
                        if (creacion is Success<PermisosData>) {
                          // ProgressDialog.dissmiss(context);
                          Dialogs.alert(context,
                              tittle: "Creacion exitosa",
                              description: ["Permiso creado con exito"]);
                          _formKey.currentState?.reset();
                        } else if (creacion is Failure) {
                          // ProgressDialog.dissmiss(context);
                          Dialogs.alert(context,
                              tittle: creacion.messages[0],
                              description: creacion.messages);
                        }
                      }, opcion, resp.response.data, resp2.response.data, [],
                          size, false, "Crear"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ));
                }));
      } else if (resp2 is Failure) {
        // ProgressDialog.dissmiss(context);
        Dialogs.alert(
          context,
          tittle: 'Error',
          description: resp2.messages,
        );
      }
    } else if (resp is Failure) {
      // ProgressDialog.dissmiss(context);
      Dialogs.alert(
        context,
        tittle: 'Error',
        description: resp.messages,
      );
    }
    return Container();
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
                                        Dialogs.alert(context,
                                            tittle: '',
                                            description: ['Acción Creada']);
                                      }

                                      if (resp is Failure) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.alert(context,
                                            tittle: 'Error',
                                            description: resp.messages);
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
                              'Crear Recurso',
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
                                          await _recursosAPI.createRecursos(
                                              name: tcNewName.text.trim());
                                      if (resp is Success) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.alert(context,
                                            tittle: '',
                                            description: ['Recurso Creado']);
                                      }

                                      if (resp is Failure) {
                                        ProgressDialog.dissmiss(context);
                                        Dialogs.alert(context,
                                            tittle: 'Error',
                                            description: resp.messages);
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
}
