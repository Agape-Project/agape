import 'package:agape/admin/screens/statics_screens.dart';
import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/auth/screens/forgot_password.dart';
import 'package:agape/widgets/button.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:agape/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

void login() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      final response =
          await ref.read(authControllerProvider).login(email, password);
      showSnackBar(context, response);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardStats(),
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  } else {
    showSnackBar(context, "Please enter your email and password");
  }
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agape Mobility Ethiopia"), 
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, // 5% of screen width
              vertical: size.height * 0.03, // 3% of screen height
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Limit width on larger screens
                ),
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
                    TextFieldInput(
                      textEditingController: _emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "Password",
                      isPass: true,
                      icon: Icons.lock,
                      textInputType: TextInputType.text,
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
                            color: Colors.blue,
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
    );
  }
}