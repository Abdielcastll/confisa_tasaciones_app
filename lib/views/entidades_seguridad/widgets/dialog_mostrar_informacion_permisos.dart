import 'package:flutter/material.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';

import '../../../theme/theme.dart';

Widget dialogMostrarInformacionPermisos(
  Widget imagen,
  List<Widget> informacion,
  Size size,
) {
  return Stack(
    children: [
      imagen,
      Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: informacion,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
