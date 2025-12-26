import "dart:async";
import "package:firebase_auth/firebase_auth.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:flutter/material.dart";
import "exercise_tile.dart";
import "../../models/exercise.dart";
import "../../services/exercises_db_service.dart";

class SavedExercisesList extends StatefulWidget {
  final int actionBtnType;
  final Function actionBtnOnPressed;
  const SavedExercisesList({super.key, required this.actionBtnType, required this.actionBtnOnPressed});

  @override
  State<SavedExercisesList> createState() => _SavedExercisesListState();
}

class _SavedExercisesListState extends State<SavedExercisesList> {
  bool? _previousAuthState;
  StreamSubscription<List<Exercise>>? _dataSubscription;
  final StreamController<List<Exercise>> _dataController = StreamController<List<Exercise>>.broadcast();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _dataController.close();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    try {
      // Always read from the current handler (not a cached reference)
      final exercises = await ExercisesDBService.dbHandler.getAllExercises();
      _dataController.add(exercises);
    } catch (e) {
      print("Error loading exercises: $e");
      _dataController.addError(e);
    }
  }

  Future<void> _handleAuthStateChange(bool isLoggedIn) async {
    // Only switch if auth state actually changed
    if (_previousAuthState != isLoggedIn) {
      _previousAuthState = isLoggedIn;
      try {
        await ExercisesDBService.switchDBHandlerByLoginState();
        // Reload exercises after handler switch
        await _loadExercises();
      } catch (e) {
        print("Error switching exercises DB handler: $e");
      }
    }
  }

  Widget _buildList(BuildContext context, List<Exercise> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ExerciseTile(
          data: data![index], 
          actionBtnType: widget.actionBtnType,
          actionBtnOnPressed: () {
            widget.actionBtnOnPressed(data![index]);
            // Reload after action
            _loadExercises();
          }
        );
      }
    );
  }

  Widget _buildExercisesEmptyMsg(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saved exercises", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(Icons.save, size: 60),
          SizedBox(height: 10),
          Text("You have not saved any exercises yet.\nTry searching some exercises to get started.", textAlign: TextAlign.center)
        ],
      )
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Handle auth state changes without side effects in builder
        if (authSnapshot.connectionState == ConnectionState.active) {
          final isLoggedIn = authSnapshot.hasData;
          _handleAuthStateChange(isLoggedIn);
        }

        // Stream exercises data
        return StreamBuilder<List<Exercise>>(
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
                    Text("Error loading exercises", textAlign: TextAlign.center),
                    TextButton(
                      onPressed: _loadExercises,
                      child: Text("Retry")
                    )
                  ],
                )
              );
            }

            final exercises = dataSnapshot.data ?? [];
            return exercises.isNotEmpty
                ? _buildList(context, exercises)
                : _buildExercisesEmptyMsg(context);
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