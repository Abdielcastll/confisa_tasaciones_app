import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? iconButton;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? colorError;
  const AppTextField({
    required this.text,
    required this.controller,
    this.validator,
    this.colorError,
    this.obscureText,
    this.iconButton,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.black,
            ),
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            /*const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            */
            // filled: true,
            isDense: true,
            errorStyle: TextStyle(color: colorError),
            fillColor: Colors.white,
            hintText: "Ingrese $text",
            label: Text(text),
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
