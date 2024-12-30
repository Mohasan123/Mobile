import 'package:flutter/material.dart';
import 'package:medium_weather_app/ex02/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

