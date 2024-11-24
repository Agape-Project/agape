import 'package:agape/common/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const test());
}


class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}