import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

class SavedRoutinesDB {
  static List<dynamic> savedRoutines = [];
  static late Box<dynamic> box;

  static void closeConn() {
    Hive.close();
  }

  static Future<void> initDb() async {
    await Hive.initFlutter();
    box = await Hive.openBox<dynamic>("saved");
  }
}