import "package:loading_animation_widget/loading_animation_widget.dart";
import 'package:flutter/material.dart';
import "exercise_tile.dart";
import "../../database/interfaces/exercises_db_handler.dart";
import "../../database/exercises_local_db_handler.dart";
import "../../models/exercise.dart";
import "../../services/exercises_db_service.dart";

class SavedExercisesList extends StatefulWidget {
  final int actionBtnType;
  final Function actionBtnOnPressed;
  const SavedExercisesList({super.key, required this.actionBtnType, required this.actionBtnOnPressed});

  @override
  State<SavedExercisesList> createState() => _SavedExercisesListState();
}

class _SavedExercisesListState extends State<SavedExercisesList> {
  ExercisesDBHandler exercisesDB = ExercisesDBService.dbHandler;

  Widget _buildList(BuildContext context, List<Exercise> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ExerciseTile(
          data: data[index], 
          actionBtnType: widget.actionBtnType,
          actionBtnOnPressed: () {
            widget.actionBtnOnPressed(data[index]);
          }
        );
      }
    );
  }

  Widget _buildExercisesEmptyMsg(BuildContext context) {
    return Center(
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: exercisesDB.getAllExercises(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.lightGreen.shade900, size: 100
            )
          );
        } else if(!snapshot.hasData) {
          return _buildExercisesEmptyMsg(context);
        }

        return snapshot.data!.isNotEmpty
        ? _buildList(context, snapshot.data!)
        : _buildExercisesEmptyMsg(context);
      }
    );
  }
}