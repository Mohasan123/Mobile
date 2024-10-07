import 'package:flutter/material.dart';

import 'calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => Calculator();
}

class Calculator extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calclutor",
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}
