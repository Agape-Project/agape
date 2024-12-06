import 'package:agape/admin/screens/blocked_admins.dart';
import 'package:agape/admin/screens/manage_user_screen.dart';
import 'package:agape/admin/screens/profile_screen.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/auth/screens/login_screen.dart';
import 'package:agape/utils/colors.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      backgroundColor: secondaryColor,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSettingCard(
                    title: 'Manage Role',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageSubAdmin()),
                      );
                    },
                  ),
                  _buildSettingCard(
                    title: 'Profile Management',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                   _buildSettingCard(
                    title: 'BLocked Admins',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BlockedAdmins()),
                      );
                    },
                  ),
                  _buildSettingCard(
                    title: 'Logout',
                    onTap: () async {
                      final response =
                          await ref.read(authControllerProvider).logout();

                      showCustomSnackBar(
                        context,
                        title: 'Logout',
                        message: response,
                        type: AnimatedSnackBarType.success,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
