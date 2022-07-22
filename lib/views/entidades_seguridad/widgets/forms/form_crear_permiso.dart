import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/locator.dart';
import '../../../../core/models/acciones_response.dart';
import '../../../../core/models/recursos_response.dart';
import '../../../../core/services/navigator_service.dart';

Form formCrearPermiso(
    String titulo,
    GlobalKey<FormState> _formKey,
    String descripcion,
    Map<String, dynamic> recurso,
    Map<String, dynamic> accion,
    Function crear,
    Function eliminar,
    var measure,
    List<AccionesData> acciones,
    List<RecursosData> recursos,
    List<Widget> informacion,
    Size size,
    bool validator,
    String buttonTittle,
    bool showEliminar) {
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
                    height: 5,
                  ),
                  Column(
                    children: informacion,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Descripcion',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onSaved: (value) {
                      descripcion = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'First Name must contain at least 3 characters';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'First Name cannot contain special characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    validator: (value) =>
                        value == null ? 'Debe escojer una accion' : null,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    items: acciones
                        .map((e) => DropdownMenuItem(
                              child: Text(e.nombre),
                              value: e.id,
                            ))
                        .toList(),
                    hint: const Text("Acciones"),
                    onChanged: (value) {
                      measure = value;
                      accion['id'] = value;
                      accion["nombre"] = acciones
                          .firstWhere((element) => element.id == value)
                          .nombre;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    validator: (value) =>
                        value == null ? 'Debe escojer un recurso' : null,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    items: recursos
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e.nombre,
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: e.id,
                            ))
                        .toList(),
                    hint: const Text("Recursos"),
                    onChanged: (value) {
                      measure = value;
                      recurso['id'] = value;
                      recurso["nombre"] = recursos
                          .firstWhere((element) => element.id == value)
                          .nombre;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (validator) {
                            _formKey.currentState?.save();
                            crear(descripcion);
                          } else if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            crear(descripcion);
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
                      showEliminar
                          ? const Expanded(child: SizedBox())
                          : const SizedBox(),
                      showEliminar
                          ? TextButton(
                              onPressed: () => eliminar(), // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.delete,
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ), // icon
                                  Text("Eliminar"), // text
                                ],
                              ),
                            )
                          : const SizedBox(),
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
