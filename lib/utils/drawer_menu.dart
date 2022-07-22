import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';
import 'package:tasaciones_app/utils/icon_string.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';

List<Widget> menu(MenuResponse menu) {
  List<Widget> drawerMenu = [];
  final _navigationService = locator<NavigatorService>();
  for (var element in menu.data) {
    drawerMenu.add(ExpansionTile(
      leading: getIcon(element.nombre),
      title: Text(
        element.nombre,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      children: element.recursos
          .map((e) => ListTile(
                title: Text(
                  e.nombre,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  _navigationService.pop();
                  _navigationService.navigateToPage(e.nombre);
                },
              ))
          .toList(),
    ));
  }

  return drawerMenu;
}
