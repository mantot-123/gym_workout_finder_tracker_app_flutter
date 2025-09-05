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
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: appBarActions ?? []
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}