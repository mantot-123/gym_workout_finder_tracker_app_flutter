import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_input_box.dart";
import 'package:gym_workout_finder_tracker_app_flutter/widgets/ui/ui_scaffold.dart';
import "../models/routine.dart";
import "../models/task.dart";
import "../widgets/routine_task_table.dart";
import "../widgets/task_edit_dialog.dart";

class RoutineDetailsPage extends StatefulWidget {
  final Routine data;
  const RoutineDetailsPage({super.key, required this.data });

  @override
  State<RoutineDetailsPage> createState() => _RoutineDetailsPageState();
}

class _RoutineDetailsPageState extends State<RoutineDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: widget.data.name, 
      scaffoldBody: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            child: Text("Start time: ${widget.data.timeStart.format(context)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(child: ListView(
            children: [
              RoutineTaskTable(data: [])
            ]),
          )
        ],
      ),
      bottomActionBtn: FloatingActionButton(
        backgroundColor: Colors.lightGreen.shade400,
        child: Icon(Icons.add_task, color: Colors.black),
        onPressed: () async { // edit task dialog method
          TaskEditDialog dialog = TaskEditDialog(routine: widget.data, task: Task(name: "", restTimeSeconds: 0, sets: 0, reps: 0), mode: 0);
          await dialog.show(context);
        }
      )
    );
  }
}