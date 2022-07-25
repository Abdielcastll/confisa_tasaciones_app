import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';

Form formAsignarPermiso(
    String titulo,
    GlobalKey<FormState> _formKey,
    Map<String, dynamic> permiso,
    Function crear,
    var measure,
    List<PermisosData> permisos,
    Size size,
    bool validator,
    String buttonTittle) {
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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    validator: (value) =>
                        value == null ? 'Debe escojer un permiso' : null,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 3),
                        border: UnderlineInputBorder()),
                    items: permisos
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e.descripcion,
                                style: const TextStyle(fontSize: 13.2),
                              ),
                              value: e.id,
                            ))
                        .toList(),
                    hint: const Text("Permisos"),
                    onChanged: (value) {
                      measure = value;
                      permiso['id'] = value;
                      permiso["nombre"] = permisos
                          .firstWhere((element) => element.id == value)
                          .descripcion;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
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
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () {
                          if (!validator) {
                            _formKey.currentState?.save();
                            crear();
                          } else if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            crear();
                          }
                        },
                        // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.add_box_rounded,
                              color: AppColors.green,
                            ),
                            SizedBox(
                              height: 3,
                            ), // icon
                            Text("Asignar"), // text
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
