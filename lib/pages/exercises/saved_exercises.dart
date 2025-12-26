import 'package:flutter/material.dart';
import "../../widgets/ui/ui_scaffold.dart";
import "../../widgets/exercises/saved_exercises_list.dart";
import "../search/search_form.dart";
import "../../models/exercise.dart";
import "../../database/interfaces/exercises_db_handler.dart";
import "../../services/exercises_db_service.dart";

class SavedExercisesPage extends StatefulWidget {
  const SavedExercisesPage({super.key});

  @override
  State<SavedExercisesPage> createState() => _SavedExercisesPageState();
}

class _SavedExercisesPageState extends State<SavedExercisesPage> {
  ExercisesDBHandler exercisesDB = ExercisesDBService.dbHandler;

  // REMOVE EXERCISE FROM SAVED LIST
  void removeSavedExercise(BuildContext context, Exercise data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' removed."));
      exercisesDB.deleteExercise(data); // remove
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }

  Widget _buildSavedList(BuildContext context) {
    return SavedExercisesList(
      actionBtnType: 1,
      actionBtnOnPressed: (exercise) {
        removeSavedExercise(context, exercise);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Exercises",
      body: _buildSavedList(context),
      appBarActions: [
        IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () async {
          // SEARCH FORM
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SearchForm();
          }));

          setState(() { });
        })
      ]
    );
  }
}