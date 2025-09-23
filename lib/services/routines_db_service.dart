import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart";
import "../database/routines_cloud_db_handler.dart";
import "../database/routines_local_db_handler.dart";
import "../firebase_options.dart";

// Routines database service
// Detects user session, syncs and changes database handler
class RoutinesDBService {
  static RoutinesDBHandler dbHandler = SavedRoutinesLocalDB();

  static void switchDBHandlerByLoginState() {
    if(FirebaseAuth.instance.currentUser != null) {
      // todo switch to cloud database handler
      dbHandler = SavedRoutinesCloudDB();
    } else {
      dbHandler = SavedRoutinesLocalDB();
    }
  }

  static void synchronise() {

  }
}