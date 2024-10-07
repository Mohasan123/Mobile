import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
                child: const Text(
                  'A  simple text',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  log('Button Pressed');
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
