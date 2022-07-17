import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

class AppTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? iconButton;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const AppTextField({
    required this.text,
    required this.controller,
    this.validator,
    this.obscureText,
    this.iconButton,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * .80,
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: AppColors.brownDark,
            ),
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 50),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            filled: true,
            isDense: true,
            
            fillColor: Colors.white,
            hintText: text,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: iconButton),
        obscureText: obscureText ?? false,
      ),
    );
  }
}
