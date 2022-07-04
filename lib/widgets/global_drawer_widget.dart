import 'package:flutter/material.dart';

class GlobalDrawerDartDesktop extends StatelessWidget {
  const GlobalDrawerDartDesktop({Key? key}) : super(key: key);

  /* Falta llevar los textstyle a un archivo de constantes para la reutilizacion y
  crear el modal de rol claims y eliminar el ejemplo de aca*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    /* Ejemplo para ver opciones, esto deberia tomarse de un provider al igual que los datos del usuario*/
    List<Rol> list = <Rol>[
      Rol(id: "1", descripcion: "Visualizar Usuarios"),
      Rol(id: "3", descripcion: "Buscar Usuarios"),
    ];

    return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            /* Header de informacion de usuario */
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
                color: Color(0xFF98470A),
              ),
              height: size.height * .2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Nombre y Apellido',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'Correoejemplo@gmail.com',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white60,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Positioned(
                        right: 10,
                        bottom: 10,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            )))
                  ],
                ),
              ),
            ),
            /* Opciones del menu */
            Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 8, right: 8, bottom: 8),
                child: Column(
                  /* Recorrido de la lista de role claims que devuelve las opciones del menu */
                  children: list
                      .map((e) => ListTile(
                            title: Text(
                              e.descripcion,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {},
                          ))
                      .toList(),
                ))
          ],
        ));
  }
}

/* Clase ejemplo del model de rol */
class Rol {
  final String id, descripcion;

  Rol({required this.id, required this.descripcion});
}
