import 'package:agape/auth/controllers/auth_controller.dart';
import 'package:agape/auth/screens/password_reset_screen.dart';
import 'package:agape/widgets/button.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agape/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  static const routeName = '/otp-verification';
  final String email;

  const OtpVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void verifyOtp() async {
    final otp = _otpController.text;
    if (otp.length == 6) {
      final authController = ref.read(authControllerProvider);

      await authController.verifyOTP(widget.email, otp);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(email: widget.email),
        ),
      );
    } else {
          showCustomSnackBar(
          context,
          title: 'Error',
          message: 'Insert Correct otp ',
          type: AnimatedSnackBarType.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      appBar: AppBar(
        title: const Text("OTP Verification"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      ),
      body: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(
            maxWidth: 400, 
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Text(
                "Enter the OTP sent to ${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 6, 
                obscureText: false,
                keyboardType: TextInputType.number,
                autoFocus: true,
                controller: _otpController,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                boxShadows: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                onChanged: (value) {
                  // Optional: Handle changes in OTP value
                },
                beforeTextPaste: (text) {
                  // Allow pasting of text
                  return true;
                },
              ),
              const SizedBox(height: 30),
              MyButtons(
                onTap: verifyOtp,
                text: "Verify OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
