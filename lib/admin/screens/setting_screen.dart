import 'package:agape/admin/screens/manage_user_screen.dart';
import 'package:agape/admin/screens/profile_screen.dart';
import 'package:agape/utils/colors.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      backgroundColor: secondaryColor, 
      body: Align(
        alignment: Alignment.topCenter, 
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), 
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSettingCard(
                    title: 'Manage Role',
                    onTap: () {
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => ManageSubAdmin()),
                     );
                    },
                  ),
                  _buildSettingCard(
                    title: 'Profile Management',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                  _buildSettingCard(
                    title: 'Logout',
                    onTap: () {
                      // Add logout functionality
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

  Widget _buildSettingCard({required String title, required VoidCallback onTap}) {
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
