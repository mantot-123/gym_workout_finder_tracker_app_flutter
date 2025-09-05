import 'package:flutter/material.dart';

class UIInputBox extends StatelessWidget {
  TextEditingController controller;
  String label;
  String value;
  int inputType; // 0 = text, 1 = integer
  UIInputBox({super.key, required this.label, required this.controller, this.value = "", this.inputType = 0});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Text(label)
      ),
      controller: controller,
      keyboardType: inputType == 1 ? TextInputType.number : TextInputType.text,
    );
  }
}