import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/exercises_db_handler.dart";
import "../database/exercises_cloud_db_handler.dart";
import "../database/exercises_local_db_handler.dart";
import "../models/exercise.dart";

// Exercises database service
// Detects user session, syncs and changes database handler
class ExercisesDBService {
  static ExercisesDBHandler dbHandler = SavedExercisesLocalDB();
  static bool _isInitialized = false;

  // Switches the database handler based on login state
  static Future<void> switchDBHandlerByLoginState() async {
    try {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isCurrentlyCloud = dbHandler is SavedExercisesCloudDB;
      
      // detect if the login state actually changed
      if ((isLoggedIn && !isCurrentlyCloud) || (!isLoggedIn && isCurrentlyCloud)) {

        // when logging out, swtitch to local, close the cloud handler
        if (!isLoggedIn) {
          // Switching to local, close the cloud handler
          await dbHandler.close();
        }
        
        // Switch to the right handler
        if (isLoggedIn) {
          dbHandler = SavedExercisesCloudDB();
        } else {
          dbHandler = SavedExercisesLocalDB();
        }
        
        // Initialize the new handler
        await dbHandler.init();
        _isInitialized = true;
      } else if (!_isInitialized) {
        // Ensure handler is initialized even if we didn't switch
        await dbHandler.init();
        _isInitialized = true;
      }
    } catch (e) {
      print("Error switching exercises DB handler: $e");
      // Fallback to local DB on error
      if (dbHandler is! SavedExercisesLocalDB) {
        await dbHandler.close();
        dbHandler = SavedExercisesLocalDB();
        await dbHandler.init();
      }
      rethrow;
    }
  }

  static Future<void> synchronise() async {
    try {
      ExercisesDBHandler localDBHandler = SavedExercisesLocalDB();
      ExercisesDBHandler cloudDBHandler = SavedExercisesCloudDB();

      // Initialize both handlers to ensure boxes are open
      await localDBHandler.init();
      await cloudDBHandler.init();
      
      // copy of the exercises list to avoid ConcurrentModificationError
      final exercises = List<Exercise>.from(await localDBHandler.getAllExercises());
      for(var e in exercises) {
        try {
          await cloudDBHandler.addExercise(e);
          await localDBHandler.deleteExercise(e);
        } catch (e) {
          print("Error syncing exercise ${e.toString()}: $e");
        }
      }
      
      // close local handler after local-to-cloud synchronisation is complete
      await localDBHandler.close();
    } catch (e) {
      print("Error during exercises synchronisation: $e");
      rethrow;
    }
  }
}