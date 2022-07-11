import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final IconData icon;
  const CircleIconButton(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )));
  }
}
