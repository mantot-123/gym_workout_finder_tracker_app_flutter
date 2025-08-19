import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "models/workout.dart";

class WorkoutsDB {
  static List<Workout> savedWorkouts = [];
  static late Box<List<Workout>?> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    // initialises the database 
    await Hive.initFlutter();
    Hive.registerAdapter(WorkoutAdapter());
    box = await Hive.openBox<List<Workout>?>("saved");
    loadSavedWorkouts();
  }

  static List getSavedWorkouts() {
    return savedWorkouts;
  }

  static void loadSavedWorkouts() {
    savedWorkouts = box.get("workouts") ?? [];
  }

  static void addToSavedWorkouts(Map<dynamic, dynamic> workout) {
    Workout data = Workout.fromMap(workout);
    savedWorkouts.add(data);
  }

  static void removeFromSavedWorkouts(Map<dynamic, dynamic> workout) {
    for(int i = 0; i < savedWorkouts.length; i++) {
      if(savedWorkouts[i].id == workout["id"]) {
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
    for(var w in savedWorkouts) {
      if(w.id == id) {
        return true;
      }
    }
    return false;
  }

}