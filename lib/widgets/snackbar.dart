import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}



void showCustomSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  required AnimatedSnackBarType type,
  Brightness brightness = Brightness.light,
  Duration duration = const Duration(seconds: 3),
}) {
  AnimatedSnackBar.rectangle(
    title,
    message,
    type: type,
    brightness: brightness,
    duration: duration,
  ).show(context);
}