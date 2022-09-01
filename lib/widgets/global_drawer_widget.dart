import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/core/models/menu_response.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/utils/drawer_menu.dart';
import 'package:tasaciones_app/views/Perfil_de_usuario/perfil_view.dart';
import 'package:tasaciones_app/views/acciones_solicitud/acciones_solicitud_view.dart';
import 'package:tasaciones_app/views/alarmas/alarmas_view.dart';
import 'package:tasaciones_app/views/notas/notas_view.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';
import '../views/auth/login/login_view.dart';

class GlobalDrawerDartDesktop extends StatelessWidget {
  GlobalDrawerDartDesktop({Key? key, required this.menuApp}) : super(key: key);

  final MenuResponse menuApp;
  final _navigationService = locator<NavigatorService>();
  final _authenticationClient = locator<AuthenticationClient>();

  @override
  Widget build(BuildContext context) {
    var dataUser = _authenticationClient.loadSession;
    Size size = MediaQuery.of(context).size;

    return Drawer(
      child: Container(
        color: AppColors.cream,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.gold),
              height: size.height * .2,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dataUser.nombreCompleto,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      dataUser.email,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  /* Opciones del menu */
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                        /* Recorrido de la lista de role claims que devuelve las opciones del menu */
                        children: [
                          if (menuApp.data.isNotEmpty) ...menu(menuApp),
                          // ListTile(
                          //   leading:
                          //       const Icon(Icons.document_scanner_outlined),
                          //   title: const Text(
                          //     'Solicitar estimación',
                          //     style: TextStyle(
                          //         fontSize: 17, fontWeight: FontWeight.w500),
                          //   ),
                          //   onTap: () {
                          //     _navigationService.pop();
                          //     _navigationService.navigateToPage(
                          //         SolicitudEstimacionView.routeName);
                          //   },
                          // ),
                          // ListTile(
                          //   leading:
                          //       const Icon(Icons.document_scanner_outlined),
                          //   title: const Text(
                          //     'Solicitar Tasación',
                          //     style: TextStyle(
                          //         fontSize: 17, fontWeight: FontWeight.w500),
                          //   ),
                          //   onTap: () {
                          //     _navigationService.pop();
                          //     _navigationService.navigateToPage(
                          //         SolicitudTasacionView.routeName);
                          //   },
                          // ),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text(
                              'Perfil',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService
                                  .navigateToPage(PerfilView.routeName);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.alarm),
                            title: const Text(
                              'Alarmas',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService
                                  .navigateToPage(AlarmasView.routeName);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.article_outlined),
                            title: const Text(
                              'Notas',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService
                                  .navigateToPage(NotasView.routeName);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.person_pin),
                            title: const Text(
                              'Acciones Solicitud',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService.navigateToPage(
                                  AccionesSolicitudView.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Salir',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            leading: const Icon(Icons.exit_to_app),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService.navigateToPageAndRemoveUntil(
                                  LoginView.routeName);
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "© 2022 CONFISA - App v1.0",
                style: TextStyle(
                    color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
