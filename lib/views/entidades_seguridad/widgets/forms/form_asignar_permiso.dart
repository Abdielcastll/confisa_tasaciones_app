import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/permisos_response.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../../core/locator.dart';
import '../../../../core/services/navigator_service.dart';

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
                    height: 20,
                  ),
                  DropdownSearch<String>(
                    validator: (value) =>
                        value == null ? 'Debe escojer un permiso' : null,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          hintText: "Permisos",
                          contentPadding: EdgeInsets.only(left: 3),
                          border: UnderlineInputBorder()),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    popupProps: const PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: true,
                        searchDelay: Duration(microseconds: 0)),
                    items: permisos
                        .map(
                          (e) => e.descripcion,
                        )
                        .toList(),
                    onChanged: (value) {
                      measure = value;
                      permiso['nombre'] = value;
                      permiso["id"] = permisos
                          .firstWhere((element) => element.descripcion == value)
                          .id;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                            Text("Cancelar"), // text
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (!validator) {
                            _formKey.currentState?.save();
                            crear();
                          } else if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            crear();
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
                            Text("Asignar"), // text
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
