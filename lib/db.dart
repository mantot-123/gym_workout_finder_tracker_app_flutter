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

  static void loadSavedWorkouts() {
    savedWorkouts = box.get("workouts") ?? [];
  }

  static void addToSavedWorkouts(Map<String, dynamic> workout) {
    savedWorkouts.add(workout);
  }

  static void updateSavedWorkouts() {
    box.put("workouts", savedWorkouts);
  }

  static void getLatestWorkoutInfo() async {
    
  }

}