import 'package:agape/admin/screens/statics_screens.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/widgets/CustomTextFormField.dart';
import 'package:agape/widgets/button.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/loading_animation_widget.dart';

class SubAdminForm extends ConsumerStatefulWidget {
  @override
  _SubAdminFormState createState() => _SubAdminFormState();
}

class _SubAdminFormState extends ConsumerState<SubAdminForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _middeleName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  String? _selectedGender;
  String? _selectedRole;
  bool _isLoading = false;

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final firstName = _firstName.text.trim();
      final middleName = _middeleName.text.trim();
      final lastName = _lastName.text.trim();
      final email = _email.text.trim();
      final phone = _phone.text.trim();
      final gender = _selectedGender;
      final role = _selectedRole;

      try {
        await ref.read(authControllerProvider).register(
            firstName, middleName, lastName, email, phone, gender, role);

        setState(() {
          _isLoading = false;
          _formKey.currentState!.reset();
          _firstName.clear();
          _middeleName.clear();
          _lastName.clear();
          _email.clear();
          _phone.clear();
          _selectedGender = null;
          _selectedRole = null;
        });

        showCustomSnackBar(
          context,
          title: 'Success',
          message: 'Registered successfully and Verification email sent',
          type: AnimatedSnackBarType.success,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        showCustomSnackBar(
          context,
          title: 'Error',
          message: e.toString(),
          type: AnimatedSnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Admin'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // First Name
                        CustomTextFormField(
                          controller: _firstName,
                          keyboardType: TextInputType.text,
                          labelText: 'First Name',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Middle Name
                        CustomTextFormField(
                          controller: _middeleName,
                          keyboardType: TextInputType.text,
                          labelText: "Middle Name",
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your middle name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Last Name
                        CustomTextFormField(
                          controller: _lastName,
                          keyboardType: TextInputType.text,
                          labelText: "Last Name",
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Gender
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Gender",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: "male",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                    const Text("Male"),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: "female",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                    const Text("Female"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Phone Number
                        CustomTextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          labelText: "Phone Number",
                          prefixIcon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        CustomTextFormField(
                          controller: _email,
                          labelText: "Email",
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Role",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: "admin",
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value;
                                        });
                                      },
                                    ),
                                    const Text("Admin"),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: "female",
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value;
                                        });
                                      },
                                    ),
                                    const Text("Sub Admin"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        MyButtons(onTap: register, text: "Submit"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingIndicatorWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
