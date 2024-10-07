import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:moar_button/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; //. 0-9
  String num2 = ""; // . 0-9
  String operand = ""; // . (* - + /)

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16.0),
                child: const Column(
                  children: [
                    Text(
                      "0",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ],
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Flexible(
                    child: Wrap(
                      children: Btn.buttonValues
                          .map(
                            (value) => SizedBox(
                              width: screen.width * 0.25,
                              height: screen.height * 0.075,
                              child: buildButton(value),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Flexible(
                    child: Wrap(
                      children: Btn.buttonValues
                          .map(
                            (value) => SizedBox(
                              width: screen.width * 0.25,
                              height: screen.height * 0.0855,
                              child: buildButton(value),
                            ),
                          )
                          .toList(),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  //
  Widget buildButton(value) {
    return Material(
      color: getBtnColor(value),
      clipBehavior: Clip.hardEdge,
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.vertical(),
      ),
      child: InkWell(
        onTap: () {
          log('Button Presserd: $value');
        },
        child: Center(child: Text(value)),
      ),
    );
  }

//######
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.subtract,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
