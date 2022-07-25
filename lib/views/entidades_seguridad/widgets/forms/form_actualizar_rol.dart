import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/roles_response.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';
import '../../../../theme/theme.dart';

class ActualizarRolForm extends StatelessWidget {
  ActualizarRolForm(
      {Key? key,
      required GlobalKey<FormState> formKey,
      required this.size,
      required this.titulo,
      required this.validator,
      required this.modificar,
      required this.changePermisos,
      required this.eliminar,
      required this.buttonTittle,
      required this.showEliminar,
      required this.rol})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Size size;
  final String titulo;
  final bool validator, showEliminar;
  final Function modificar, changePermisos, eliminar;
  final String buttonTittle;
  final RolData rol;

  final _navigationService = locator<NavigatorService>();
  @override
  Widget build(BuildContext context) {
    String descripcion = "";
    String nombre = "";
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
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: rol.name,
                      decoration: const InputDecoration(
                          labelText: "Nombre", border: UnderlineInputBorder()),
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
                      initialValue: rol.description,
                      decoration: const InputDecoration(
                          labelText: "Descripcion",
                          border: UnderlineInputBorder()),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        showEliminar
                            ? const Expanded(child: SizedBox())
                            : const SizedBox(),
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
                        showEliminar
                            ? TextButton(
                                onPressed: () => changePermisos(),
                                // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.add_circle,
                                      color: AppColors.gold,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ), // icon
                                    Text("Permisos"), // text
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        showEliminar
                            ? const Expanded(child: SizedBox())
                            : const SizedBox(),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              modificar(nombre, descripcion);
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
