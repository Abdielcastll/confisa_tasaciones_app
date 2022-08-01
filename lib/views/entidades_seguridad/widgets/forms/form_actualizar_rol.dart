import 'package:dropdown_search/dropdown_search.dart';
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
      required this.rol,
      required this.tiposRoles})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Size size;
  final String titulo;
  final bool validator, showEliminar;
  final Function modificar, changePermisos, eliminar;
  final String buttonTittle;
  final RolData rol;
  final List<RolTipeData> tiposRoles;

  final _navigationService = locator<NavigatorService>();
  @override
  Widget build(BuildContext context) {
    String descripcion = "";
    String nombre = "";
    Map<String, dynamic> tipoRol = {};
    if (rol.description.isNotEmpty) {
      tipoRol = {"id": rol.typeRole, "descripcion": rol.typeRoleDescription};
    }
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
                padding: const EdgeInsets.all(10),
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
                            value.length < 4) {
                          return 'Debe ingresar un nombre valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
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
                            value.length < 4) {
                          return 'Debe ingresar una descripcion valida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    !showEliminar
                        ? DropdownSearch<String>(
                            validator: (value) =>
                                value == null ? 'Debe escojer un tipo' : null,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              textAlignVertical: TextAlignVertical.center,
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                hintText: "Tipo de Rol",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                            items: tiposRoles
                                .map(
                                  (e) => e.descripcion,
                                )
                                .toList(),
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                              fit: FlexFit.loose,
                            ),
                            onChanged: (value) {
                              tipoRol['descripcion'] = value;
                              tipoRol["id"] = tiposRoles
                                  .firstWhere(
                                      (element) => element.descripcion == value)
                                  .id;
                            },
                          )
                        : DropdownSearch<String>(
                            selectedItem: rol.typeRoleDescription,
                            validator: (value) =>
                                value == null ? 'Debe escojer un tipo' : null,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              textAlignVertical: TextAlignVertical.center,
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                hintText: "Tipo de Rol",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                            items: tiposRoles
                                .map(
                                  (e) => e.descripcion,
                                )
                                .toList(),
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                              fit: FlexFit.loose,
                            ),
                            onChanged: (value) {
                              tipoRol['descripcion'] = value;
                              tipoRol["id"] = tiposRoles
                                  .firstWhere(
                                      (element) => element.descripcion == value)
                                  .id;
                            },
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
                                      AppIcons.trash,
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
                        showEliminar ? const Spacer() : const SizedBox(),
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
                              SizedBox(height: 3), // icon
                              Text("Cancelar"), // text
                            ],
                          ),
                        ),
                        const Spacer(),
                        showEliminar
                            ? TextButton(
                                onPressed: () => changePermisos(),
                                // button pressed
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
                                    Text("Permisos"), // text
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        showEliminar ? const Spacer() : const SizedBox(),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              modificar(nombre, descripcion, tipoRol);
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
