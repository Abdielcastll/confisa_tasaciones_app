import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';

Widget dialogActualizarRolesUsuario(
  Size size,
  BuildContext context,
  GlobalKey<FormState> _formKey,
  List<RolData> roles,
  bool validator,
  Function modificar,
  var dropdown,
  Map<String, dynamic> rol1,
  Map<String, dynamic> rol2,
) {
  rol1['id'] = "";
  rol1["nombre"] = "";
  rol1["description"] = "";
  rol2['id'] = "";
  rol2["nombre"] = "";
  rol2["description"] = "";
  final _navigationService = locator<NavigatorService>();
  return Form(
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
                color: AppColors.gold,
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text("Asignar Rol",
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
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
                    decoration:
                        const InputDecoration(border: UnderlineInputBorder()),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            modificar();
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
                  )
                ],
              ),
            ),
          ],
        ),
      ));
}
