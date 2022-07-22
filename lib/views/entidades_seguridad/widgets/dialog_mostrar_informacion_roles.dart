import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

Widget dialogMostrarInformacionRoles(Widget imagen, List<Widget> informacion,
    Size size, Function guardar, eliminar) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      imagen,
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => guardar(),
                  // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.save,
                        color: AppColors.green,
                      ),
                      SizedBox(
                        height: 3,
                      ), // icon
                      Text("Guardar"), // text
                    ],
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),
                TextButton(
                  onPressed: () => eliminar(), // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.delete,
                        color: AppColors.grey,
                      ),
                      SizedBox(
                        height: 3,
                      ), // icon
                      Text("Eliminar"), // text
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ],
  );
}
