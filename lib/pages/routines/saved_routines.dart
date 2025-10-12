import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/models/routine.dart";
import "package:gym_workout_finder_tracker_app_flutter/widgets/routines/saved_routines_list.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "edit_routine.dart";

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  // SCAFFOLD ACTION BUTTONS
  List<Widget> _buildActionBtns(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.refresh, color: Colors.black), onPressed: () {
        setState(() { });
      }),

      IconButton(icon: Icon(Icons.add, color: Colors.black), onPressed: () async {
        // NEW ROUTINE PAGE
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditRoutinePage(
            mode: 0, 
            data: Routine(
              id: "", 
              name: "", 
              timeStart: TimeOfDay.fromDateTime(DateTime.now()).format(context), 
              tasks: []
            )
          );
        }));

        setState(() { });
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Saved routines",
      body: SavedRoutinesList(),
      appBarActions: _buildActionBtns(context),
    );
  }
}