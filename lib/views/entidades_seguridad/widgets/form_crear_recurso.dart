import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../core/models/modulos_response.dart';

Form formCrearRecurso(
  GlobalKey<FormState> _formKey, {
  required String titulo,
  required TextEditingController controller,
  required ModulosData? modulo,
  required Function(ModulosData?) crear,
  required List<ModulosData> modulos,
  required Size size,
}) {
  return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: size.height * .08,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: AppColors.orange,
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    controller: controller,
                    validator: (value) {
                      if (value!.length < 3) {
                        return 'Nombre inválido';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<ModulosData>(
                    validator: (value) =>
                        value == null ? 'Debe escojer un módulo' : null,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    items: modulos
                        .map((e) => DropdownMenuItem<ModulosData>(
                              child: Text(e.nombre),
                              value: e,
                            ))
                        .toList(),
                    hint: const Text("Módulos"),
                    onChanged: (value) {
                      modulo = value;
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        crear(modulo);
                      }
                    },
                    child: const Text('Crear'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
