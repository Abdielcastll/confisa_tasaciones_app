import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const AppTextField({
    required this.text,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .80,
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          filled: true,
          isDense: true,
          fillColor: Colors.white,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
