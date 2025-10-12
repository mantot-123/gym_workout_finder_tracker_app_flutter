import "dart:async";
import 'package:gym_workout_finder_tracker_app_flutter/database/interfaces/routines_db_handler.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "../../models/routine.dart";

// TODO
class SavedRoutinesCloudDB implements RoutinesDBHandler {
  static final SavedRoutinesCloudDB _handler = SavedRoutinesCloudDB._internal();
  late StreamSubscription<QuerySnapshot<Object?>> subscription;
  CollectionReference collection = FirebaseFirestore.instance.collection("routines");
  List<Routine> routines = [];

  SavedRoutinesCloudDB._internal();

  factory SavedRoutinesCloudDB() => _handler; 


  @override
  Future<void> init() async {
    await loadRoutines();
  }

  @override
  Future<void> loadRoutines() async {
    subscription = collection
      .where("user", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("creationDate")
      .snapshots().listen((snapshot) {
        routines.clear();
        for(var document in snapshot.docs) {
          Map<dynamic, dynamic> map = document.data() as Map<dynamic, dynamic>;
          Routine r = Routine.fromMap(map);
          routines.add(r);
        }
        print(routines);
      }
    );
  }

  @override
  Future<void> close() async {
    subscription.cancel();
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

  @override
  Future<void> updateDB() async { // REDUNDANT CODE - NO NEED TO UPDATE THE DATABASE SINCE FIREBASE ALREADY DOES THAT
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