import 'dart:developer';

import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; //. 0-9
  String num2 = ""; // . 0-9
  String operand = ""; // . (* - + /)
  String result = "0";

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  reverse: true, // Ensures the text stays at the bottom
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$num1$operand$num2".isEmpty
                            ? "0"
                            : "$num1$operand$num2",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        result,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Buttons area
            Container(
              child: Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: screen.width * 0.25,
                        height: screen.height * 0.1, // Adjust height as needed
                        child: buildButton(value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          onBtnTap(value);
        },
        child: Center(child: Text(value)),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercent();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void onTapBtnRslt() {}

  void calculate() {
    try {
      final expression = "$num1$operand$num2";
      final tokens = tokenize(expression);
      final rpn = toRPN(tokens);
      final resultValue = evaluateRPN(rpn);

      setState(() {
        result = "$resultValue";
        if (result.endsWith(".0")) {
          result = result.substring(0, result.length - 2);
        }
        num1 = result;
        operand = "";
        num2 = "";
      });
    } catch (e) {
      setState(() {
        result = "Error";
        num1 = "";
        operand = "";
        num2 = "";
      });
    }
  }

  void convertToPercent() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    try {
      final number = double.parse(num1);
      setState(() {
        num1 = "${(number / 100)}";
        operand = "";
        num2 = "";
      });
    } catch (e) {
      log("error Converting to double:  $e");
    }
  }

  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
      result = "0";
    });
  }

  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      appendOperator(value);
    } else {
      appendNumber(value);
    }
  }

  void appendNumber(String value) {
    if (num1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

  void appendOperator(String value) {
    if (operand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }
    operand = value;
    setState(() {});
  }

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

double evaluateRPN(List<String> tokens) {
  final stack = <double>[];

  for (final token in tokens) {
    if (double.tryParse(token) != null) {
      stack.add(double.parse(token));
    } else {
      if (stack.length < 2) {
        throw RangeError('Not enough operands for the operator $token');
      }
      final b = stack.removeLast();
      final a = stack.removeLast();
      switch (token) {
        case '+':
          stack.add(a + b);
          break;
        case '-':
          stack.add(a - b);
          break;
        case '*':
          stack.add(a * b);
          break;
        case '/':
          stack.add(a / b);
          break;
        default:
          throw ArgumentError('Unsupported operator $token');
      }
    }
  }

  if (stack.length != 1) {
    throw StateError('The user input has too many values');
  }

  return stack.last;
}

List<String> toRPN(List<String> tokens) {
  final output = <String>[];
  final operators = <String>[];

  final precedence = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
  };

  for (final token in tokens) {
    if (double.tryParse(token) != null) {
      output.add(token);
    } else if (token == '(') {
      operators.add(token);
    } else if (token == ')') {
      while (operators.isNotEmpty && operators.last != '(') {
        output.add(operators.removeLast());
      }
      operators.removeLast();
    } else {
      while (operators.isNotEmpty &&
          precedence[operators.last] != null &&
          precedence[operators.last]! >= precedence[token]!) {
        output.add(operators.removeLast());
      }
      operators.add(token);
    }
  }

  while (operators.isNotEmpty) {
    output.add(operators.removeLast());
  }

  return output;
}

List<String> tokenize(String expression) {
  final tokens = <String>[];
  final buffer = StringBuffer();
  bool lastWasOperator = true;

  for (var i = 0; i < expression.length; i++) {
    final char = expression[i];

    if (char == ' ') continue;

    if (char == '+' ||
        char == '-' ||
        char == '*' ||
        char == '/' ||
        char == '(' ||
        char == ')') {
      if (buffer.isNotEmpty) {
        tokens.add(buffer.toString());
        buffer.clear();
      }
      if (char == '-' && lastWasOperator) {
        buffer.write(char);
      } else {
        tokens.add(char);
        lastWasOperator = char != ')';
      }
    } else {
      buffer.write(char);
      lastWasOperator = false;
    }
  }

  if (buffer.isNotEmpty) {
    tokens.add(buffer.toString());
  }

  return tokens;
}
