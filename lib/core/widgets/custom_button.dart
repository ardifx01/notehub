import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';

Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color? color,
  double? width,
  Gradient? gradient,
}) {
  return SizedBox(
    height: 45,
    width: width ?? double.infinity,
    child: Container(
      decoration: BoxDecoration(
        color: gradient == null ? color ?? AppColors.buttonColor3 : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.tertiaryTextColor, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
