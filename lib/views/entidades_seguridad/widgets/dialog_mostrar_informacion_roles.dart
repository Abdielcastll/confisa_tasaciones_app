import 'package:flutter/material.dart';
import 'package:tasaciones_app/widgets/app_circle_icon_button.dart';

import '../../../theme/theme.dart';

Widget dialogMostrarInformacionRoles(
  Widget imagen,
  List<Widget> informacion,
  Size size,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      imagen,
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
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
            ],
          ),
        ),
      ),
    ],
  );
}
