import 'package:flutter/material.dart';

class SavedWorkoutsPage extends StatefulWidget {
  const SavedWorkoutsPage({super.key});

  @override
  State<SavedWorkoutsPage> createState() => _SavedWorkoutsPageState();
}

class _SavedWorkoutsPageState extends State<SavedWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(backgroundColor: Colors.lightGreen.shade400, title: Text("Saved workouts")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Saved workouts", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.close, size: 60),
            SizedBox(height: 10),
            Text("This feature is not available yet and is still being worked on.\nPlease check back later.", textAlign: TextAlign.center)
          ],
        )
      ) 
    );;
  }
}