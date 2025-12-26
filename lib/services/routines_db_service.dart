import "package:firebase_auth/firebase_auth.dart";
import "package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart";
import "../database/routines_cloud_db_handler.dart";
import "../database/routines_local_db_handler.dart";
import "../models/routine.dart";

// Routines database service
// Detects user session, syncs and changes database handler
class RoutinesDBService {
  static RoutinesDBHandler dbHandler = SavedRoutinesLocalDB(); // by default, the service should use the local database
  static bool _isInitialized = false;

  /// Switches the database handler based on login state with proper cleanup and initialization
  static Future<void> switchDBHandlerByLoginState() async {
    try {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isCurrentlyCloud = dbHandler is SavedRoutinesCloudDB;
      
      // Only switch if the state actually changed
      if ((isLoggedIn && !isCurrentlyCloud) || (!isLoggedIn && isCurrentlyCloud)) {
        // When switching to cloud, don't close local handler yet - synchronise() needs it
        // When switching to local, close the cloud handler
        if (!isLoggedIn) {
          // Switching to local, close the cloud handler
          await dbHandler.close();
        }
        // If switching to cloud, keep local handler open for synchronise()
        
        // Switch to the appropriate handler
        if (isLoggedIn) {
          dbHandler = SavedRoutinesCloudDB();
        } else {
          dbHandler = SavedRoutinesLocalDB();
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
      print("Error switching routines DB handler: $e");
      // Fallback to local DB on error
      if (dbHandler is! SavedRoutinesLocalDB) {
        await dbHandler.close();
        dbHandler = SavedRoutinesLocalDB();
        await dbHandler.init();
      }
      rethrow;
    }
  }

  static Future<void> synchronise() async {
    try {
      RoutinesDBHandler localDBHandler = SavedRoutinesLocalDB();
      RoutinesDBHandler cloudDBHandler = SavedRoutinesCloudDB();

      // Initialize both handlers to ensure boxes are open
      await localDBHandler.init();
      await cloudDBHandler.init();
      
      // Create a copy of the routines list to avoid ConcurrentModificationError
      // when deleting items during iteration
      final routines = List<Routine>.from(await localDBHandler.getAllRoutines());
      for(var r in routines) {
        try {
          await cloudDBHandler.addRoutine(r);
          await localDBHandler.deleteRoutine(r);
        } catch (e) {
          print("Error syncing routine ${r.toString()}: $e");
          // Continue with next routine even if one fails
        }
      }
      
      // Close local handler after synchronisation is complete
      await localDBHandler.close();
    } catch (e) {
      print("Error during routines synchronisation: $e");
      rethrow;
    }
  }
}