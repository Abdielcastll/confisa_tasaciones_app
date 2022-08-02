import 'package:flutter/material.dart';

Widget dialogMostrarInformacionPermisos(
  Widget imagen,
  Widget buscador,
  List<Widget> informacion,
  Size size,
  Widget buttons,
) {
  return SizedBox(
    width: size.width * .75,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imagen,
        buscador,
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: informacion,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: buttons,
        )
      ],
    ),
  );
}
