import 'package:flutter/material.dart';
import "package:gym_workout_finder_tracker_app_flutter/models/routine.dart";
import "package:gym_workout_finder_tracker_app_flutter/routines_db_handler.dart";
import "../../widgets/ui/ui_button.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "../../widgets/routines/routine_tile.dart";
import "routine_info.dart";
import "edit_routine.dart";

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  Widget _buildEmptyRoutinesMsg() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saved routines", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(Icons.alarm, size: 60),
          SizedBox(height: 10),
          Text("You have not created your routines yet. Click on the '+' button above to start adding one", textAlign: TextAlign.center)
        ],
      )
    );
  }

  Widget _buildSavedRoutinesList(BuildContext context) {
    return ListView.builder(
      itemCount: SavedRoutinesDB.getSavedRoutines().length,
      itemBuilder: (context, index) {
        return RoutineTile(
          data: SavedRoutinesDB.getSavedRoutines()[index], 
          onOpen: () async {
            // TODO OPEN ROUTINE DETAILS PAGE
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RoutineDetailsPage(data: SavedRoutinesDB.getSavedRoutines()[index]);
            }));
          },
          onEdit: () async {
            // TODO EDIT ROUTINE
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditRoutinePage(mode: 1, data: SavedRoutinesDB.getSavedRoutines()[index]);
            }));

            setState(() {});
          }
        );
      }
    );
  }

  List<Widget> _buildActionBtns(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.refresh, color: Colors.black), onPressed: () {
        setState(() { });
      }),

      IconButton(icon: Icon(Icons.add, color: Colors.black), onPressed: () async {
        // NEW ROUTINE PAGE
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditRoutinePage(mode: 0, data: Routine(id: "", name: "", timeStart: TimeOfDay.now(), tasks: []));
        }));

        setState(() { });
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Saved routines",
      body: 
        SavedRoutinesDB.getSavedRoutines().isEmpty
        ? _buildEmptyRoutinesMsg()
        : _buildSavedRoutinesList(context),

      appBarActions: _buildActionBtns(context),
    );
  }
}