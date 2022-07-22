import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.green,
                        minimumSize: const Size.fromHeight(60)),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (!validator) {
                        _formKey.currentState?.save();
                        crear();
                      } else if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        crear();
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
