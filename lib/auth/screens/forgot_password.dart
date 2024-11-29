import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/auth/screens/login_screen.dart';
import 'package:agape/auth/screens/otp_screen.dart';
import 'package:agape/widgets/CustomTextFormField.dart';
import 'package:agape/widgets/button.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void sendPasswordResetLink() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      ref.read(authControllerProvider).sendPasswordResetEmail(
            context: context,
            email: email,
          );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(email: email),
        ),
      );
    } else {
      showCustomSnackBar(
          context,
          title: 'Error',
          message: 'Please Enter valid Email address',
          type: AnimatedSnackBarType.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    double maxWidth = 400.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
         backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Align(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey, // Attach the form key here
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Enter your Email address below and we will send you a code to reset it",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 40),
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
                      MyButtons(
                        onTap: sendPasswordResetLink,
                        text: "Send",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
