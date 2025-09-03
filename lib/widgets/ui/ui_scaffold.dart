import 'package:flutter/material.dart';

class UIScaffold extends StatelessWidget {
  String appBarTitle;
  Widget body;
  List<Widget>? actions;
  Widget? floatingActionButton;

  UIScaffold({ super.key, required this.appBarTitle, required this.body, this.actions, this.floatingActionButton });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400, 
        title: Text(appBarTitle, style: TextStyle(
          fontFamily: "Overused Grotesk Medium"
        )),
        actions: actions ?? []
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}