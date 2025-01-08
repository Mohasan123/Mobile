import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200.0),
            SvgPicture.asset(
              'assets/images/signin.svg',
              height: 250,
              width: 250,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Welcome',
              style: GoogleFonts.rowdies(
                textStyle: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Login to continue to DiaryDemo',
                style: GoogleFonts.caveat(
                  textStyle: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GoogleAuthButton(
              onPressed: () {},
              text: 'Continue with Google',
              style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                iconType: AuthIconType.outlined,
                margin: EdgeInsets.all(16.0),
              ),
            ),
            GithubAuthButton(
              onPressed: () {},
              text: 'Continue with Github',
              style: const AuthButtonStyle(
                  buttonType: AuthButtonType.secondary,
                  iconType: AuthIconType.outlined,
                  padding: EdgeInsets.only(right: 32.0)),
            ),
          ],
        ),
      ),
    );
  }
}
