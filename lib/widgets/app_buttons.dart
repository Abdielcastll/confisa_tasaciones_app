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
      minWidth: MediaQuery.of(context).size.width * .80,
      height: 50,
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.white)),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: MediaQuery.of(context).size.width * .35,
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.white)),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
