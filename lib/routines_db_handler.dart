import "package:hive/hive.dart";
import "package:hive_flutter/adapters.dart";
import "package:hive_flutter/hive_flutter.dart";
import "models/routine.dart";
import "models/workout.dart";
import "models/task.dart";

class SavedRoutinesDB {
  static List<Routine> savedRoutines = [];
  static late Box<List<dynamic>> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    Hive.registerAdapter(RoutineAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());

    if(!Hive.isBoxOpen("saved_routines")) {
      box = await Hive.openBox<List<dynamic>>("saved_routines");
    } else {
      box = Hive.box<List<dynamic>>("saved_routines");
    }

    loadSavedRoutines();
  }
  
  static List getSavedRoutines() {
    return savedRoutines;
  }

  static Routine? getRoutineById(String id) {
    for(var routine in savedRoutines) {
      if(id == routine.id) {
        return routine;
      }
    }
    return null;
  }

  static void loadSavedRoutines() {
    savedRoutines = box.get("routines", defaultValue: [])!.cast<Routine>();
  }

  static void addToSavedRoutines(Routine routine) {
    savedRoutines.add(routine);
  }

  static void removeFromSavedRoutines(Routine routine) {
    for(int i = 0; i < savedRoutines.length; i++) {
      if(savedRoutines[i].id == routine.id) {
        savedRoutines.removeAt(i);
        return;
      }
    }
  }

  // overwrite routine data in saved routines list if the given ID exists
  static void overwriteByID(Routine newRoutine) {
    for(int i = 0; i < savedRoutines.length; i++) {
      if(savedRoutines[i].id == newRoutine.id) {
        savedRoutines[i] = newRoutine;
        return;
      }
    }
  }

  static void updateSavedRoutines() {
    box.put("routines", savedRoutines);
  }

  static bool isRoutineSaved(String id) {
    for(var r in savedRoutines) {
      if(r.id == id) {
        return true;
      }
    }
    return false;
  }
}