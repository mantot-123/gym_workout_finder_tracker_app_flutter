import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "../components/workout_tile.dart";
import "../components/ui_scaffold.dart";
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

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Search results for: ${widget.query}",
      scaffoldBody: FutureBuilder<dynamic>(
        future: results,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.lightGreen.shade900, size: 100
              )
            );
          } 
          else if(snapshot.hasError) {
            return Center(child: Text("An error occurrred while getting data. Check your internet connection and try again."));
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
                      return WorkoutTile(data: snapshot.data[index]);
                    }
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}