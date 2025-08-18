import 'package:flutter/material.dart';
import "../pages/workout_info_page.dart";
import "../db.dart";

class WorkoutTile extends StatefulWidget {
  Map<dynamic, dynamic> data;
  int actionBtnType; // ACTION BUTTON: 0 = SAVE WORKOUT, 1 = DELETE WORKOUT, 2 = NO BUTTON
  VoidCallback actionBtnOnPressed;
  WorkoutTile({ super.key, required this.data, this.actionBtnType = 0, required this.actionBtnOnPressed });

  @override
  State<WorkoutTile> createState() => _WorkoutTileState();
}


class _WorkoutTileState extends State<WorkoutTile> {
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
          return WorkoutInfoPage(data: this.widget.data);
        })); 
      },
      title: Text(widget.data["name"]), 
      subtitle: Text(widget.data["description"]),
      leading: Icon(Icons.fitness_center),
      trailing: actionBtn
    );
  }
}