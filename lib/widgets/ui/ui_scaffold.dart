import 'package:flutter/material.dart';

class UIScaffold extends StatelessWidget {
  String appBarTitle;
  Widget body;
  List<Widget>? appBarActions;
  Widget? floatingActionButton;

  UIScaffold({ super.key, required this.appBarTitle, required this.body, this.appBarActions, this.floatingActionButton });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50, 
        title: Text(appBarTitle, style: TextStyle(
          fontFamily: "Overused Grotesk Medium"
        )),
        actions: appBarActions ?? []
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}