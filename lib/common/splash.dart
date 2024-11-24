import 'package:agape/admin/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Enable immersive full-screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to AdminHome after 5 seconds
    Future.delayed(const Duration(seconds: 45), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    });
  }

  @override
  void dispose() {
    // Restore system UI overlays when the widget is disposed
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255,248,244,244)
              ),
            ),

          // Main Content (Image and Motto)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6, // Scaled width
                ),
                const SizedBox(height: 20), // Add spacing between logo and text

                // Motto
                Text(
                  "No More Crawling on the Floor",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 63, 61, 61),
                    fontStyle: FontStyle.italic,
                    fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
