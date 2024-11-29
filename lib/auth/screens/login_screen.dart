import 'package:agape/admin/screens/statics_screens.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/auth/screens/forgot_password.dart';
import 'package:agape/widgets/CustomPasswordField.dart';
import 'package:agape/widgets/CustomTextFormField.dart';
import 'package:agape/widgets/button.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:agape/widgets/text_field.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; 

  void login() async {
    if (_formKey.currentState!.validate()) {
      // Show loading animation
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
  
      await ref.read(authControllerProvider).login(email, password);

        // Hide loading animation
        setState(() {
          _isLoading = false;
        });

        // Show success snackbar
        showCustomSnackBar(
          context,
          title: 'Success',
          message: 'Logged in successfully',
          type: AnimatedSnackBarType.success,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  DashboardStats(),
          ),
        );
      } catch (e) {
        // Hide loading animation
        setState(() {
          _isLoading = false;
        });

        // Show error snackbar
        showCustomSnackBar(
          context,
          title: 'Error',
          message: 'Invalid email or password',
          type: AnimatedSnackBarType.error,
        );
       
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.03,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomPasswordField(
                            controller: _passwordController,
                            labelText: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 9, 19, 58),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          MyButtons(
                            onTap: login,
                            text: "Login",
                          ),
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
      ),
    );
  }
}

