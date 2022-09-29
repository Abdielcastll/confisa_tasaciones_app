import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../theme/theme.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    required this.label,
    this.hint,
    this.initialValue,
    this.enabled = true,
    this.maxLength = 20,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.controller,
    this.inputFormatters,
    Key? key,
  }) : super(key: key);
  final String? initialValue;
  final String label;
  final String? hint;
  final int maxLength;
  final bool enabled;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      enabled: enabled,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: AppColors.brownDark),
        labelText: label,
        hintText: hint,
      ),
      validator: validator,
    );
  }
}

class BaseTextFieldNoEdit extends StatelessWidget {
  const BaseTextFieldNoEdit({
    required this.label,
    this.initialValue,
    this.border = true,
    Key? key,
  }) : super(key: key);
  final String? initialValue;
  final String label;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.brownDark, fontSize: 13),
          ),
          const SizedBox(height: 3),
          Text(
            initialValue ?? '',
            style: const TextStyle(fontSize: 15),
          ),
          if (border) const Divider(color: AppColors.brownDark, thickness: 1.2),
        ],
      ),
    );

    /*TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: AppColors.brownDark),
        labelText: label,
        hintText: hint,
      ),
      validator: validator,
    );*/
  }
}
