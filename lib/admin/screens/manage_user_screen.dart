import 'package:agape/admin/screens/form_screen.dart';
import 'package:agape/admin/screens/subadmin_details.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/utils/colors.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageSubAdmin extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Sub admin'),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for sub admin',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    prefixIcon: const Icon(Icons.search, color: primaryColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: authController.getUsers(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SubAdminForm(
                      userId: null,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
    String userId = user['id'];
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
              children: [
                Text(
                  "${user['first_name']} ${user['last_name']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Text(
                  user['role'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(authControllerProvider).blockOrUnblockUser(userId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Block',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubadminDetails(userId: userId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 14, color: Colors.black),
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
