import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

class AppObscureTextIcon extends StatelessWidget {
  const AppObscureTextIcon({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: AppColors.brownDark,
      ),
      onPressed: onPressed,
    );
  }
}
