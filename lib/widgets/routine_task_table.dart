import 'package:flutter/material.dart';
import "../widgets/task_edit_dialog.dart";
import 'package:gym_workout_finder_tracker_app_flutter/models/routine.dart';
import "../models/task.dart";

class RoutineTaskTable extends StatefulWidget {
  final Routine data;
  const RoutineTaskTable({super.key, required this.data });

  @override
  State<RoutineTaskTable> createState() => _RoutineTaskTableState();
}

class _RoutineTaskTableState extends State<RoutineTaskTable> {
  List<TableRow> rows = [];

  @override
  void initState() {
    super.initState();
  }

  void buildRows() {
    if(rows.isNotEmpty) {
      rows = [];
    } 
    
    // ADDING A COLUMN HEADER ROW
    rows.add(
      TableRow(
        children: [ 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Overused Grotesk Bold", fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Rest (secs)", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Overused Grotesk Bold", fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Sets", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Overused Grotesk Bold", fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Reps", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Overused Grotesk Bold", fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Overused Grotesk Bold", fontSize: 16)),
          ),
        ] 
      )
    );


    // ADDING THE DATA ROWS
    for (var task in widget.data.tasks) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(task.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${task.restTimeSeconds}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${task.sets}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${task.reps}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            IconButton(icon: Icon(Icons.edit), onPressed: () async {
              TaskEditDialog dialog = TaskEditDialog(
                routine: widget.data, 
                task: task, 
                mode: 1
              );
              await dialog.show(context);
              setState(() {});
            })
          ] 
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    buildRows();
    return Container(
      padding: EdgeInsets.all(20),
      child: widget.data.tasks.isNotEmpty 
      ? Table(
        border: TableBorder(
          verticalInside: BorderSide(width: 1, color: Colors.grey), 
        ),
        children: rows
      )
      : Center(child: Text("No exercises are added yet. Go add some."))
    );
  }

}