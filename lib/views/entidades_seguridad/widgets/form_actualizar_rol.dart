import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class ActualizarRolForm extends StatelessWidget {
  ActualizarRolForm(
      {Key? key,
      required GlobalKey<FormState> formKey,
      required this.size,
      required this.titulo,
      required this.informacion,
      required this.validator,
      required this.modificar,
      required this.descripcion,
      required this.buttonTittle,
      required this.nombre})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Size size;
  final String titulo;
  final List<Widget> informacion;
  final bool validator;
  final Function modificar;
  late String descripcion;
  final String buttonTittle;
  late String nombre;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
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
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nombre",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        nombre = value!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'Debe ingresar un nombre valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Descripcion",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        descripcion = value!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'Debe ingresar una descripcion valida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.green,
                          minimumSize: const Size.fromHeight(60)),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          modificar(nombre, descripcion);
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
}
