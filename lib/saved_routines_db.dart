import "package:hive/hive.dart";
import "package:hive_flutter/adapters.dart";
import "package:hive_flutter/hive_flutter.dart";

class SavedRoutinesDB {
  static List<dynamic> savedRoutines = [];
  static late Box<dynamic> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TimeOfDayAdapter());

    if(!Hive.isBoxOpen("saved")) {
      box = await Hive.openBox<dynamic>("saved");
      loadSavedRoutines();
    }
  }
  
  static void loadSavedRoutines() {
    savedRoutines = box.get("workouts", defaultValue: [])!.cast<dynamic>();
  }

  static List getSavedRoutines() {
    return savedRoutines;
  }
}