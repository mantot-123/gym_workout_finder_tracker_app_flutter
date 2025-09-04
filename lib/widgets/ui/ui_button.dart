import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  UIButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightGreen.shade200),
        elevation: WidgetStatePropertyAll(0.0),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)))
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.black87)),
    );
  }
}