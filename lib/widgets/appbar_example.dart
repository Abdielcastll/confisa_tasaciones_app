import 'package:flutter/material.dart';

import '../constants.dart';

class AppbarExample extends StatelessWidget implements PreferredSizeWidget {
  const AppbarExample({
    Key? key,
    required this.titulo,
  }) : super(key: key);
  final String titulo;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
              )),
          const SizedBox(
            width: 10,
          ),
          Text(titulo, style: appTitulo),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.find_in_page)),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_active)),
            Positioned(
              top: 15,
              left: 6,
              child: Container(
                child: const Text(
                  "5",
                  style: TextStyle(fontSize: 12),
                ),
                alignment: AlignmentDirectional.center,
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
