import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../components/ui_scaffold.dart";
import "../components/workout_info_pane.dart";
import "../helpers/list_to_string.dart";
import "../api.dart";

class WorkoutInfoPage extends StatefulWidget {
  Map<dynamic, dynamic> data;
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
    return UIScaffold(
      appBarTitle: "Exercise details",
      scaffoldBody: Column(
        children: [
          FutureBuilder(
            future: image, 
            builder: (context, snapshot) {
              try {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.lightGreen.shade900, size: 60
                  );
                } 
                else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Placeholder(child: Text("Sorry, there is currently no image data available for this exercise."));
                }
                else {
                  return Image.memory(snapshot.data!); // NULL AWARE OPERATOR -  ONLY THROWS A RUNTIME ERROR WHEN IT SEES A NULL
                }
              } catch(ex) {
                return Placeholder(child: Text("An error has occurred while trying to get image data for the exercise. Please try again later."));
              }
            }
          ),
          Expanded(child: workoutInfoPane(widget.data))
        ],
      ) 
    );;
  }
}