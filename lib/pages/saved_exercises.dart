import 'package:flutter/material.dart';
import "../widgets/ui/ui_scaffold.dart";
import "../widgets/exercise_tile.dart";
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

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Exercises",
      body: 
        SavedExercisesDB.getSavedExercises().isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Saved exercises", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.save, size: 60),
                SizedBox(height: 10),
                Text("All of your saved exercises will show here.\nTo find a new exercise, click the search button on the top-right.", textAlign: TextAlign.center)
              ],
            )
          ) 
        : Column(
            children:
              [
                Expanded(
                  child: ListView.builder(
                    itemCount: SavedExercisesDB.getSavedExercises().length,
                    itemBuilder: (context, index) {
                      return ExerciseTile(
                        data: SavedExercisesDB.getSavedExercises()[index], 
                        actionBtnType: 1,
                        actionBtnOnPressed: () {
                          removeSavedExercise(context, SavedExercisesDB.getSavedExercises()[index]);
                        },
                      );
                    }
                  ),
                )
              ],
          ),
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