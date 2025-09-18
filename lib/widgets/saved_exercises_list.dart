import 'package:flutter/material.dart';
import "exercise_tile.dart";
import "../exercises_db_handler.dart";

class SavedExercisesList extends StatefulWidget {
  final int actionBtnType;
  final Function actionBtnOnPressed;
  const SavedExercisesList({super.key, required this.actionBtnType, required this.actionBtnOnPressed});

  @override
  State<SavedExercisesList> createState() => _SavedExercisesListState();
}

class _SavedExercisesListState extends State<SavedExercisesList> {
  @override
  Widget build(BuildContext context) {
    return SavedExercisesDB.getSavedExercises().isNotEmpty
    ? ListView.builder(
      itemCount: SavedExercisesDB.getSavedExercises().length,
      itemBuilder: (context, index) {
        return ExerciseTile(
          data: SavedExercisesDB.getSavedExercises()[index], 
          actionBtnType: widget.actionBtnType,
          actionBtnOnPressed: () {
            widget.actionBtnOnPressed(SavedExercisesDB.getSavedExercises()[index]);
          }
        );
      }
    )
    : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saved exercises", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(Icons.save, size: 60),
          SizedBox(height: 10),
          Text("You have not saved any exercises yet.\nTry searching some exercises to get started.", textAlign: TextAlign.center)
        ],
      )
    );
  }
}