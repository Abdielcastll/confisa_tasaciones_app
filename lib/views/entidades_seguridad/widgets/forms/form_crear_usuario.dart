import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/api/api_status.dart';
import 'package:tasaciones_app/core/api/usuarios_api.dart';
import 'package:tasaciones_app/core/locator.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/widgets/app_dialogs.dart';

import '../../../../core/authentication_client.dart';

Future<dynamic> dialogCrearUsuario(
  String titulo,
  Size size,
  BuildContext context,
  GlobalKey<FormState> _formKey,
  List<RolData> roles,
  String nombreCompleto,
  String telefono,
  String email,
  bool validator,
  Function modificar,
  var dropdown,
  String buttonTittle,
  Map<String, dynamic> rol1,
) {
  List<Widget> permisoRol = [];
  rol1['id'] = "";
  rol1["nombre"] = "";
  rol1["description"] = "";
  int codSuplidor = 0;
  final _usuariosApi = locator<UsuariosAPI>();
  final user = locator<AuthenticationClient>().loadSession;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: ((BuildContext context, setState) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: size.height * .08,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.orange,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(titulo,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  border: OutlineInputBorder()),
                              items: roles
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.description),
                                        value: e.id,
                                      ))
                                  .toList(),
                              hint: const Text("Rol"),
                              onChanged: (value) {
                                setState(
                                  () => permisoRol = [],
                                );

                                dropdown = value;
                                rol1['id'] = value;
                                rol1["nombre"] = roles
                                    .firstWhere(
                                        (element) => element.id == value)
                                    .name;
                                rol1["description"] = roles
                                    .firstWhere(
                                        (element) => element.id == value)
                                    .description;
                                if (rol1["description"] ==
                                        "Aprobrador Tasaciones" ||
                                    rol1["description"] == "Tasador") {
                                  setState(
                                    () async {
                                      for (var element in user.role) {
                                        if (element == "Aprobador Tasaciones") {
                                          ProgressDialog.show(context);
                                          var resp = await _usuariosApi
                                              .getUsuarios(email: user.email);
                                          if (resp
                                              is Success<UsuariosResponse>) {
                                            codSuplidor = resp
                                                .response.data.first.idSuplidor;
                                            ProgressDialog.dissmiss(context);
                                            permisoRol.add(
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            );
                                            permisoRol.add(
                                              Text(
                                                  "Suplidor ${resp.response.data.first.nombreSuplidor}",
                                                  style: appDropdown),
                                            );
                                          } else if (resp is Failure) {
                                            ProgressDialog.dissmiss(context);
                                            Dialogs.alert(context,
                                                tittle: "Error",
                                                description: resp.messages);
                                          }
                                        }
                                      }
                                      permisoRol = [
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Nombre Completo',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.0),
                                              ),
                                              border: OutlineInputBorder()),
                                          onSaved: (value) {
                                            nombreCompleto = value!;
                                          },
                                          validator: (value) {
                                            if (validator &&
                                                (email != "" ||
                                                    nombreCompleto != "" ||
                                                    telefono != "")) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 8) {
                                                return 'Debe ingresar un nombre valido';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              labelText: 'Telefono',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.0),
                                              ),
                                              border: OutlineInputBorder()),
                                          onSaved: (value) {
                                            telefono = value!;
                                          },
                                          validator: (value) {
                                            if (validator &&
                                                (email != "" ||
                                                    nombreCompleto != "" ||
                                                    telefono != "")) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 9) {
                                                return 'Debe ingresar un telefono valido';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Email',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.0),
                                              ),
                                              border: OutlineInputBorder()),
                                          onSaved: (value) {
                                            email = value!;
                                          },
                                          validator: (value) {
                                            if (validator &&
                                                (email != "" ||
                                                    nombreCompleto != "" ||
                                                    telefono != "")) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 8 ||
                                                  !EmailValidator.validate(
                                                      value, true, true)) {
                                                return 'Debe ingresar un email valido';
                                              }
                                            }

                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: AppColors.green,
                                              minimumSize:
                                                  const Size.fromHeight(60)),
                                          onPressed: () {
                                            // Validate returns true if the form is valid, or false otherwise.
                                            _formKey.currentState?.save();
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState?.save();
                                              modificar(nombreCompleto, email,
                                                  telefono);
                                            }
                                          },
                                          child: Text(buttonTittle),
                                        ),
                                      ];
                                    },
                                  );
                                } else if (rol1["description"] ==
                                        "Administrador" ||
                                    rol1["description"] ==
                                        "Aprobador Facturas" ||
                                    rol1["description"] == "Oficial Negocios") {
                                  permisoRol = [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Email',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          border: OutlineInputBorder()),
                                      onSaved: (value) {
                                        email = value!;
                                      },
                                      validator: (value) {
                                        if (validator &&
                                            (email != "" ||
                                                nombreCompleto != "" ||
                                                telefono != "")) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.length < 8 ||
                                              !EmailValidator.validate(
                                                  value, true, true)) {
                                            return 'Debe ingresar un email valido';
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: AppColors.green,
                                          minimumSize:
                                              const Size.fromHeight(60)),
                                      onPressed: () async {
                                        // Validate returns true if the form is valid, or false otherwise.
                                        _formKey.currentState?.save();
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState?.save();
                                          ProgressDialog.show(context);
                                          var resp = await _usuariosApi
                                              .getUsuarioDomain(email: email);
                                          if (resp
                                              is Success<UsuarioDomainData>) {
                                            ProgressDialog.dissmiss(context);
                                            setState((() {
                                              permisoRol = [
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                    "Nombre ${resp.response.nombreCompleto}",
                                                    style: appDropdown),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                    "Puesto  ${resp.response.puesto}",
                                                    style: appDropdown),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Telefono  ${resp.response.telefono}",
                                                  style: appDropdown,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              AppColors.green,
                                                          minimumSize: const Size
                                                              .fromHeight(60)),
                                                  onPressed: () {
                                                    // Validate returns true if the form is valid, or false otherwise.

                                                    modificar(
                                                        resp.response
                                                            .nombreCompleto,
                                                        resp.response.email,
                                                        resp.response.telefono);
                                                  },
                                                  child: const Text("Guardar"),
                                                ),
                                              ];
                                            }));
                                          } else if (resp is Failure) {
                                            ProgressDialog.dissmiss(context);
                                            Dialogs.alert(context,
                                                tittle: "Error de Conexion",
                                                description: resp.messages);
                                          }
                                        }
                                      },
                                      child: const Text("Buscar"),
                                    ),
                                  ];
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: permisoRol,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.zero,
          );
        }));
      });
}
