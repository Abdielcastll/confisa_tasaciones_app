import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    required this.label,
    this.hint,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.keyboardType,
    this.validator,
    Key? key,
  }) : super(key: key);
  final String? initialValue;
  final String label;
  final String? hint;
  final bool enabled;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}

class BaseTextFieldNoEdit extends StatelessWidget {
  const BaseTextFieldNoEdit({
    required this.label,
    this.initialValue,
    Key? key,
  }) : super(key: key);
  final String? initialValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Divider(color: AppColors.brownDark),
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
