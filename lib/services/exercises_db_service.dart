import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/exercises_db_handler.dart";
import "package:gym_workout_finder_tracker_app_flutter/models/exercise.dart";
import "../database/exercises_cloud_db_handler.dart";
import "../database/exercises_local_db_handler.dart";
import "../firebase_options.dart";

// Exercises database service
// Detects user session, syncs and changes database handler
class ExercisesDBService {
  static ExercisesDBHandler dbHandler = SavedExercisesLocalDB();

  static void switchDBHandlerByLoginState() {
    if(FirebaseAuth.instance.currentUser != null) {
      // todo switch to cloud database handler
      dbHandler = SavedExercisesCloudDB();
    } else {
      dbHandler = SavedExercisesLocalDB();
    }
  }

  static Future<void> synchronise() async {
    ExercisesDBHandler localDBHandler = SavedExercisesLocalDB();
    ExercisesDBHandler cloudDBHandler = SavedExercisesCloudDB();

    await cloudDBHandler.init();
    
    // move all exercises to cloud firestore
    for(var e in await localDBHandler.getAllExercises()) {
      await cloudDBHandler.addExercise(e);
      await localDBHandler.deleteExercise(e);
    }
  }
}