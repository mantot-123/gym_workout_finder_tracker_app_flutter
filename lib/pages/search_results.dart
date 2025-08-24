import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../widgets/workout_tile.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../models/workout.dart";
import "../saved_workouts_db.dart";
import "../api.dart";

class SearchResultsPage extends StatefulWidget {
  String type;
  String query;
  SearchResultsPage({super.key, required this.type, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<dynamic> results;

  @override
  void initState() {
    super.initState();
    WorkoutSearch search = WorkoutSearch();
    results = search.getData(widget.type, widget.query);
  }


  // ADD EXERCISE TO SAVED LIST
  void saveWorkout(BuildContext context, Workout data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' successfully saved."));
      SavedWorkoutsDB.addToSavedWorkouts(data); // add
      SavedWorkoutsDB.updateSavedWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }


  // REMOVE EXERCISE FROM SAVED LIST
  void removeSavedWorkout(BuildContext context, Workout data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' removed."));
      SavedWorkoutsDB.removeFromSavedWorkouts(data); // remove
      SavedWorkoutsDB.updateSavedWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }


  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Search results for: ${widget.query}",
      scaffoldBody: FutureBuilder<dynamic>(
        future: results,
        builder: (context, snapshot) {
          try {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.lightGreen.shade900, size: 100
                )
              );
            } 
            else if(!snapshot!.hasData || snapshot.data!.isEmpty) {
              // print(snapshot.data);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No results", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Icon(Icons.search, size: 60),
                    SizedBox(height: 10),
                    Text("Sorry, we can't find any exercises based on your criteria", textAlign: TextAlign.center)
                  ],
                )
              );
            } 
            else {
              // print(snapshot.data);
              List<Workout> dataConverted = Workout.fromMapList(snapshot.data.cast<Map<dynamic, dynamic>>()).cast<Workout>();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataConverted.length,
                      itemBuilder: (context, index) {
                        // returns a workout list tile with either a delete or save button 
                        if(SavedWorkoutsDB.isWorkoutSaved(dataConverted[index].id)) {
                          return WorkoutTile(data: dataConverted[index], actionBtnType: 1, actionBtnOnPressed: () {
                            removeSavedWorkout(context, dataConverted[index]);
                          });
                        }

                        return WorkoutTile(data: dataConverted[index], actionBtnOnPressed: () {
                          saveWorkout(context, dataConverted[index]);
                        });
                      }
                    ),
                  ),
                ],
              );
            }

          } catch(ex) {
            return Center(
              child: Text("An error occurred while getting data. Check your internet connection and try again.", textAlign: TextAlign.center),
            );
          }
        }
      ),
    );
  }
}