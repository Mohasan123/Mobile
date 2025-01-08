import 'package:diary_app/home_screen/home_screen.dart';
import 'package:diary_app/login_screen/login_screen.dart';
import 'package:diary_app/onBoarding_screen/onBoarding_screen.dart';
import 'package:diary_app/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
