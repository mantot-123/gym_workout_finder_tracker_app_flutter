import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart";
import "../database/routines_cloud_db_handler.dart";
import "../database/routines_local_db_handler.dart";
import "../firebase_options.dart";

// Routines database service
// Detects user session, syncs and changes database handler
class RoutinesDBService {
  static RoutinesDBHandler dbHandler = SavedRoutinesLocalDB(); // by default, the service should use the local database

  static void switchDBHandlerByLoginState() async {
    if(FirebaseAuth.instance.currentUser != null) {
      // todo switch to cloud database handler
      dbHandler = SavedRoutinesCloudDB();
    } else {
      dbHandler = SavedRoutinesLocalDB();
    }
  }

  static Future<void> synchronise() async {
    RoutinesDBHandler localDBHandler = SavedRoutinesLocalDB();
    RoutinesDBHandler cloudDBHandler = SavedRoutinesCloudDB();

    cloudDBHandler.init();
    
    for(var r in await localDBHandler.getAllRoutines()) {
      await cloudDBHandler.addRoutine(r);
      await localDBHandler.deleteRoutine(r);
    }
  }
}