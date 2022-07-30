import 'package:flutter/material.dart';

Widget dialogMostrarInformacionPermisos(
  Widget imagen,
  Widget buscador,
  List<Widget> informacion,
  Size size,
  Widget buttons,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      imagen,
      buscador,
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: informacion,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: buttons,
      )
    ],
  );
}
