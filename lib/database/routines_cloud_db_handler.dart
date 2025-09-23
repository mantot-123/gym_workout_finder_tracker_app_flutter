import 'package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart';
import "../../models/routine.dart";

// TODO
class SavedRoutinesCloudDB implements RoutinesDBHandler {
  @override
  Future<void> init() async {

  }

  @override
  Future<void> loadRoutines() async {

  }

  @override
  Routine? getRoutineByID(String id) {
    return null;
  }

  @override
  Future<List<Routine>> getAllRoutines() async {
    return [];
  }

  @override
  Future<void> addRoutine(Routine routine) async {

  } 

  @override
  Future<void> updateRoutine(Routine routine) async {

  }

  @override
  Future<void> deleteRoutine(Routine routine) async {

  }

  @override
  Future<void> updateDB() async {

  }
}