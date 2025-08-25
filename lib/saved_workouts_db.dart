import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "models/workout.dart";

class SavedWorkoutsDB {
  static List<Workout> savedWorkouts = [];
  static late Box<List<dynamic>> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    // initialises the database 
    await Hive.initFlutter();
    Hive.registerAdapter(WorkoutAdapter());

    if(!Hive.isBoxOpen("saved")) {
      box = await Hive.openBox<List<dynamic>>("saved");
      loadSavedWorkouts();
    }
    // box.clear();
  }

  static List getSavedWorkouts() {
    return savedWorkouts;
  }

  static void loadSavedWorkouts() {
    // savedWorkouts = (box.get("workouts") ?? []).cast<Workout>();
    savedWorkouts = box.get("workouts", defaultValue: [])!.cast<Workout>();
  }

  static void addToSavedWorkouts(Workout workout) {
    savedWorkouts.add(workout);
  }

  static void removeFromSavedWorkouts(Workout workout) {
    for(int i = 0; i < savedWorkouts.length; i++) {
      if(savedWorkouts[i].id == workout.id) {
        savedWorkouts.removeAt(i);
      }
    }
  }

  static void updateSavedWorkouts() {
    if(savedWorkouts.length > 0) {
      box.put("workouts", savedWorkouts);
    } else {
      box.put("workouts", []);
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