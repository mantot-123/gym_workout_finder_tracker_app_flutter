import 'package:flutter/material.dart';
import "../pages/exercise_info.dart";
import "../models/exercise.dart";

class ExerciseTile extends StatefulWidget {
  Exercise data;
  int actionBtnType; // ACTION BUTTON: 0 = SAVE Exercise, 1 = DELETE Exercise, 2 = NO BUTTON
  VoidCallback actionBtnOnPressed;
  ExerciseTile({ super.key, required this.data, this.actionBtnType = 0, required this.actionBtnOnPressed });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}


class _ExerciseTileState extends State<ExerciseTile> {
  // ACTION BUTTON SELECTOR METHOD
  Widget getActionBtn(BuildContext context) {
    List<Widget> actionBtnList = [
      IconButton(icon: Icon(Icons.save), onPressed: widget.actionBtnOnPressed), // save button
      IconButton(icon: Icon(Icons.delete), onPressed: widget.actionBtnOnPressed), // delete button
      SizedBox() // no button
    ];
    return actionBtnList[widget.actionBtnType];
  }

  @override
  Widget build(BuildContext context) {
    Widget actionBtn = getActionBtn(context);
    return ListTile(
      onTap: () { 
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ExerciseInfoPage(data: this.widget.data);
        })); 
      },
      title: Text(widget.data.name), 
      subtitle: Text(widget.data.description),
      leading: Icon(Icons.fitness_center),
      trailing: actionBtn
    );
  }
}