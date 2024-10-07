import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var currentIndex = 0;
  var textChanged = ["A simple text", "Hello Word"];
  void buttonClicked() {
    setState(() {
      if (currentIndex < textChanged.length - 1) {
        currentIndex = currentIndex + 1;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(228, 37, 65, 5),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  textChanged[currentIndex],
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  buttonClicked();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color.fromARGB(255, 232, 225, 225),
                ),
                child: const Text(
                  'Click me',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
