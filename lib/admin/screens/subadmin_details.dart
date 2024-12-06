import 'package:agape/admin/screens/form_screen.dart';
import 'package:agape/admin/screens/manage_user_screen.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubadminDetails extends ConsumerWidget {
  final String userId;

  const SubadminDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);

    void deleteUser() async {
      try {
        final response =
        await ref.read(authControllerProvider).deleteUser(userId);

        Navigator.pop(context);
        showCustomSnackBar(
          context,
          title: 'Success',
          message: response,
          type: AnimatedSnackBarType.success,
        );
      } catch (e) {
        showCustomSnackBar(
          context,
          title: 'Error',
          message: e.toString(),
          type: AnimatedSnackBarType.error,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 19, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: authController.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicatorWidget();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No user data found'),
            );
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 9, 19, 58),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: MediaQuery.of(context).size.width / 2 - 60,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          user['profile_image_url'] ??
                              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        _buildDetailRow("Name",
                            "${user['first_name']} ${user['last_name']}"),
                        _buildDetailRow(
                            "Gender", user['gender'] ?? "Not specified"),
                        _buildDetailRow("Email", user['email']),
                        _buildDetailRow(
                            "Phone", user['phone_number'] ?? "Not specified"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubAdminForm(
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 64),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: deleteUser,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 24),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
