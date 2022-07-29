import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final icons = <String, IconData>{
  //Utilidad para obtener un icono segun su nombre mediante un map
  'Seguridad': Icons.settings,
  'General': Icons.app_registration_outlined,
  'Solicitudes': Icons.article_rounded,
  '': FontAwesomeIcons.penToSquare,
  '': FontAwesomeIcons.paperPlane,
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
