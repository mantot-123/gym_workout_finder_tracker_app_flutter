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
    savedWorkouts.remove(workout);
  }

  static void updateSavedWorkouts() {
    if(savedWorkouts.length > 0) {
      box.put("workouts", savedWorkouts);
    } else {
      box.put("workouts", null);
    }
  }

  static void getLatestWorkoutInfo() async {
    
  }

}