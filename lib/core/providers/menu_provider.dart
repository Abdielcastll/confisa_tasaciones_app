import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';

class MenuProvider with ChangeNotifier {
  late MenuResponse _menu =
      MenuResponse(data: [MenuData(id: 0, nombre: "", recursos: [])]);
  MenuResponse get menu => _menu;
  set menu(MenuResponse value) {
    _menu = value;
    notifyListeners();
  }
}
