import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/core/models/usuarios_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/views/entidades_seguridad/widgets/forms/form_update_roles_usuarios.dart';

import '../../../../core/api/roles_api.dart';
import '../../../../core/api/usuarios_api.dart';
import '../../../../core/api/api_status.dart';
import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';
import '../../../../widgets/app_dialogs.dart';

Widget dialogActualizarInformacion(
  Widget imagen,
  List<Widget> informacion,
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
  final _rolesApi = locator<RolesAPI>();
  final _navigationService = locator<NavigatorService>();
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  imagen,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: informacion,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: usuariosData.nombreCompleto,
                    decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
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
                    initialValue: usuariosData.phoneNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Telefono',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
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
                    initialValue: usuariosData.email,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
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
                      ),
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () => changeRol(),
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.cached,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Roles"), // text
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () => changeStatus(),
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.cached,
                              color: AppColors.gold,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Estado"), // text
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
