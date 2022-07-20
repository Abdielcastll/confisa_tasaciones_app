import 'package:flutter/material.dart';
import 'package:tasaciones_app/utils/icon_string.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';

List<Widget> menu(Menu menu) {
  List<Widget> drawerMenu = [];
  final _navigationService = locator<NavigatorService>();
  for (var element in menu.modulos) {
    drawerMenu.add(ExpansionTile(
      leading: getIcon(element.nombre),
      title: Text(
        element.nombre,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      children: element.opciones
          .map((e) => ListTile(
                title: Text(
                  e.opcion,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  _navigationService.pop();
                  _navigationService.navigateToPage(e.opcion);
                },
              ))
          .toList(),
    ));
  }

  return drawerMenu;
}

class Menu {
  Menu({required this.modulos});

  List<Modulo> modulos;
}

class Modulo {
  Modulo({required this.opciones, required this.nombre});
  String nombre;
  List<MenuOpcion> opciones;
}

class MenuOpcion {
  MenuOpcion({required this.opcion, required this.matenimiento});
  String opcion;
  String matenimiento;
}
