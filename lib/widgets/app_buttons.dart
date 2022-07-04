import 'package:flutter/material.dart';

class AppButtonLogin extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  const AppButtonLogin({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: MediaQuery.of(context).size.width * .60,
      child: Text(text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          )),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}