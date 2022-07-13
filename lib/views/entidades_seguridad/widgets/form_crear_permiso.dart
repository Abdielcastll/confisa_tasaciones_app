import 'package:flutter/material.dart';

import '../../../core/models/recursos_response.dart';
import '../../../core/models/acciones_response.dart';

Form formCrearPermiso(
    GlobalKey<FormState> _formKey,
    String descripcion,
    Map<String, dynamic> recurso,
    Map<String, dynamic> accion,
    Function crear,
    var measure,
    List<AccionesData> acciones,
    List<RecursosData> recursos) {
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Creacion de Permiso",
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  crear(descripcion);
                }
              },
              child: const Text("Crear"),
            ),
          ],
        ),
      ));
}
