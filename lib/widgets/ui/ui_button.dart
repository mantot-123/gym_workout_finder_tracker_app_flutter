import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  UIButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}