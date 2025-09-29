import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart";
import "package:gym_workout_finder_tracker_app_flutter/models/routine.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/routines_db_service.dart";
import "package:gym_workout_finder_tracker_app_flutter/services/exercises_db_service.dart";
import 'package:gym_workout_finder_tracker_app_flutter/widgets/routines/routine_tile.dart';
import 'package:gym_workout_finder_tracker_app_flutter/pages/routines/edit_routine.dart';
import 'package:gym_workout_finder_tracker_app_flutter/pages/routines/routine_info.dart';

class SavedRoutinesList extends StatefulWidget {
  const SavedRoutinesList({super.key});

  @override
  State<SavedRoutinesList> createState() => _SavedRoutinesListState();
}

class _SavedRoutinesListState extends State<SavedRoutinesList> {
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
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          ExercisesDBService.switchDBHandlerByLoginState();
          RoutinesDBService.switchDBHandlerByLoginState();
        }

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}