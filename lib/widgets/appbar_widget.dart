import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    Key? key,
    required this.titulo,
    required this.textSize,
  }) : super(key: key);
  final String titulo;
  final double textSize;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.normal,
        ),
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
          width: 8,
        ),
      ],
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
