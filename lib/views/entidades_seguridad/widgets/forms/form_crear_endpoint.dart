import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/endpoints_response.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';
import '../../../../theme/theme.dart';

class CrearEndpointForm extends StatelessWidget {
  CrearEndpointForm(
      {Key? key,
      required this.formKey,
      required this.size,
      required this.titulo,
      required this.validator,
      required this.modificar,
      required this.eliminar,
      required this.buttonTittle,
      required this.endpointsData,
      required this.showEliminar,
      required this.asignarPermiso})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final Size size;
  final String titulo;
  final bool validator, showEliminar;
  final Function modificar, eliminar, asignarPermiso;
  final String buttonTittle;
  final EndpointsData endpointsData;

  final _navigationService = locator<NavigatorService>();

  final List<String> _listaOpciones = ["GET", "POST", "PUT", "DELETE"];

  @override
  Widget build(BuildContext context) {
    String controlador = "";
    String nombre = "";
    String metodo = "";
    String httpVerbo = "";
    String selectedItem = endpointsData.httpVerbo;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size.height * .08,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
        Flexible(
          child: SingleChildScrollView(
            child: SizedBox(
              width: size.width * .75,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: endpointsData.nombre,
                            decoration: const InputDecoration(
                              labelText: "Nombre",
                              border: UnderlineInputBorder(),
                            ),
                            onSaved: (value) {
                              nombre = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return 'Debe ingresar un nombre válido';
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
                              border: UnderlineInputBorder(),
                            ),
                            onSaved: (value) {
                              controlador = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return 'Debe ingresar un controlador válido';
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
                              border: UnderlineInputBorder(),
                            ),
                            onSaved: (value) {
                              metodo = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return 'Debe ingresar un método válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownSearch<String>(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 3) {
                                return 'Debe seleccionar un verbo http';
                              }
                              return null;
                            },
                            selectedItem: selectedItem,
                            items: _listaOpciones,
                            onChanged: ((value) => selectedItem = value!),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        label: Text("Verbo HTTP"),
                                        border: UnderlineInputBorder())),
                            popupProps:
                                const PopupProps.menu(fit: FlexFit.loose),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          showEliminar
                              ? TextFormField(
                                  enabled: false,
                                  initialValue: endpointsData.estado
                                      ? "Activo"
                                      : "Inactivo",
                                  decoration: const InputDecoration(
                                    labelText: "Estado",
                                    border: UnderlineInputBorder(),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showEliminar
                  ? endpointsData.estado
                      ? TextButton(
                          onPressed: () => eliminar(), // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                AppIcons.trash,
                                color: AppColors.grey,
                              ),
                              SizedBox(
                                height: 3,
                              ), // icon
                              Text(
                                "Inactivar",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),
                              ), // text
                            ],
                          ),
                        )
                      : const SizedBox()
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
                      AppIcons.closeCircle,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 3,
                    ), // icon
                    Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 10),
                    ), // text
                  ],
                ),
              ),
              showEliminar
                  ? !endpointsData.estado
                      ? TextButton(
                          onPressed: () => eliminar(), // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                AppIcons.checkCircle,
                                color: AppColors.grey,
                              ),
                              SizedBox(
                                height: 3,
                              ), // icon
                              Text(
                                "Activar",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),
                              ), // text
                            ],
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox(),
              !showEliminar
                  ? const Expanded(child: SizedBox())
                  : const SizedBox(),
              showEliminar
                  ? TextButton(
                      onPressed: () => asignarPermiso(), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            AppIcons.iconPlus,
                            color: AppColors.gold,
                          ),
                          SizedBox(
                            height: 3,
                          ), // icon
                          Text(
                            "Permiso",
                            style: TextStyle(fontSize: 10),
                          ), // text
                        ],
                      ),
                    )
                  : const SizedBox(),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState?.save();
                    modificar(nombre, controlador, metodo, selectedItem);
                  }
                },
                // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      AppIcons.save,
                      color: AppColors.green,
                    ),
                    SizedBox(
                      height: 3,
                    ), // icon
                    Text(
                      "Guardar",
                      style: TextStyle(fontSize: 10),
                    ), // text
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
