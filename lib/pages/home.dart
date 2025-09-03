import 'package:flutter/material.dart';
import "../widgets/ui/ui_button.dart";
import "../widgets/ui/ui_scaffold.dart";
import "dart:io";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Home",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", height: 228, width: 228),
            Text("Welcome!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.fitness_center, size: 60),
            SizedBox(height: 10),
            Text("Click on 'Search' below to start finding the\nbest workout for you!", textAlign: TextAlign.center)
          ],
        )
      ) 
    );
  }
}