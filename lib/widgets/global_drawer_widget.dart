import 'package:flutter/material.dart';
import 'package:tasaciones_app/core/authentication_client.dart';
import 'package:tasaciones_app/theme/theme.dart';
import 'package:tasaciones_app/utils/drawer_menu.dart';
import 'package:tasaciones_app/views/Perfil_de_usuario/perfil_view.dart';
import 'package:tasaciones_app/views/entidades_seguridad/entidades_seguridad_view.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';
import '../views/auth/login/login_view.dart';

class GlobalDrawerDartDesktop extends StatelessWidget {
  GlobalDrawerDartDesktop({Key? key}) : super(key: key);
  final _navigationService = locator<NavigatorService>();
  final _authenticationClient = locator<AuthenticationClient>();

  /* Falta llevar los textstyle a un archivo de constantes para la reutilizacion y
  crear el modal de rol claims y eliminar el ejemplo de aca*/

  @override
  Widget build(BuildContext context) {
    var dataUser = _authenticationClient.loadSession;
    Size size = MediaQuery.of(context).size;

    /* Ejemplo para ver opciones, esto deberia tomarse de un provider al igual que los datos del usuario*/
    List<Rol> list = <Rol>[
      Rol(
          id: "1",
          descripcion: "Configuracion de Seguridad",
          path: "entidades_seguridad"),
      // Rol(id: "3", descripcion: "Buscar Usuarios", path: ""),
    ];

    return Drawer(
      child: Container(
        color: AppColors.cream,
        child: Column(
          children: [
            /* Header de informacion de usuario */
            Container(
              decoration: const BoxDecoration(
                color: AppColors.gold,
              ),
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
                    padding: const EdgeInsets.only(
                        top: 15, left: 8, right: 8, bottom: 8),
                    child: Column(
                        /* Recorrido de la lista de role claims que devuelve las opciones del menu */
                        children: [
                          ...menu(
                            Menu(
                              modulos: [
                                Modulo(opciones: <MenuOpcion>[
                                  MenuOpcion(
                                      opcion: "Acciones",
                                      matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Modulos",
                                      matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Recursos",
                                      matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Permisos",
                                      matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Endpoints",
                                      matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Roles", matenimiento: "General"),
                                  MenuOpcion(
                                      opcion: "Usuarios",
                                      matenimiento: "General"),
                                ], nombre: "Seguridad")
                              ],
                            ),
                          ),
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
                          /*ListTile(
                            title: const Text(
                              'Vieja seguridad',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService.navigateToPage(
                                  EntidadesSeguridadView.routeName);
                            },
                          ),*/
                          ListTile(
                            title: const Text(
                              'Salir',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            leading: const Icon(Icons.exit_to_app),
                            onTap: () {
                              _navigationService.pop();
                              _navigationService
                                  .navigateToPage(LoginView.routeName);
                            },
                          ),
                        ]),
                  )
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

/* Clase ejemplo del model de rol */
class Rol {
  final String id, descripcion, path;

  Rol({required this.id, required this.descripcion, required this.path});
}
