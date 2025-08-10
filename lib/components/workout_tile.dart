import 'package:flutter/material.dart';
import "../pages/workout_info.dart";

class WorkoutTile extends StatelessWidget {
  Map<String, dynamic> data;
  WorkoutTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () { 
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WorkoutInfoPage(data: this.data);
        })); 
      },
      title: Text(data["name"]), 
      subtitle: Text(data["description"]),
      leading: Icon(Icons.fitness_center)
    );;
  }
}