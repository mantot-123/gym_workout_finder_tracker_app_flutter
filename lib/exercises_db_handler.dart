import "package:hive/hive.dart";
import "package:hive_flutter/adapters.dart";
import "package:hive_flutter/hive_flutter.dart";
import "models/routine.dart";
import "models/exercise.dart";
import "models/task.dart";

class SavedExercisesDB {
  static List<Exercise> savedExercises = [];
  static late Box<List<dynamic>> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    Hive.registerAdapter(ExerciseAdapter());

    if(!Hive.isBoxOpen("saved_exercises")) {
      box = await Hive.openBox<List<dynamic>>("saved_exercises");
    } else {
      box = Hive.box<List<dynamic>>("saved_exercises");
    }

    loadSavedExercises();
    // box.clear();
  }

  static List getSavedExercises() {
    return savedExercises;
  }

  static void loadSavedExercises() {
    savedExercises = box.get("exercises", defaultValue: [])!.cast<Exercise>();
  }

  static void addToSavedExercises(Exercise exercise) {
    savedExercises.add(exercise);
  }

  static void removeFromSavedExercises(Exercise exercise) {
    for(int i = 0; i < savedExercises.length; i++) {
      if(savedExercises[i].id == exercise.id) {
        savedExercises.removeAt(i);
        return;
      }
    }
  }

  static void updateSavedExercises() {
    if(savedExercises.length > 0) {
      box.put("exercises", savedExercises);
    } else {
      box.put("exercises", []);
    }
  }

  static bool isExerciseSaved(String id) {
    for(var e in savedExercises) {
      if(e.id == id) {
        return true;
      }
    }
    return false;
  }

}