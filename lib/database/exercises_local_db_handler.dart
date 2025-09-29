import "package:hive/hive.dart";
import "package:hive_flutter/adapters.dart";
import "package:hive_flutter/hive_flutter.dart";
import "interfaces/exercises_db_handler.dart";
import "../models/exercise.dart";

// singleton class to manage saved exercises
class SavedExercisesLocalDB implements ExercisesDBHandler {
  static final SavedExercisesLocalDB _handler = SavedExercisesLocalDB._internal();

  late Box<List<dynamic>> box;
  List<Exercise> savedExercises = [];

  SavedExercisesLocalDB._internal();

  factory SavedExercisesLocalDB() {
    return _handler;
  }

  @override
  Future<void> init() async {
    Hive.registerAdapter(ExerciseAdapter());
    if(!Hive.isBoxOpen("saved_exercises")) {
      box = await Hive.openBox<List<dynamic>>("saved_exercises");
    } else {
      box = Hive.box<List<dynamic>>("saved_exercises");
    }

    savedExercises = box.get("exercises", defaultValue: [])!.cast<Exercise>();
    // box.clear();
  }

  @override
  Future<void> close() async {
    await box.close();
  }

  @override
  Future<void> loadExercises() async {
    savedExercises = box.get("exercises", defaultValue: [])!.cast<Exercise>();
  }


  // GET EXERCISES
  @override
  Future<List<Exercise>> getAllExercises() async {
    return savedExercises;
  }

  // ADD EXERCISE
  @override
  Future<void> addExercise(Exercise exercise) async {
    savedExercises.add(exercise);
    await updateDB();
  }

  // UPDATE EXERCISE
  @override
  Future<void> updateExercise(Exercise exercise) async {
    for(int i = 0; i < savedExercises.length; i++) {
      if(savedExercises[i].id == exercise.id) {
        savedExercises[i] = exercise;
        await updateDB();
        return;
      }
    }
  }

  // DELETE EXERCISE
  @override
  Future<void> deleteExercise(Exercise exercise) async {
    // for(int i = 0; i < savedExercises.length; i++) {
    //   if(savedExercises[i].id == exercise.id) {
    //     savedExercises.removeAt(i);
    //     break;
    //   }
    // }
    savedExercises.removeWhere((e) => e.id == exercise.id);
    await updateDB();
  }

  @override
  Future<void> updateDB() async {
    box.put("exercises", savedExercises);
  }

  @override
  bool isExerciseSaved(String id) {
    for(var e in savedExercises) {
      if(e.id == id) {
        return true;
      }
    }
    return false;
  }

}