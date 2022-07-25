import 'package:flutter/material.dart';

import '../../../core/locator.dart';
import '../../../core/services/navigator_service.dart';
import '../../../theme/theme.dart';

Widget dialogMostrarInformacionRoles(Widget imagen, List<Widget> informacion,
    Size size, Function guardar, eliminar, asignar) {
  final _navigationService = locator<NavigatorService>();
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
                children: informacion,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                    },
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Cancelar"), // text
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: () => asignar(),
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.add_circle,
                          color: AppColors.gold,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Asignar"), // text
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
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
                        Text("Actualizar"), // text
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}
