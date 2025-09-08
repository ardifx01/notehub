import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';

Widget customTextfield({
  required String hintText,
  required TextEditingController controller,
  IconButton? suffixIcon,
  bool obscureText = false,
  ValueChanged<String>? onChanged, 
}) {
  return SizedBox(
    height: 40,
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textFieldHintColor, fontSize: 14),
        filled: true,
        fillColor: AppColors.textFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: AppColors.textFieldHintColor,
      ),
      onChanged: onChanged, 
    ),
  );
}
