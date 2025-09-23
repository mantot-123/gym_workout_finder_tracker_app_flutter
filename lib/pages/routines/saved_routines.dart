import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:gym_workout_finder_tracker_app_flutter/models/routine.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/routines_local_db_handler.dart";
import "../../widgets/ui/ui_button.dart";
import "../../widgets/ui/ui_scaffold.dart";
import "../../widgets/routines/routine_tile.dart";
import "../../database/interfaces/routines_db_handler.dart";
import "../../database/routines_local_db_handler.dart";
import "../../services/routines_db_service.dart";
import "routine_info.dart";
import "edit_routine.dart";


class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  RoutinesDBHandler routinesDB = RoutinesDBService.dbHandler;

  // EMPTY MESSAGE METHOD
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

  // LIST BUILDER METHOD
  Widget _buildRoutinesList(BuildContext context, List<Routine> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return RoutineTile(
          data: data![index], 
          onOpen: () async {
            // TODO OPEN ROUTINE DETAILS PAGE
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RoutineDetailsPage(data: data[index]);
            }));
          },
          onEdit: () async {
            // TODO EDIT ROUTINE
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditRoutinePage(mode: 1, data: data[index]);
            }));
    
            setState(() {});
          }
        );
      }
    );
  }

  // CONTENT BUILDER METHOD
  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
      future: routinesDB.getAllRoutines(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.lightGreen.shade900, size: 100
            )
          );
        } 
        else if(!snapshot.hasData) {
          return _buildEmptyRoutinesMsg();
        }

        return snapshot.data!.isNotEmpty
        ? _buildRoutinesList(context, snapshot.data!)
        : _buildEmptyRoutinesMsg();
      }
    );
  }

  // SCAFFOLD ACTION BUTTONS
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
      body: _buildContent(context),
      appBarActions: _buildActionBtns(context),
    );
  }
}