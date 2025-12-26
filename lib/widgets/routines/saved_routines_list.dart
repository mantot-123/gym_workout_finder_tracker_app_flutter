import 'dart:async';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
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
  bool? _previousAuthState;
  StreamSubscription<List<Routine>>? _dataSubscription;
  final StreamController<List<Routine>> _dataController = StreamController<List<Routine>>.broadcast();

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _dataController.close();
    super.dispose();
  }

  Future<void> _loadRoutines() async {
    try {
      // Always read from the current handler (not a cached reference)
      final routines = await RoutinesDBService.dbHandler.getAllRoutines();
      _dataController.add(routines);
    } catch (e) {
      print("Error loading routines: $e");
      _dataController.addError(e);
    }
  }

  Future<void> _handleAuthStateChange(bool isLoggedIn) async {
    // Only switch if auth state actually changed
    if (_previousAuthState != isLoggedIn) {
      _previousAuthState = isLoggedIn;
      try {
        await ExercisesDBService.switchDBHandlerByLoginState();
        await RoutinesDBService.switchDBHandlerByLoginState();
        // Reload routines after handler switch
        await _loadRoutines();
      } catch (e) {
        print("Error switching DB handlers: $e");
      }
    }
  }

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
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RoutineDetailsPage(data: data![index]);
            }));
            // Reload after viewing
            _loadRoutines();
          },
          onEdit: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditRoutinePage(mode: 1, data: data![index]);
            }));
            // Reload after editing
            _loadRoutines();
          }
        );
      }
    );
  }

  // CONTENT BUILDER METHOD
  Widget _buildContent(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Handle auth state changes without side effects in builder
        if (authSnapshot.connectionState == ConnectionState.active) {
          final isLoggedIn = authSnapshot.hasData;
          _handleAuthStateChange(isLoggedIn);
        }

        // Stream routines data
        return StreamBuilder<List<Routine>>(
          stream: _dataController.stream,
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting && !dataSnapshot.hasData) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.lightGreen.shade900, size: 100
                )
              );
            }
            
            if (dataSnapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 10),
                    Text("Error loading routines", textAlign: TextAlign.center),
                    TextButton(
                      onPressed: _loadRoutines,
                      child: Text("Retry")
                    )
                  ],
                )
              );
            }

            final routines = dataSnapshot.data ?? [];
            return routines.isNotEmpty
                ? _buildRoutinesList(context, routines)
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