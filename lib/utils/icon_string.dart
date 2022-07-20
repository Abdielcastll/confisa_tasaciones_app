import 'package:flutter/material.dart';

final icons = <String, IconData>{
  //Utilidad para obtener un icono segun su nombre mediante un map
  'Seguridad': Icons.settings,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
  // 'account_circle': Icons.account_circle,
};

Icon getIcon(String nombreIcono) {
  Icon icon = Icon(icons[nombreIcono]);

  return icon;
}
