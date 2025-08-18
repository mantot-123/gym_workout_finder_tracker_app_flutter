import 'package:flutter/material.dart';
import "../widgets/ui/ui_scaffold.dart";
import "../widgets/workout_tile.dart";
import "../models/workout.dart";
import "../db.dart";

class SavedWorkoutsPage extends StatefulWidget {
  const SavedWorkoutsPage({super.key});

  @override
  State<SavedWorkoutsPage> createState() => _SavedWorkoutsPageState();
}

class _SavedWorkoutsPageState extends State<SavedWorkoutsPage> {
  @override
  void initState() {
    super.initState();
  }

  // REMOVE EXERCISE FROM SAVED LIST
  void removeSavedWorkout(BuildContext context, Map<dynamic, dynamic> data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data["name"]}' removed."));
      WorkoutsDB.removeFromSavedWorkouts(data); // remove
      WorkoutsDB.updateSavedWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Saved workouts",
      scaffoldBody: 
        WorkoutsDB.getSavedWorkouts().isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Saved workouts", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.save, size: 60),
                SizedBox(height: 10),
                Text("All of your saved workouts will show here.", textAlign: TextAlign.center)
              ],
            )
          ) 
        : Column(
            children:
              [
                Expanded(
                  child: ListView.builder(
                    itemCount: WorkoutsDB.getSavedWorkouts().length,
                    itemBuilder: (context, index) {
                      return WorkoutTile(
                        data: WorkoutsDB.getSavedWorkouts()[index].toMap(), 
                        actionBtnType: 1,
                        actionBtnOnPressed: () {
                          removeSavedWorkout(context, WorkoutsDB.getSavedWorkouts()[index].toMap());
                        },
                      );
                    }
                  ),
                )
              ]
          )
    );;
  }
}