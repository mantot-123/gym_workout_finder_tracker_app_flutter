import 'package:flutter/material.dart';

class UIScaffold extends StatelessWidget {
  String appBarTitle;
  Widget scaffoldBody;
  UIScaffold({super.key, required this.appBarTitle, required this.scaffoldBody });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400, 
        title: Text(appBarTitle, style: TextStyle(
          fontFamily: "Overused Grotesk Medium"
        ))),
      body: scaffoldBody
    );
  }
}