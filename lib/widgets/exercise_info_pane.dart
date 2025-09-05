import 'package:flutter/material.dart';
import "../models/exercise.dart";
import "../helpers/list_to_string.dart";

// DISPLAY EXERCISE INFORMATION IN THIS WIDGET
Container exerciseInfoPane(Exercise data) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: ListView(
      children: [
        Text("ID:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.id),
        SizedBox(height: 10),
    
        Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.name),
        SizedBox(height: 10),

        Text("Difficulty:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.difficulty),
        SizedBox(height: 10),
        
        Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.description),
        SizedBox(height: 10),
    
        Text("Target muscles worked:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.target),
        SizedBox(height: 15),
    
        Text("Secondary muscles:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(listToString(data.secondaryMuscles)),
        SizedBox(height: 15),
    
        Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data.description),
        SizedBox(height: 15),
    
        Text("Instructions:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(toNumberedListString(data.instructions)),
        SizedBox(height: 15),
      ],
    ),
  );
}