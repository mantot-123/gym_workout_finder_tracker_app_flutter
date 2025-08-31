import 'package:flutter/material.dart';

class UIInputBox extends StatelessWidget {
  TextEditingController inputController;
  String label;
  String value;
  int inputType; // 0 = text, 1 = integer
  UIInputBox({super.key, required this.label, required this.inputController, this.value = "", this.inputType = 0});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // decoration: InputDecoration(hintText: "Type your name here..."),
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: Colors.lightGreen.shade700),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightGreen.shade900)),
        label: Text(this.label)
      ),
      cursorColor: Colors.lightGreen.shade900,
      // cursorColor: Colors.lightGreen.shade900,
      controller: inputController,
      keyboardType: inputType == 1 ? TextInputType.number : TextInputType.text,
    );
  }
}