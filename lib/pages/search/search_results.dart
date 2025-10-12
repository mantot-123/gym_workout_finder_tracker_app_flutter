import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../../widgets/exercises/exercise_tile.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "../../models/exercise.dart";
import "../../database/interfaces/exercises_db_handler.dart";
import "../../database/exercises_local_db_handler.dart";
import "../../api/exercise_search_api.dart";
import "../../services/exercises_db_service.dart";

class SearchResultsPage extends StatefulWidget {
  String type;
  String query;
  SearchResultsPage({super.key, required this.type, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  ExercisesDBHandler exercisesDB = ExercisesDBService.dbHandler;

  late Future<dynamic> results;

  @override
  void initState() {
    super.initState();
    ExerciseSearch search = ExerciseSearch();
    results = search.getData(widget.type, widget.query);
  }

  // ADD EXERCISE TO SAVED LIST
  Future<void> addExercise(BuildContext context, Exercise data) async {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' successfully saved."));
      exercisesDB.addExercise(data); // add
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }


  // REMOVE EXERCISE FROM SAVED LIST
  Future<void> deleteExercise(BuildContext context, Exercise data) async {
    setState(() {
      final msgBar = SnackBar(content: Text("Exercise '${data.name}' removed."));
      exercisesDB.deleteExercise(data); // remove
      ScaffoldMessenger.of(context).showSnackBar(msgBar);
    });
  }


  // LOADING ANIMATION WIDGET
  Widget _buildLoadingAnim() {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: Colors.lightGreen.shade900, size: 100
      )
    );
  }

  // CONNECTION ERROR WIDGET
  Widget _buildConnErrMsg() {
    return Center(
      child: Text("An error occurred while getting data. Check your internet connection and try again.", textAlign: TextAlign.center),
    );
  }

  // "NO SEARCH RESULTS" WIDGET
  Widget _buildNotFoundMsg() {
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

  // SEARCH RESULT LIST WIDGET
  Widget _buildResultsList(BuildContext context, dynamic data) {
    List<Exercise> dataConverted = Exercise.fromMapList(data.cast<Map<dynamic, dynamic>>()).cast<Exercise>();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: dataConverted.length,
            itemBuilder: (context, index) {
              // returns a Exercise list tile with either a delete or save button 
              if(exercisesDB.isExerciseSaved(dataConverted[index].id)) {
                return ExerciseTile(data: dataConverted[index], actionBtnType: 1, actionBtnOnPressed: () async {
                  await deleteExercise(context, dataConverted[index]);
                });
              }

              return ExerciseTile(data: dataConverted[index], actionBtnOnPressed: () async {
                await addExercise(context, dataConverted[index]);
              });
            }
          ),
        ),
      ],
    );
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
              return _buildLoadingAnim();
            } 
            else if(!snapshot!.hasData || snapshot.data!.isEmpty) {
              // print(snapshot.data);
              return _buildNotFoundMsg();
            } 
            else {
              // print(snapshot.data);
              return _buildResultsList(context, snapshot.data);
            }

          } catch(ex) {
            return _buildConnErrMsg();
          }
        }
      ),
    );
  }
}