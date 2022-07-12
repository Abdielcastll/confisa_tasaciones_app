import 'package:flutter/material.dart';

import '../../../core/models/recursos_response.dart';
import '../../../core/models/acciones_response.dart';

Form formCrearPermiso(
    GlobalKey<FormState> _formKey,
    String firstName,
    String lastName,
    String bodyTemp,
    measure,
    Function crear,
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
              onFieldSubmitted: (value) {
                firstName = value;
              },
              onChanged: (value) {
                firstName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 3) {
                  return 'First Name must contain at least 3 characters';
                } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                  return 'First Name cannot contain special characters';
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
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
                },
                onSaved: (value) {
                  measure = value;
                }),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
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
                  // measureList.add(measure);
                },
                onSaved: (value) {
                  measure = value;
                }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  crear;
                }
              },
              child: const Text("Crear"),
            ),
          ],
        ),
      ));
}
