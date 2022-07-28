import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';

Widget dialogActualizarInformacion(
  Widget imagen,
  Size size,
  BuildContext context,
  GlobalKey<FormState> _formKey,
  String nombreCompleto,
  String telefono,
  String email,
  bool validator,
  Function modificar,
  String buttonTittle,
  UsuariosData usuariosData,
  Function changeStatus,
  Function changeRol,
) {
  final _navigationService = locator<NavigatorService>();
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  imagen,
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    enabled: !usuariosData.roles.any((element) =>
                        (element.description == "Administrador" ||
                            element.description == "Aprobador Facturas" ||
                            element.description == "Oficial Negocios")),
                    initialValue: usuariosData.nombreCompleto,
                    decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                        border: UnderlineInputBorder()),
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
                    enabled: !usuariosData.roles.any((element) =>
                        (element.description == "Administrador" ||
                            element.description == "Aprobador Facturas" ||
                            element.description == "Oficial Negocios")),
                    initialValue: usuariosData.phoneNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Telefono', border: UnderlineInputBorder()),
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
                    enabled: !usuariosData.roles.any((element) =>
                        (element.description == "Administrador" ||
                            element.description == "Aprobador Facturas" ||
                            element.description == "Oficial Negocios")),
                    initialValue: usuariosData.email,
                    decoration: const InputDecoration(
                        labelText: 'Email', border: UnderlineInputBorder()),
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
                            !EmailValidator.validate(value, true, true)) {
                          return 'Debe ingresar un email valido';
                        }
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black54),
                    initialValue: usuariosData.roles
                        .map((e) => e.description)
                        .toList()
                        .join(", "),
                    decoration: const InputDecoration(
                        labelText: 'Roles', border: UnderlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    maxLines: null,
                    initialValue: usuariosData.nombreSuplidor == ""
                        ? "Ninguno"
                        : usuariosData.nombreSuplidor,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                        labelText: 'Suplidor', border: UnderlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black54),
                    initialValue: usuariosData.isActive ? "Activo" : "Inactivo",
                    decoration: const InputDecoration(
                        labelText: 'Estado', border: UnderlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          _navigationService.pop();
                        },
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Cancelar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => changeRol(),
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.account_circle_rounded,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Roles"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => changeStatus(),
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.assignment_ind_sharp,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Estado"), // text
                          ],
                        ),
                      ),
                      !usuariosData.roles.any((element) =>
                              (element.description == "Administrador" ||
                                  element.description == "Aprobador Facturas" ||
                                  element.description == "Oficial Negocios"))
                          ? TextButton(
                              onPressed: () {
                                if (validator) {
                                  _formKey.currentState?.save();
                                  modificar(nombreCompleto, email, telefono);
                                } else if (_formKey.currentState!.validate()) {
                                  _formKey.currentState?.save();
                                  modificar(nombreCompleto, email, telefono);
                                }
                              },
                              // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.save,
                                    color: AppColors.green,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ), // icon
                                  Text("Guardar"), // text
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
