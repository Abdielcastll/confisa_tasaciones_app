import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../../../core/models/recursos_response.dart';
import '../../../core/models/acciones_response.dart';

Widget dialogMostrarInformacion(
  Widget imagen,
  List<Widget> informacion,
  Size size,
) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          imagen,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
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
  );
}
