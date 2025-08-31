import 'package:flutter/material.dart';
import "../models/task.dart";

class RoutineTaskTable extends StatefulWidget {
  final List<Task> data;
  const RoutineTaskTable({super.key, required this.data });

  @override
  State<RoutineTaskTable> createState() => _RoutineTaskTableState();
}

class _RoutineTaskTableState extends State<RoutineTaskTable> {
  List<TableRow> buildRows() {
    List<TableRow> rows = [];
    for (var task in widget.data) {
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
            IconButton(icon: Icon(Icons.edit), onPressed: () {})
          ] 
        )
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Table(
        border: TableBorder(
          verticalInside: BorderSide(width: 1, color: Colors.grey), 
        ),
        children: [
          TableRow(
            children: [ // EXAMPLE LIST - TO BE REPLACED
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
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Military press", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("120", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("4", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("12", style: TextStyle(fontSize: 16)),
              ),
              IconButton(icon: Icon(Icons.edit), onPressed: () {})
            ] 
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bench press", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("120", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("4", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("12", style: TextStyle(fontSize: 16)),
              ),
              IconButton(icon: Icon(Icons.edit), onPressed: () {})
            ] 
          ),
          
        ]
      ),
    );
  }
}