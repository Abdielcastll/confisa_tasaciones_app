import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

Widget dialogActualizarInformacion(
  Widget imagen,
  List<Widget> informacion,
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
  Map<String, dynamic> rol2,
) {
  rol1['id'] = "";
  rol1["nombre"] = "";
  rol1["description"] = "";
  rol2['id'] = "";
  rol2["nombre"] = "";
  rol2["description"] = "";
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
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
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
                      dropdown = value;
                      rol1['id'] = value;
                      rol1["nombre"] = roles
                          .firstWhere((element) => element.id == value)
                          .name;
                      rol1["description"] = roles
                          .firstWhere((element) => element.id == value)
                          .description;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    items: roles
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: e.id,
                            ))
                        .toList(),
                    hint: const Text("Segundo rol"),
                    onChanged: (value) {
                      dropdown = value;
                      rol2['id'] = value;
                      rol2["nombre"] = roles
                          .firstWhere((element) => element.id == value)
                          .description;
                      rol2["description"] = roles
                          .firstWhere((element) => element.id == value)
                          .description;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.green,
                        minimumSize: const Size.fromHeight(60)),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        modificar(nombreCompleto, email, telefono);
                      }
                    },
                    child: Text(buttonTittle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
