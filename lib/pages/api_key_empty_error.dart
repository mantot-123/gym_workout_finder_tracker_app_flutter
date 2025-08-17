import 'package:flutter/material.dart';
import "../widgets/ui/ui_scaffold.dart";

class APIKeyEmptyErrorPage extends StatelessWidget {
  APIKeyEmptyErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Error",
      scaffoldBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.error, size: 60),
            SizedBox(height: 10),
            Text("An API key has not been set for this app. Please set one and then try again.", textAlign: TextAlign.center)
          ],
        )
      ) 
    );
  }
}