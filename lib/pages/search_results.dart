import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../widgets/workout_tile.dart";
import "../widgets/ui_scaffold.dart";
import "../db.dart";
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
    Search search = Search();
    results = search.getData(widget.type, widget.query);
  }


  // ADD EXERCISE TO SAVED LIST
  void saveWorkout(BuildContext context, Map<dynamic, dynamic> data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data["name"]}' successfully saved."));
      WorkoutsDB.addToSavedWorkouts(data); // add
      WorkoutsDB.updateSavedWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
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
              return Center(child: Text("No results found."));
            } 
            else {
              // print(snapshot.data);
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // returns a workout list tile with either a delete or save button 
                        if(WorkoutsDB.isWorkoutSaved(snapshot.data[index]["id"])) {
                          return WorkoutTile(data: snapshot.data[index], actionBtnType: 1, actionBtnOnPressed: () {
                            removeSavedWorkout(context, snapshot.data[index]);
                          });
                        }

                        return WorkoutTile(data: snapshot.data[index], actionBtnOnPressed: () {
                          saveWorkout(context, snapshot.data[index]);
                        });
                      }
                    ),
                  ),
                ],
              );
            }

          } catch(ex) {
            return Center(child: Text("An error occurrred while getting data. Check your internet connection and try again."));
          }
        }
      ),
    );
  }
}