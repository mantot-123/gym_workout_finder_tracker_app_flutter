import 'package:flutter/material.dart';
import "../widgets/ui/ui_button.dart";
import "../widgets/ui/ui_scaffold.dart";
import "../pages/new_routine.dart";
import "dart:io";

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Saved routines",
      scaffoldBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Saved routines", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.alarm, size: 60),
            SizedBox(height: 10),
            Text("You have not created your routines yet. Click on the '+' button above to start adding one", textAlign: TextAlign.center)
          ],
        )
      ),
      actionBtns: [
        IconButton(icon: Icon(Icons.add, color: Colors.black), onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewRoutinePage();
          }));
        })
      ],
    );
  }
}