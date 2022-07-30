import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

Widget buscador({
  required void Function(String)? onChanged,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.brownDark,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: text,
        hintStyle:
            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
        // suffixIcon: const Icon(
        //   AppIcons.search,
        //   color: AppColors.brownDark,
        // )
      ),
    ),
  );
}
