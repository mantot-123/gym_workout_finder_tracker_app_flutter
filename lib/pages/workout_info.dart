import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../helpers/list_to_string.dart";
import "../api.dart";

class WorkoutInfoPage extends StatefulWidget {
  Map<String, dynamic> data;
  WorkoutInfoPage({super.key, required this.data});

  @override
  State<WorkoutInfoPage> createState() => _WorkoutInfoPageState();
}


class _WorkoutInfoPageState extends State<WorkoutInfoPage> {
  late Future<Uint8List?> image;

  @override
  void initState() {
    super.initState();
    Search search = Search();
    image = search.getImage(widget.data["id"]); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(backgroundColor: Colors.lightGreen.shade400, title: Text("Exercise details")),
      body: FutureBuilder(
        future: image, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.lightGreen.shade900, size: 100
              )
            );
          } 
          else if(snapshot.hasError) {
            return Center(child: Text("Unable to get workout data. Please try again later."));
          }
          else if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Unable to get workout data. Please try again later."));
          }
          else {
            // print(snapshot.data);
            return Column(children:[
              Image.memory(snapshot.data!), // NULL AWARE OPERATOR - SETS A DEFAULT VALUE TO THE VARIABLE WHEN IT SEES A NULL
              Expanded(child: workoutInfoPane(widget.data))
            ]);
          }
        }
      ) 
    );;
  }
}

// DISPLAY WORKOUT INFORMATION IN THIS WIDGET
Container workoutInfoPane(Map<String, dynamic> data) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: ListView(
      children: [
        Text("ID:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["id"]),
        SizedBox(height: 10),
    
        Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["name"]),
        SizedBox(height: 10),

        Text("Difficulty:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["difficulty"]),
        SizedBox(height: 10),
        
        Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["description"]),
        SizedBox(height: 10),
    
        Text("Target muscles worked:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["target"]),
        SizedBox(height: 15),
    
        Text("Secondary muscles:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(listToString(data["secondaryMuscles"])),
        SizedBox(height: 15),
    
        Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(data["description"]),
        SizedBox(height: 15),
    
        Text("Instructions:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(toNumberedListString(data["instructions"])),
        SizedBox(height: 15),
      ],
    ),
  );
}