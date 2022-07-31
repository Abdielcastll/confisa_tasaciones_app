import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';

import '../models/recursos_response.dart';

class MenuProvider with ChangeNotifier {
  late MenuResponse _menu = MenuResponse(data: [
    MenuData(id: 0, nombre: "", recursos: [
      RecursosData(
        id: 0,
        estado: 0,
        nombre: "",
        idModulo: 0,
        descripcionMenuConfiguracion: "",
        esMenuConfiguracion: 0,
      )
    ])
  ]);
  MenuResponse get menu => _menu;
  set menu(MenuResponse value) {
    _menu = value;
    notifyListeners();
  }
}
