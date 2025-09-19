import 'package:flutter/material.dart';
import "../../widgets/ui/ui_button.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "../../widgets/stats/stats_summary_tile.dart";
import "dart:io";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Home",
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back, Emman Ruiz!", style: TextStyle(fontSize: 30.0)),
            Text("Here is your workout summary:", style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: [
                  StatsSummaryTile(count: 5, caption: "exercises completed today", floatingIcon: Icons.fitness_center),
                  StatsSummaryTile(count: 120, caption: "minutes worked out today", floatingIcon: Icons.access_time),
                  StatsSummaryTile(count: 4, caption: "workout routines completed this week", floatingIcon: Icons.alarm_on_rounded),
                  StatsSummaryTile(count: 2.5, caption: "kg of weight gain from last week's weight", floatingIcon: Icons.scale),
                ]
              )
            )
          ],
        ),
      ) 
    );
  }
}