import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

import '../views/login/login_view_model.dart';

class AppObscureTextIcon extends StatelessWidget {
  const AppObscureTextIcon({
    Key? key,
    required this.vm,
  }) : super(key: key);

  final LoginViewModel vm;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        vm.obscurePassword ? Icons.visibility : Icons.visibility_off,
        color: AppColors.brownDark,
      ),
      onPressed: () {
        vm.changeObscure();
      },
    );
  }
}
