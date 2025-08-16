import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

class WorkoutsDB {
  static List<Map<String, dynamic>> savedWorkouts = [];
  static late Box box;

  static Future<void> initDb() async {
    // initialises the database 
    await Hive.initFlutter();
    box = await Hive.openBox("saved");
  }

  static List getSavedWorkouts() {
    return savedWorkouts;
  }

  static void loadSavedWorkouts() {
    savedWorkouts = box.get("workouts") ?? [];
  }

  static void addToSavedWorkouts(Map<String, dynamic> workout) {
    savedWorkouts.add(workout);
  }

  static void removeFromSavedWorkouts(Map<String, dynamic> workout) {
    for(int i = 0; i < savedWorkouts.length; i++) {
      if(savedWorkouts[i]["id"] == workout["id"]) {
        savedWorkouts.removeAt(i);
      }
    }
  }

  static void updateSavedWorkouts() {
    if(savedWorkouts.length > 0) {
      box.put("workouts", savedWorkouts);
    } else {
      box.put("workouts", null);
    }
  }

  static bool isWorkoutSaved(String id) {
    for(var w in WorkoutsDB.getSavedWorkouts()) {
      if(w["id"] == id) {
        return true;
      }
    }
    return false;
  }

}