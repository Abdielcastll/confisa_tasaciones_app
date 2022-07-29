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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => eliminar(), // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.trash,
                          color: AppColors.grey,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Eliminar"), // text
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                    },
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.closeCircle,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Cancelar"), // text
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => asignar(),
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.iconPlus,
                          color: AppColors.gold,
                        ),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Asignar"), // text
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => guardar(),
                    // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          AppIcons.save,
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
