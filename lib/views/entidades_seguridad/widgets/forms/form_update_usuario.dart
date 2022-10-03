import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/authentication_client.dart';
import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';

Form dialogActualizarInformacion(
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
  int idSuplidor,
) {
  final _navigationService = locator<NavigatorService>();
  final session = locator<AuthenticationClient>().loadSession;
  int noTasador = 0;
  return Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 15,
        ),
        imagen,
        Flexible(
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                        label: Text("Nombre"), border: UnderlineInputBorder()),
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
                          return 'Debe ingresar un nombre válido';
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
                        label: Text("Teléfono"),
                        border: UnderlineInputBorder()),
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
                          return 'Debe ingresar un teléfono válido';
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
                        label: Text("Email"), border: UnderlineInputBorder()),
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
                          return 'Debe ingresar un email válido';
                        }
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  usuariosData.roles
                          .any((element) => (element.description == "Tasador"))
                      ? TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: usuariosData.noTasador.toString(),
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text("No Tasador")),
                          onSaved: (value) {
                            value != ""
                                ? noTasador = int.parse(value!)
                                : noTasador = 0;
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 4) {
                              return 'Debe ingresar un no tasador';
                            }

                            return null;
                          },
                        )
                      : const SizedBox.shrink(),
                  !usuariosData.roles
                          .any((element) => (element.description == "Tasador"))
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),
                  TextFormField(
                    readOnly: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black54),
                    initialValue: usuariosData.roles
                        .map((e) => e.description)
                        .toList()
                        .join(", "),
                    decoration: const InputDecoration(
                        label: Text("Roles"), border: UnderlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  usuariosData.roles.first.typeRolDescription == "Externo"
                      ? TextFormField(
                          readOnly: true,
                          maxLines: null,
                          initialValue: usuariosData.nombreSuplidor == ""
                              ? "Ninguno"
                              : usuariosData.nombreSuplidor,
                          style: const TextStyle(color: Colors.black54),
                          decoration: const InputDecoration(
                              label: Text("Suplidor"),
                              border: UnderlineInputBorder()),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black54),
                    initialValue: usuariosData.isActive ? "Activo" : "Inactivo",
                    decoration: const InputDecoration(
                        label: Text("Estado"), border: UnderlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ]),
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
                    AppIcons.closeCircle,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 3,
                  ), // icon
                  Text("Cancelar"), // text
                ],
              ),
            ),
            session.role.any((element) =>
                    element == "Administrador" ||
                    element == "AprobadorTasaciones")
                ? TextButton(
                    onPressed: () => changeRol(),
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.accountOutline,
                          color: AppColors.gold,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Roles"), // text
                      ],
                    ),
                  )
                : idSuplidor == usuariosData.idSuplidor
                    ? TextButton(
                        onPressed: () => changeRol(),
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              AppIcons.accountOutline,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Roles"), // text
                          ],
                        ),
                      )
                    : idSuplidor == usuariosData.idSuplidor
                        ? TextButton(
                            onPressed: () => changeRol(),
                            // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(
                                  AppIcons.accountOutline,
                                  color: AppColors.gold,
                                ),
                                SizedBox(
                                  height: 3,
                                ), // icon
                                Text("Roles"), // text
                              ],
                            ),
                          )
                        : const SizedBox(),
            TextButton(
              onPressed: () => changeStatus(),
              // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    AppIcons.pencilAlt,
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        modificar(nombreCompleto, email, telefono, noTasador);
                      } else if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        modificar(nombreCompleto, email, telefono, noTasador);
                      }
                    },
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.save,
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
  );
}
