import 'package:diary_app/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:slider_button/slider_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          const SizedBox(height: 200.0),
          Lottie.asset('assets/animations/Animation_planing.json'),
          RichText(
            text: TextSpan(
              text: 'Welcome to your Diary',
              style: GoogleFonts.shadowsIntoLight(
                textStyle: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 25.0),
          Center(
            child: SliderButton(
              action: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                return null;
              },
              label: const Text(
                "Slide to Login",
                style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
              icon: const Icon(
                Icons.arrow_right,
                color: Color(0xff4a4a4a),
                size: 50,
              ),
              width: 250,
              backgroundColor: const Color(0xff9ABF80),
              buttonColor: const Color(0x0fffffff),
            ),
          ),
        ],
      ),
    );
  }
}
