import 'package:gym_workout_finder_tracker_app_flutter/database/interfaces/exercises_db_handler.dart';
import "../../models/exercise.dart";

// TODO
class SavedExercisesCloudDB implements ExercisesDBHandler {
  @override
  Future<void> init() async {

  }

  @override
  Future<void> loadExercises() async {
    
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    return [];
  }

  @override
  Future<void> addExercise(Exercise exercise) async {
    
  }

  @override
  Future<void> updateExercise(Exercise exercise) async {

  } // finds an exercise with a matching ID then overwrites that

  @override
  Future<void> deleteExercise(Exercise exercise) async  {

  } 

  @override
  Future<void> updateDB() async {

  }

  @override
  bool isExerciseSaved(String id) {
    return true;
  }
}