import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  UIButton({super.key, required this.label, required this.onPressedAction});
  String label;
  VoidCallback onPressedAction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen.shade700)),
      onPressed: onPressedAction,
      child: Text(label, style: TextStyle(color: Colors.white))
    );
  }
}