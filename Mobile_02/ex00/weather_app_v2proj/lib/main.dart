import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
          backgroundColor: Color.fromARGB(198, 110, 111, 183),
        ),
        primarySwatch: Colors.lightBlue,
      ),
      home: const HomePage(),
    );
  }
}
