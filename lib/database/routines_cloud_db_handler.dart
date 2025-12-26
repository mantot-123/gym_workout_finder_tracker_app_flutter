import "dart:async";
import 'package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "../../models/routine.dart";

// TODO
class SavedRoutinesCloudDB implements RoutinesDBHandler {
  static final SavedRoutinesCloudDB _handler = SavedRoutinesCloudDB._internal();
  StreamSubscription<QuerySnapshot<Object?>>? _subscription;
  CollectionReference collection = FirebaseFirestore.instance.collection("routines");
  List<Routine> routines = [];
  bool _isSubscribed = false;

  SavedRoutinesCloudDB._internal();

  factory SavedRoutinesCloudDB() => _handler; 


  @override
  Future<void> init() async {
    await loadRoutines();
  }

  @override
  Future<void> loadRoutines() async {
    try {
      // Cancel existing subscription if it exists to prevent memory leaks
      if (_subscription != null && !_subscription!.isPaused) {
        await _subscription!.cancel();
        _subscription = null;
        _isSubscribed = false;
      }

      // Only create subscription if not already subscribed
      if (!_isSubscribed) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("Cannot load routines: User is not logged in");
        }

        _subscription = collection
          .where("user", isEqualTo: user.uid)
          .orderBy("creationDate")
          .snapshots()
          .listen(
            (snapshot) {
              routines.clear();
              for(var document in snapshot.docs) {
                try {
                  Map<dynamic, dynamic> map = document.data() as Map<dynamic, dynamic>;
                  Routine r = Routine.fromMap(map);
                  routines.add(r);
                } catch (e) {
                  print("Error parsing routine document ${document.id}: $e");
                }
              }
            },
            onError: (error) {
              print("Error in routines stream: $error");
            }
          );
        _isSubscribed = true;
      }
    } catch (e) {
      print("Error loading routines: $e");
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
      _isSubscribed = false;
    }
  }

  @override
  Routine? getRoutineByID(String id) {
    for(var routine in routines) {
      if(id == routine.id) {
        return routine;
      }
    }
    return null;
  }

  @override
  Future<List<Routine>> getAllRoutines() async {
    return routines;
  }

  @override
  Future<void> addRoutine(Routine routine) async {
    Map<String, dynamic> dataMap = routine.toMap().cast<String, dynamic>();
    dataMap["user"] = FirebaseAuth.instance.currentUser!.uid; // add the current logged in user id
    dataMap["creationDate"] = FieldValue.serverTimestamp();

    if(dataMap["id"] == "" || dataMap["id"] == null) {
      DocumentReference doc = await collection.add(dataMap);
      doc.update({
        "id" : doc.id
      });

    } else {
      await collection.doc(dataMap["id"]).set(dataMap); 
    }
  } 

  @override
  Future<void> updateRoutine(Routine routine) async {
    Map<String, dynamic> dataMap = routine.toMap().cast<String, dynamic>();
    dataMap["user"] = FirebaseAuth.instance.currentUser!.uid; // add the current logged in user id
    dataMap["creationDate"] = FieldValue.serverTimestamp();
    await collection.doc(dataMap["id"]).set(dataMap);
  }

  @override
  Future<void> deleteRoutine(Routine routine) async {
    await collection.doc(routine.id).delete();
  }

  // unneeded code - firebase already does the updating, so don't worry about this
  @override
  Future<void> updateDB() async {
    return;
  }

  @override
  bool isRoutineSaved(String id) {
    for(var r in routines) {
      if(r.id == id) {
        return true;
      }
    }
    return false;
  }
}