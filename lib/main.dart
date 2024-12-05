import 'package:agape/admin/home.dart';
import 'package:agape/admin/screens/bottom_nav.dart';
import 'package:agape/admin/screens/file_export.dart';
import 'package:agape/admin/screens/form_screen.dart';
import 'package:agape/auth/screens/forgot_password.dart';
import 'package:agape/auth/screens/login_screen.dart';
import 'package:agape/common/record_details.dart';
import 'package:agape/common/record_list.dart';
import 'package:agape/common/register_record.dart';
import 'package:agape/common/splash.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: RecordDetailsPage(),
      
    );
  }
}
