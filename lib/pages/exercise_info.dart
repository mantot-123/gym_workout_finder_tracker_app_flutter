import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../models/exercise.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../widgets/exercise_info_pane.dart";
import "../helpers/list_to_string.dart";
import "../api.dart";

class ExerciseInfoPage extends StatefulWidget {
  Exercise data;
  ExerciseInfoPage({super.key, required this.data});

  @override
  State<ExerciseInfoPage> createState() => _ExerciseInfoPageState();
}


class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  late Future<Uint8List?> image;

  @override
  void initState() {
    super.initState();
    ExerciseSearch search = ExerciseSearch();
    image = search.getImage(widget.data.id); 
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Exercise details",
      body: Column(
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
          Expanded(child: exerciseInfoPane(widget.data))
        ],
      ) 
    );;
  }
}