import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';
import '../../../../theme/theme.dart';

class CrearEndpointForm extends StatelessWidget {
  CrearEndpointForm(
      {Key? key,
      required GlobalKey<FormState> formKey,
      required this.size,
      required this.titulo,
      required this.validator,
      required this.modificar,
      required this.eliminar,
      required this.controlador,
      required this.buttonTittle,
      required this.nombre,
      required this.httpVerbo,
      required this.metodo,
      required this.endpointsData,
      required this.showEliminar,
      required this.asignarPermiso})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Size size;
  final String titulo;
  final bool validator, showEliminar;
  final Function modificar, eliminar, asignarPermiso;
  late String controlador;
  late String metodo;
  late String httpVerbo;
  final String buttonTittle;
  final EndpointsData endpointsData;
  late String nombre;
  final _navigationService = locator<NavigatorService>();
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: endpointsData.nombre,
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
                      initialValue: endpointsData.controlador,
                      decoration: const InputDecoration(
                          labelText: "Controlador",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        controlador = value!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'Debe ingresar un controlador valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: endpointsData.metodo,
                      decoration: const InputDecoration(
                          labelText: "Metodo",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        metodo = value!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'Debe ingresar un metodo valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: endpointsData.httpVerbo,
                      decoration: const InputDecoration(
                          labelText: "Verbo HTTP",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        httpVerbo = value!;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Debe ingresar un verbo http valudo';
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
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              modificar(nombre, controlador, metodo, httpVerbo);
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
                                onPressed: () =>
                                    asignarPermiso(), // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.cached,
                                      color: AppColors.gold,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ), // icon
                                    Text("Permiso"), // text
                                  ],
                                ),
                              )
                            : const SizedBox(
                                width: 0,
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
                            : const SizedBox(
                                width: 0,
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
}
