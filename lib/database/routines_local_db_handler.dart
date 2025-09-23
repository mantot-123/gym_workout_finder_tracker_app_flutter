import "package:hive/hive.dart";
import "package:hive_flutter/adapters.dart";
import "package:hive_flutter/hive_flutter.dart";
import "interfaces/routines_db_handler.dart";
import "../models/routine.dart";
import "../models/task.dart";

class SavedRoutinesLocalDB implements RoutinesDBHandler {
  static final SavedRoutinesLocalDB _handler = SavedRoutinesLocalDB._internal();

  late Box<List<dynamic>> box;
  List<Routine> savedRoutines = [];

  SavedRoutinesLocalDB._internal();

  // singleton class
  factory SavedRoutinesLocalDB() {
    return _handler;
  }

  @override
  Future<void> init() async {
    Hive.registerAdapter(RoutineAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());

    if(!Hive.isBoxOpen("saved_routines")) {
      box = await Hive.openBox<List<dynamic>>("saved_routines");
    } else {
      box = Hive.box<List<dynamic>>("saved_routines");
    }

    savedRoutines = box.get("routines", defaultValue: [])!.cast<Routine>();
  }

  @override
  Future<void> loadRoutines() async {
    savedRoutines = box.get("routines", defaultValue: [])!.cast<Routine>();
  }

  @override
  Routine? getRoutineByID(String id) {
    for(var routine in savedRoutines) {
      if(id == routine.id) {
        return routine;
      }
    }
    return null;
  }

    // GET ALL ROUTINES
  @override
  Future<List<Routine>> getAllRoutines() async {
    return savedRoutines;
  }

  // ADD ROUTINE
  @override
  Future<void> addRoutine(Routine routine) async {
    savedRoutines.add(routine);
    await updateDB();
  }

  // EDIT ROUTINE
  // overwrite routine data in saved routines list if the given ID exists
  @override
  Future<void> updateRoutine(Routine newRoutine) async {
    for(int i = 0; i < savedRoutines.length; i++) {
      if(savedRoutines[i].id == newRoutine.id) {
        savedRoutines[i] = newRoutine;
        await updateDB();
        return;
      }
    }
  }

  // DELETE ROUTINE
  @override
  Future<void> deleteRoutine(Routine routine) async {
    // for(int i = 0; i < savedRoutines.length; i++) {
    //   if(savedRoutines[i].id == routine.id) {
    //     savedRoutines.removeAt(i);
    //     await updateDB();
    //     return;
    //   }
    // }
    savedRoutines.removeWhere((r) => r.id == routine.id);
    await updateDB();
  }

  @override
  Future<void> updateDB() async {
    box.put("routines", savedRoutines);
  }


  bool isRoutineSaved(String id) {
    for(var r in savedRoutines) {
      if(r.id == id) {
        return true;
      }
    }
    return false;
  }
}