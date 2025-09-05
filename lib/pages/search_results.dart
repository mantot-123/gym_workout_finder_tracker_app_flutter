import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../widgets/exercise_tile.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../models/exercise.dart";
import "../exercises_db_handler.dart";
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
    ExerciseSearch search = ExerciseSearch();
    results = search.getData(widget.type, widget.query);
  }


  // ADD EXERCISE TO SAVED LIST
  void saveExercise(BuildContext context, Exercise data) {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' successfully saved."));
      SavedExercisesDB.addToSavedExercises(data); // add
      SavedExercisesDB.updateSavedExercises();
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
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
      appBarTitle: "Search results for: ${widget.query}",
      body: FutureBuilder<dynamic>(
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
              List<Exercise> dataConverted = Exercise.fromMapList(snapshot.data.cast<Map<dynamic, dynamic>>()).cast<Exercise>();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataConverted.length,
                      itemBuilder: (context, index) {
                        // returns a Exercise list tile with either a delete or save button 
                        if(SavedExercisesDB.isExerciseSaved(dataConverted[index].id)) {
                          return ExerciseTile(data: dataConverted[index], actionBtnType: 1, actionBtnOnPressed: () {
                            removeSavedExercise(context, dataConverted[index]);
                          });
                        }

                        return ExerciseTile(data: dataConverted[index], actionBtnOnPressed: () {
                          saveExercise(context, dataConverted[index]);
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