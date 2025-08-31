import 'package:flutter/material.dart';
import "../models/routine.dart";

class RoutineTile extends StatefulWidget {
  Routine data;
  VoidCallback onEdit;
  VoidCallback onOpen;
  RoutineTile({ super.key, required this.data, required this.onOpen, required this.onEdit });

  @override
  State<RoutineTile> createState() => _RoutineTileState();
}


class _RoutineTileState extends State<RoutineTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onOpen,
      title: Text(widget.data.name), 
      subtitle: Text("Start: ${widget.data.timeStart.format(context)}"),
      leading: Icon(Icons.alarm),
      trailing: IconButton(icon: Icon(Icons.edit), onPressed: widget.onEdit),
    );
  }
}