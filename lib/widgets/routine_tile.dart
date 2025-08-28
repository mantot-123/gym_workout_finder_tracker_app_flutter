import 'package:flutter/material.dart';
import "../pages/workout_info.dart";
import "../pages/edit_routine.dart";
import "../models/workout.dart";
import "../models/routine.dart";
import "../workouts_db_handler.dart";

class RoutineTile extends StatefulWidget {
  Routine data;
  RoutineTile({ super.key, required this.data });

  @override
  State<RoutineTile> createState() => _RoutineTileState();
}


class _RoutineTileState extends State<RoutineTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () { 
        // TODO: OPEN ROUTINE PAGE
        
      },

      title: Text(widget.data.name), 
      subtitle: Text("Start: ${widget.data.timeStart.format(context)}"),
      leading: Icon(Icons.alarm),
      trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
        // TODO: ADD DIALOG TO EDIT ROUTINE
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditRoutinePage(data: widget.data);
        }));
      }),
    );
  }
}