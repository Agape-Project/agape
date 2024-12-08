import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/utils/colors.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedAdmins extends ConsumerWidget {
  const BlockedAdmins({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked admins'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: authController.getBlockedUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIndicatorWidget();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No users found'),
                      );
                    } else {
                      final users = snapshot.data!;
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(context, ref, users[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
    final String userId = user['id'] ?? 'N/A';
    final String firstName = user['first_name'] ?? 'Unknown';
    final String lastName = user['last_name'] ?? '';
    final String role = user['role'] ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  role,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(authControllerProvider)
                          .blockOrUnblockUser(userId);
                      showCustomSnackBar(context,
                          title: 'Success',
                          message: 'User unblocked successfully!',
                          type: AnimatedSnackBarType.success);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('User unblocked successfully!'),
                      //     duration: Duration(seconds: 2),
                      //   ),
                      // );
                    } catch (e) {
                      showCustomSnackBar(context,
                          title: 'Error',
                          message: 'Failed to unblock user: $e',
                          type: AnimatedSnackBarType.error);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Failed to unblock user: $e'),
                      //     duration: const Duration(seconds: 2),
                      //   ),
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Unblock',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(authControllerProvider).deleteUser(userId);
                      showCustomSnackBar(context,
                          title: 'Success',
                          message: 'User deleted successfully!',
                          type: AnimatedSnackBarType.success);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('User deleted successfully!'),
                      //     duration: Duration(seconds: 2),
                      //   ),
                      // );
                    } catch (e) {
                       showCustomSnackBar(context,
                          title: 'Error',
                          message: 'Failed to delete user: $e',
                          type: AnimatedSnackBarType.error);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Failed to delete user: $e'),
                      //     duration: const Duration(seconds: 2),
                      //   ),
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
