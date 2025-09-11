import 'package:flutter/material.dart';
import "../widgets/ui/ui_scaffold.dart";
import "../widgets/exercise_tile.dart";
import "../widgets/saved_exercises_list.dart";
import "../pages/search_form.dart";
import "../models/exercise.dart";
import "../exercises_db_handler.dart";

class SavedExercisesPage extends StatefulWidget {
  const SavedExercisesPage({super.key});

  @override
  State<SavedExercisesPage> createState() => _SavedExercisesPageState();
}

class _SavedExercisesPageState extends State<SavedExercisesPage> {
  @override
  void initState() {
    super.initState();
  }

  // REMOVE EXERCISE FROM SAVED LIST
  void removeSavedExercise(BuildContext context, Exercise data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' removed."));
      SavedExercisesDB.removeFromSavedExercises(data); // remove
      SavedExercisesDB.updateSavedExercises();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }

  Widget _buildEmptyMsg(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saved exercises", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(Icons.save, size: 60),
          SizedBox(height: 10),
          Text("All of your saved exercises will show here.\nTo find a new exercise,\nclick the search button on the top-right.", textAlign: TextAlign.center)
        ],
      )
    );
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
      body: 
        SavedExercisesDB.getSavedExercises().isEmpty
        ? _buildEmptyMsg(context) 
        : _buildSavedList(context),
      appBarActions: [
        IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () async {
          // SEARCH FORM
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SearchForm();
          }));

          setState(() { });
        })
      ]
    );;
  }
}