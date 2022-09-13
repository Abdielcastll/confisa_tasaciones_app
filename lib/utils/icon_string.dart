import 'package:flutter/material.dart';

final icons = <String, IconData>{
  //Utilidad para obtener un icono segun su nombre mediante un map
  'Mant. Seguridad': Icons.settings,
  'Mant. General': Icons.app_registration_outlined,
  'Mant. Solicitudes': Icons.article_rounded,
  'Solicitudes': Icons.article_rounded,
  'Mantenimientos': Icons.settings,
  'General': Icons.manage_search_rounded
};

Icon getIcon(String nombreIcono) {
  Icon icon = Icon(icons[nombreIcono]);

  return icon;
}
