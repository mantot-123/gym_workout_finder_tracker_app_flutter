import 'package:flutter/material.dart';
import "../components/button.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(backgroundColor: Colors.lightGreen.shade400, title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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